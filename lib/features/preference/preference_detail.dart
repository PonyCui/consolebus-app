import 'dart:math';

import 'package:consoleapp/protocols/protocol_defines.dart';
import 'package:consoleapp/protocols/protocol_preference.dart';
import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/styles/atom-one-light.dart';
import 'dart:convert';
import 'package:consoleapp/services/apps_connect_service.dart';

class PreferenceDetail extends StatefulWidget {
  final ProtoPreference? preference;

  const PreferenceDetail({super.key, this.preference});

  @override
  State<PreferenceDetail> createState() => _PreferenceDetailState();
}

class _PreferenceDetailState extends State<PreferenceDetail> {
  bool isEditing = false;
  bool isSubmiting = false;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void _startEditing() {
    _editingController.text = _formatValue(widget.preference!.value);
    setState(() {
      isEditing = true;
    });
  }

  void _confirmEdit() {
    try {
      dynamic newValue;
      if (widget.preference!.type == 'json' ||
          widget.preference!.type == 'list' ||
          widget.preference!.type == 'map') {
        newValue = json.decode(_editingController.text);
      } else {
        newValue = _editingController.text;
      }

      final updatedPreference = ProtoPreference(
        key: widget.preference!.key,
        value: newValue,
        type: widget.preference!.type,
        operation: 'set',
        deviceId: widget.preference!.deviceId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        msgId: ProtoMessageBase.generateUUID(),
        featureId: "preference",
      );

      AppsConnectService.shared.appsConnector?.sendMessage(
        json.encode(updatedPreference),
      );

      setState(() {
        isEditing = false;
        isSubmiting = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('修改失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.preference == null) {
      return const Center(
        child: Text('请选择一个偏好设置项'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SelectionArea(
            child: _buildMetadataTable([
              {'键': widget.preference!.key},
              {'类型': widget.preference!.type},
              {'值': _buildValueCell()},
            ]),
          ),
        ],
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return 'null';
    if (value is Map || value is List) {
      try {
        return const JsonEncoder.withIndent('  ').convert(value);
      } catch (e) {
        return value.toString();
      }
    }
    return value.toString();
  }

  Widget _buildValueCell() {
    if (isSubmiting) {
      return const Padding(
        padding: EdgeInsets.only(top: 4.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 300,
            child: TextField(
              controller: _editingController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    isEditing = false;
                  });
                },
                child: const Text('取消'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _confirmEdit,
                child: const Text('确认修改'),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(_formatValue(widget.preference!.value)),
        ),
        IconButton(
          icon: const Icon(
            Icons.edit,
            size: 12,
          ),
          iconSize: 12,
          onPressed: _startEditing,
          tooltip: '编辑',
        ),
      ],
    );
  }

  Widget _buildMetadataTable(List<Map<String, dynamic>> data) {
    return Table(
      border: TableBorder.all(
        color: Colors.grey[300]!,
        width: 1,
      ),
      columnWidths: const {
        0: FixedColumnWidth(150),
        1: FlexColumnWidth(),
      },
      children: data.map((item) {
        final entry = item.entries.first;
        final value = entry.value;
        return TableRow(
          children: [
            Padding(
              padding: entry.key == "值"
                  ? const EdgeInsets.only(
                      left: 8.0,
                      top: 18.0,
                      bottom: 8.0,
                      right: 8.0,
                    )
                  : const EdgeInsets.all(8.0),
              child: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: value is Widget ? value : Text(value.toString()),
            ),
          ],
        );
      }).toList(),
    );
  }
}
