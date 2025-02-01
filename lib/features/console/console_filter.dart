import 'package:consoleapp/features/console/console_exporter.dart';
import 'package:consoleapp/features/console/console_filter_log_level_panel.dart';
import 'package:consoleapp/services/apps_connect_service.dart';
import 'package:flutter/material.dart';

class ConsoleFilterController extends ChangeNotifier {
  String? filterText;
  bool filterLogLevelDebug = true;
  bool filterLogLevelInfo = true;
  bool filterLogLevelWarn = true;
  bool filterLogLevelError = true;
}

class ConsoleFilter extends StatefulWidget {
  final ConsoleFilterController controller;

  const ConsoleFilter({
    super.key,
    required this.controller,
  });

  @override
  State<ConsoleFilter> createState() => _ConsoleFilterState();
}

class _ConsoleFilterState extends State<ConsoleFilter> {
  final filterTextController = TextEditingController();

  @override
  void dispose() {
    filterTextController.removeListener(onFilterTextChanged);
    widget.controller.removeListener(onFilterChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    filterTextController.text = widget.controller.filterText ?? "";
    filterTextController.addListener(onFilterTextChanged);
    widget.controller.addListener(onFilterChanged);
  }

  void onFilterTextChanged() {
    widget.controller.filterText = filterTextController.text;
    widget.controller.notifyListeners();
  }

  void onFilterChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: _renderFilterText(context),
          ),
          const SizedBox(width: 12),
          _renderFilterLevel(),
          _renderExportButton(),
          _renderClearButton(),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Tooltip _renderClearButton() {
    return Tooltip(
      message: "清空日志",
      child: MaterialButton(
        onPressed: () {
          AppsConnectService.shared.clearConsoleLogs();
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: 0,
        child: const Icon(
          Icons.delete_outline,
          size: 18,
        ),
      ),
    );
  }

  Tooltip _renderExportButton() {
    return Tooltip(
      message: "导出",
      child: MaterialButton(
        onPressed: () {
          ConsoleExporter.exportWithFilter(widget.controller);
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: 0,
        child: const Icon(
          Icons.save_alt,
          size: 18,
        ),
      ),
    );
  }

  Tooltip _renderFilterLevel() {
    String filterStr = [
      widget.controller.filterLogLevelDebug ? "Debug" : "",
      widget.controller.filterLogLevelInfo ? "Info" : "",
      widget.controller.filterLogLevelWarn ? "Warn" : "",
      widget.controller.filterLogLevelError ? "Error" : "",
    ].where((it) => it.isNotEmpty).join(" + ");
    if (filterStr.isEmpty) {
      filterStr = "None";
    }
    return Tooltip(
      message: "选择日志等级",
      child: MaterialButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ConsoleFilterLogLevelPanel(controller: widget.controller);
            },
            barrierColor: Colors.transparent,
          );
        },
        child: Row(
          children: [
            Text(
              filterStr,
              style: const TextStyle(fontSize: 12),
            ),
            const Icon(
              Icons.arrow_drop_down,
              size: 24,
            )
          ],
        ),
      ),
    );
  }

  Container _renderFilterText(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 245, 245),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const SizedBox(width: 6),
          Icon(
            Icons.filter_alt,
            size: 12,
            color: Theme.of(context).hintColor,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: filterTextController,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
                hintText: "按关键词过滤",
                contentPadding: const EdgeInsets.only(bottom: 18),
              ),
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}

