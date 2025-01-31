import 'dart:convert';

import 'package:consoleapp/features/preference/preference_detail.dart';
import 'package:consoleapp/features/preference/preference_filter.dart';
import 'package:consoleapp/protocols/protocol_preference.dart';
import 'package:consoleapp/services/apps_connect_service.dart';
import 'package:flutter/material.dart';

class PreferenceHome extends StatefulWidget {
  const PreferenceHome({super.key});

  @override
  State<PreferenceHome> createState() => _PreferenceHomeState();
}

class _PreferenceHomeState extends State<PreferenceHome> {
  ProtoPreference? selectedPreference;
  List<ProtoPreference> filteredPreferences = [];
  static final filterController = PreferenceFilterController();

  @override
  void initState() {
    super.initState();
    AppsConnectService.shared.addListener(onPreferencesChanged);
    filterController.addListener(onFilterChanged);
    updateFilteredItems();
  }

  @override
  void dispose() {
    AppsConnectService.shared.removeListener(onPreferencesChanged);
    filterController.removeListener(onFilterChanged);
    super.dispose();
  }

  void onPreferencesChanged() {
    updateFilteredItems();
  }

  void onFilterChanged() {
    updateFilteredItems();
  }

  void updateFilteredItems() {
    setState(() {
      filteredPreferences = AppsConnectService.shared.allMessages
          .whereType<ProtoPreference>()
          .where((preference) {
            return preference.operation == "get";
          })
          .where((preference) {
            return filterController.shouldDisplay(
              preference.key,
              preference.value,
            );
          })
          .where((it) {
            if (AppsConnectService.shared.selectedDevice != null) {
              return it.deviceId ==
                  AppsConnectService.shared.selectedDevice?.deviceId;
            } else {
              return true;
            }
          })
          .fold<Map<String, ProtoPreference>>({}, (map, preference) {
            final key =
                '${preference.key}_${preference.operation}_${preference.deviceId}';
            final existing = map[key];
            if (existing == null || existing.createdAt < preference.createdAt) {
              map[key] = preference;
            }
            return map;
          })
          .values
          .toList()
          ..sort((a, b) => a.key.compareTo(b.key));
      if (selectedPreference != null) {
        selectedPreference = filteredPreferences.where((it) {
          return it.key == selectedPreference?.key;
        }).firstOrNull;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PreferenceFilter(controller: filterController),
        Divider(
          height: 1,
          color: Theme.of(context).dividerColor,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: filteredPreferences.length,
                  itemBuilder: (context, index) {
                    final preference = filteredPreferences[index];
                    return ListTile(
                      title: Text(preference.key),
                      subtitle: Text(
                        '${json.encode(preference.value).replaceAll("\n", "")}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      selected: selectedPreference == preference,
                      onTap: () {
                        setState(() {
                          selectedPreference = preference;
                        });
                      },
                    );
                  },
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 3,
                child: PreferenceDetail(
                    key: Key(
                        "${selectedPreference?.key ?? ""}_${selectedPreference?.createdAt}"),
                    preference: selectedPreference),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
