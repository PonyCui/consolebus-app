import 'package:consoleapp/apps_feature.dart';
import 'package:consoleapp/features/console/console_defines.dart';
import 'package:consoleapp/features/filesystem/filesystem_defines.dart';
import 'package:consoleapp/features/network/network_defines.dart';
import 'package:consoleapp/features/preference/preference_defines.dart';
import 'package:consoleapp/components/info_bar/info_bar.dart';
import 'package:consoleapp/services/apps_connector_ws.dart';
import 'package:consoleapp/utils/apps_util.dart';
import 'package:flutter/material.dart';

import 'components/menu_bar/menu_bar.dart';
import 'services/apps_connect_service.dart';

class AppsHome extends StatefulWidget {
  const AppsHome({super.key});

  @override
  State<AppsHome> createState() => _AppsHomeState();
}

class _AppsHomeState extends State<AppsHome> {
  String selectedFeature = "";

  @override
  void initState() {
    super.initState();
    AppsFeatureManager.shared.registerFeature(ConsoleFeature());
    AppsFeatureManager.shared.registerFeature(NetworkFeature());
    AppsFeatureManager.shared.registerFeature(PreferenceFeature());
    AppsFeatureManager.shared.registerFeature(FilesystemFeature());
    selectedFeature =
        AppsFeatureManager.shared.allFeatures().first.featureIdentifier();
    final appsConnector = AppsConnectorWS(wsPort: 9090);
    AppsConnectService.shared.setAppsConnector(appsConnector);
    appsConnector.connect();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppsUtil.isMobileMode(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: isMobile
          ? AppsFeatureManager.shared.findFeature(selectedFeature).faetureBody()
          : Row(
              children: [
                AppsMenuBar(
                  selectedFeature: selectedFeature,
                  onSelectFeature: (featureIdentifier) {
                    setState(() {
                      selectedFeature = featureIdentifier;
                    });
                  },
                ),
                Expanded(
                  child: AppsFeatureManager.shared
                      .findFeature(selectedFeature)
                      .faetureBody(),
                )
              ],
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isMobile ? const SizedBox() : const AppsInfoBar(),
          if (isMobile)
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 247, 247, 247),
                border: Border(
                  top: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    AppsFeatureManager.shared.allFeatures().map((feature) {
                  final isSelected =
                      feature.featureIdentifier() == selectedFeature;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedFeature = feature.featureIdentifier();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          feature.featureIcon(context, isSelected),
                          const SizedBox(height: 4),
                          Text(
                            feature.featureTitle(),
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.black.withAlpha(135),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
