import 'dart:convert';

import 'package:consoleapp/features/console/console_filter.dart';
import 'package:consoleapp/protocols/protocol_console.dart';
import 'package:consoleapp/services/apps_connect_service.dart';
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';

class ConsoleExporter {
  static void exportWithFilter(ConsoleFilterController controller) {
    final displayingLevels = [];
    if (controller.filterLogLevelDebug) {
      displayingLevels.add("debug");
    }
    if (controller.filterLogLevelInfo) {
      displayingLevels.add("info");
    }
    if (controller.filterLogLevelWarn) {
      displayingLevels.add("warn");
    }
    if (controller.filterLogLevelError) {
      displayingLevels.add("error");
    }
    final messages = AppsConnectService.shared.allMessages
        .whereType<ProtoConsole>()
        .where((it) {
      final filterText = controller.filterText;
      if (filterText == null || filterText == "") {
        return true;
      }
      return it.logContent.contains(filterText);
    }).where((it) {
      return displayingLevels.contains(it.logLevel);
    }).toList();
    final fileContent = messages.map((message) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(message.createdAt);
      final formatter = DateFormat('yyyy-MM-dd HH:mm:ss:S');
      final formattedDateTimeString = formatter.format(dateTime);
      final logTagContent =
          message.logTag.isNotEmpty ? "[${message.logTag}] " : "";
      return "[${message.logLevel}] $formattedDateTimeString > $logTagContent${message.logContent}";
    }).join("\n");
    final fileName =
        "log_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}";
    FileSaver.instance.saveAs(
      name: fileName,
      bytes: utf8.encode(fileContent),
      ext: "txt",
      mimeType: MimeType.text,
    );
  }
}
