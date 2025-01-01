import 'package:consoleapp/features/console/console_exporter.dart';
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
          const SizedBox(width: 12),
        ],
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

class ConsoleFilterLogLevelPanel extends StatefulWidget {
  final ConsoleFilterController controller;
  const ConsoleFilterLogLevelPanel({super.key, required this.controller});

  @override
  State<ConsoleFilterLogLevelPanel> createState() =>
      _ConsoleFilterLogLevelPanelState();
}

class _ConsoleFilterLogLevelPanelState
    extends State<ConsoleFilterLogLevelPanel> {
  @override
  void dispose() {
    widget.controller.removeListener(onFilterChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onFilterChanged);
  }

  void onFilterChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            top: 44,
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            height: 44,
            width: 44,
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          Positioned(
            right: 44,
            top: 44,
            width: 200,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      widget.controller.filterLogLevelDebug =
                          !widget.controller.filterLogLevelDebug;
                      widget.controller.notifyListeners();
                      setState(() {});
                    },
                    title: const Text("Debug"),
                    trailing: widget.controller.filterLogLevelDebug
                        ? const Icon(
                            Icons.check,
                            size: 18,
                          )
                        : null,
                  ),
                  ListTile(
                    onTap: () {
                      widget.controller.filterLogLevelInfo =
                          !widget.controller.filterLogLevelInfo;
                      widget.controller.notifyListeners();
                      setState(() {});
                    },
                    title: const Text("Info"),
                    trailing: widget.controller.filterLogLevelInfo
                        ? const Icon(
                            Icons.check,
                            size: 18,
                          )
                        : null,
                  ),
                  ListTile(
                    onTap: () {
                      widget.controller.filterLogLevelWarn =
                          !widget.controller.filterLogLevelWarn;
                      widget.controller.notifyListeners();
                      setState(() {});
                    },
                    title: const Text("Warn"),
                    trailing: widget.controller.filterLogLevelWarn
                        ? const Icon(
                            Icons.check,
                            size: 18,
                          )
                        : null,
                  ),
                  ListTile(
                    onTap: () {
                      widget.controller.filterLogLevelError =
                          !widget.controller.filterLogLevelError;
                      widget.controller.notifyListeners();
                      setState(() {});
                    },
                    title: const Text("Error"),
                    trailing: widget.controller.filterLogLevelError
                        ? const Icon(
                            Icons.check,
                            size: 18,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
