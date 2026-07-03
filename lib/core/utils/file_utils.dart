import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../utils/logger.dart';

class FileUtils {
  FileUtils._();

  static String sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(RegExp(r'\s+'), '_');
  }

  static String exportFileName(int index, String extension) {
    final paddedIndex = index.toString().padLeft(2, '0');
    return '${paddedIndex}_feedplan.$extension';
  }

  static String fileExtension(String path) {
    return p.extension(path).replaceAll('.', '');
  }

  static String fileName(String path) {
    return p.basename(path);
  }

  static Future<Directory> getStorageDirectory() async {
    if (Platform.isMacOS) {
      final home = Platform.environment['HOME'];
      if (home != null) {
        final dir = Directory('$home/Library/Application Support/feedplan/images');
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        return dir;
      }
    }
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/images');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<String> copyToPermanentStorage(String sourcePath) async {
    Logger.logInfo('Copying image to permanent storage', context: 'FileUtils');
    Logger.logInfo('Source path: $sourcePath', context: 'FileUtils');
    
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      Logger.logError('Source file not found: $sourcePath', context: 'FileUtils');
      throw Exception('Source file not found: $sourcePath');
    }

    final imagesDir = await getStorageDirectory();
    Logger.logInfo('Images directory: ${imagesDir.path}', context: 'FileUtils');

    final ext = p.extension(sourcePath);
    final fileName = '${const Uuid().v4()}$ext';
    final destPath = '${imagesDir.path}/$fileName';
    
    Logger.logInfo('Destination path: $destPath', context: 'FileUtils');

    await sourceFile.copy(destPath);
    
    final destFile = File(destPath);
    if (await destFile.exists()) {
      Logger.logInfo('Copy successful, file size: ${await destFile.length()}', context: 'FileUtils');
    } else {
      Logger.logError('Copy failed - destination file not found', context: 'FileUtils');
    }
    
    return destPath;
  }
}
