import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Logger {
  Logger._();

  static File? _file;
  static final List<String> _memoryLogs = [];
  static const int _maxMemoryLogs = 200;

  static Future<File> get _getFile async {
    if (_file != null) return _file!;
    final dir = await getApplicationDocumentsDirectory();
    _file = File('${dir.path}/feedplan_errors.log');
    if (!await _file!.exists()) {
      await _file!.create(recursive: true);
    }
    return _file!;
  }

  static Future<void> logError(String message, {String? context, StackTrace? stackTrace}) async {
    final timestamp = DateTime.now().toIso8601String();
    final buffer = StringBuffer();
    buffer.writeln('[$timestamp] ERROR');
    if (context != null) buffer.writeln('  Context: $context');
    buffer.writeln('  Message: $message');
    if (stackTrace != null) {
      buffer.writeln('  Stacktrace:');
      buffer.writeln(stackTrace.toString().split('\n').take(10).join('\n  '));
    }
    buffer.writeln('---');

    final entry = buffer.toString();
    _memoryLogs.add(entry);
    if (_memoryLogs.length > _maxMemoryLogs) {
      _memoryLogs.removeAt(0);
    }

    try {
      final file = await _getFile;
      await file.writeAsString(entry, mode: FileMode.append);
    } catch (_) {
      // Silent fail if file write fails
    }
  }

  static Future<void> logInfo(String message, {String? context}) async {
    final timestamp = DateTime.now().toIso8601String();
    final entry = '[$timestamp] INFO${context != null ? ' [$context]' : ''}: $message\n';

    _memoryLogs.add(entry);
    if (_memoryLogs.length > _maxMemoryLogs) {
      _memoryLogs.removeAt(0);
    }

    try {
      final file = await _getFile;
      await file.writeAsString(entry, mode: FileMode.append);
    } catch (_) {}
  }

  static List<String> getMemoryLogs() => List.unmodifiable(_memoryLogs);

  static Future<String> getFileLogs() async {
    try {
      final file = await _getFile;
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (_) {}
    return '';
  }

  static Future<void> clearLogs() async {
    _memoryLogs.clear();
    try {
      final file = await _getFile;
      if (await file.exists()) {
        await file.writeAsString('');
      }
    } catch (_) {}
  }
}
