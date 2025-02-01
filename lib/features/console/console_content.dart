import 'dart:convert';

import 'package:consoleapp/features/console/console_filter.dart';
import 'package:consoleapp/protocols/protocol_console.dart';
import 'package:consoleapp/services/apps_connect_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsoleContent extends StatefulWidget {
  final ConsoleFilterController controller;
  const ConsoleContent({super.key, required this.controller});

  @override
  State<ConsoleContent> createState() => _ConsoleContentState();
}

class _ConsoleContentState extends State<ConsoleContent> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    AppsConnectService.shared.removeListener(onMessageChanged);
    widget.controller.removeListener(onFilterChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    AppsConnectService.shared.addListener(onMessageChanged);
    widget.controller.addListener(onFilterChanged);
  }

  void onMessageChanged() {
    setState(() {});
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      if (!mounted) return;
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent - 100) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  void onFilterChanged() {
    setState(() {});
    scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final displayingLevels = [];
    if (widget.controller.filterLogLevelDebug) {
      displayingLevels.add("debug");
    }
    if (widget.controller.filterLogLevelInfo) {
      displayingLevels.add("info");
    }
    if (widget.controller.filterLogLevelWarn) {
      displayingLevels.add("warn");
    }
    if (widget.controller.filterLogLevelError) {
      displayingLevels.add("error");
    }
    final messages = AppsConnectService.shared.allMessages
        .whereType<ProtoConsole>()
        .where((it) {
      final filterText = widget.controller.filterText;
      if (filterText == null || filterText == "") {
        return true;
      }
      return it.logContent.contains(filterText);
    }).where((it) {
      return displayingLevels.contains(it.logLevel);
    }).where((it) {
      if (AppsConnectService.shared.selectedDevice != null) {
        return it.deviceId ==
            AppsConnectService.shared.selectedDevice?.deviceId;
      } else {
        return true;
      }
    }).toList();
    return SelectionArea(
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        itemBuilder: (context, index) {
          return _renderLogItem(messages[index]);
        },
        separatorBuilder: (context, index) {
          return Divider(height: 6, color: Theme.of(context).dividerColor);
        },
        itemCount: messages.length,
      ),
    );
  }

  Widget _renderLogItem(ProtoConsole message) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(message.createdAt);
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss:S');
    final formattedDateTimeString = formatter.format(dateTime);
    final logTagContent =
        message.logTag.isNotEmpty ? "[${message.logTag}] " : "";
    final content =
        message.logContentType == "image" ? "点击查看图片" : message.logContent;
    return GestureDetector(
      onTap: message.logContentType == "image"
          ? () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.memory(
                          base64.decode(message.logContent),
                          height: MediaQuery.of(context).size.height * 0.8,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('图片加载失败');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          : null,
      child: Text(
        "$formattedDateTimeString > $logTagContent$content",
        style: TextStyle(
          fontSize: 14,
          color: _getLogLevelColor(message.logLevel),
        ),
      ),
    );
  }

  Color _getLogLevelColor(String logLevel) {
    switch (logLevel) {
      case "debug":
        return Colors.blue;
      case "info":
        return Colors.black;
      case "warn":
        return Colors.orange;
      case "error":
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
