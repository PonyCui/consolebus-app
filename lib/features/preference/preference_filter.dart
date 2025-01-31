import 'dart:convert';

import 'package:consoleapp/protocols/protocol_defines.dart';
import 'package:consoleapp/protocols/protocol_preference.dart';
import 'package:consoleapp/services/apps_connect_service.dart';
import 'package:flutter/material.dart';

class PreferenceFilterController extends ChangeNotifier {
  String? filterText;
  bool filterKey = true;
  bool filterValue = true;

  bool shouldDisplay(String key, dynamic value) {
    if (filterText == null || filterText!.isEmpty) return true;

    final keyword = filterText!.toLowerCase();
    if (filterKey && key.toLowerCase().contains(keyword)) return true;
    if (filterValue && value.toString().toLowerCase().contains(keyword))
      return true;

    return false;
  }
}

class PreferenceFilter extends StatefulWidget {
  final PreferenceFilterController controller;

  const PreferenceFilter({
    super.key,
    required this.controller,
  });

  @override
  State<PreferenceFilter> createState() => _PreferenceFilterState();
}

class _PreferenceFilterState extends State<PreferenceFilter> {
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
    filterTextController.addListener(onFilterTextChanged);
    widget.controller.addListener(onFilterChanged);
  }

  void onFilterTextChanged() {
    widget.controller.filterText = filterTextController.text;
    widget.controller.notifyListeners();
  }

  void onFilterChanged() {
    if (filterTextController.text != widget.controller.filterText) {
      filterTextController.text = widget.controller.filterText ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(child: _buildFilterText(context)),
          const SizedBox(width: 12),
          _buildSyncButton(),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildFilterText(BuildContext context) {
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

  Widget _buildSyncButton() {
    return Tooltip(
      message: "从设备同步最新数据",
      child: MaterialButton(
        onPressed: () {
          for (final it in AppsConnectService.shared.allDevices) {
            final proto = ProtoPreference(
              key: "",
              value: "",
              operation: "sync",
              type: "",
              deviceId: it.deviceId,
              msgId: ProtoMessageBase.generateUUID(),
              featureId: "preference",
              createdAt: DateTime.now().millisecondsSinceEpoch,
            );
            AppsConnectService.shared.appsConnector
                ?.sendMessage(json.encode(proto));
          }
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: 0,
        child: const Icon(
          Icons.sync,
          size: 18,
        ),
      ),
    );
  }
}
