import 'package:consoleapp/utils/apps_util.dart';
import 'package:flutter/material.dart';
import 'network_filter.dart';

class NetworkFilterOptionsPanel extends StatefulWidget {
  final NetworkFilterController controller;

  const NetworkFilterOptionsPanel({super.key, required this.controller});

  @override
  State<NetworkFilterOptionsPanel> createState() =>
      _NetworkFilterOptionsPanelState();
}

class _NetworkFilterOptionsPanelState extends State<NetworkFilterOptionsPanel> {
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
    final isMobile = AppsUtil.isMobileMode(context);
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
            height: isMobile ? 0 : 44,
            width: isMobile ? 0 : 44,
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          Positioned(
            right: isMobile ? 0 : 44,
            top: 44,
            width: 200,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      widget.controller.filterRequestUri =
                          !widget.controller.filterRequestUri;
                      widget.controller.notifyListeners();
                      setState(() {});
                    },
                    title: const Text("请求 URI"),
                    trailing: widget.controller.filterRequestUri
                        ? const Icon(
                            Icons.check,
                            size: 18,
                          )
                        : null,
                  ),
                  ListTile(
                    onTap: () {
                      widget.controller.filterRequestBody =
                          !widget.controller.filterRequestBody;
                      widget.controller.notifyListeners();
                      setState(() {});
                    },
                    title: const Text("请求体"),
                    trailing: widget.controller.filterRequestBody
                        ? const Icon(
                            Icons.check,
                            size: 18,
                          )
                        : null,
                  ),
                  ListTile(
                    onTap: () {
                      widget.controller.filterResponseBody =
                          !widget.controller.filterResponseBody;
                      widget.controller.notifyListeners();
                      setState(() {});
                    },
                    title: const Text("响应体"),
                    trailing: widget.controller.filterResponseBody
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