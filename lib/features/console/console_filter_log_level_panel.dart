import 'package:consoleapp/features/console/console_filter.dart';
import 'package:flutter/material.dart';

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
