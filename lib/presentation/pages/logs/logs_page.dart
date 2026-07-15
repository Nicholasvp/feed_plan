import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/utils/logger.dart';
import '../../../l10n/generated/app_localizations.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  String _logs = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await Logger.getFileLogs();
    setState(() {
      _logs = logs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.errorLogs),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: l10n.copyLogs,
            onPressed: _logs.isEmpty
                ? null
                : () {
                    Clipboard.setData(ClipboardData(text: _logs));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.logsCopied)),
                    );
                  },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.clearLogs,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.clearLogsConfirm),
                  content: Text(l10n.clearLogsMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.clearLogs),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await Logger.clearLogs();
                _loadLogs();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: _loadLogs,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SelectableText(
              _logs,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
    );
  }
}
