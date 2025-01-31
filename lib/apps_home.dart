import 'package:consoleapp/apps_feature.dart';
import 'package:consoleapp/features/console/console_defines.dart';
import 'package:consoleapp/features/network/network_defines.dart';
import 'package:consoleapp/features/preference/preference_defines.dart';
import 'package:consoleapp/components/info_bar/info_bar.dart';
import 'package:consoleapp/services/apps_connector_ws.dart';
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
    selectedFeature =
        AppsFeatureManager.shared.allFeatures().first.featureIdentifier();
    final appsConnector = AppsConnectorWS(wsPort: 9090);
    AppsConnectService.shared.setAppsConnector(appsConnector);
    appsConnector.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
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
      bottomNavigationBar: const AppsInfoBar(),
    );
  }
}
