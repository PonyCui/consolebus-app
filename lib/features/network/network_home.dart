import 'package:consoleapp/features/network/network_detail.dart';
import 'package:consoleapp/features/network/network_list.dart';
import 'package:consoleapp/protocols/protocol_network.dart';
import 'package:consoleapp/services/apps_connect_service.dart';
import 'package:consoleapp/utils/apps_util.dart';
import 'package:flutter/material.dart';
import 'package:consoleapp/features/network/network_filter.dart';
import 'package:flutter/services.dart';
import 'network_exporter.dart';

class NetworkHome extends StatefulWidget {
  const NetworkHome({super.key});

  @override
  State<NetworkHome> createState() => _NetworkHomeState();
}

class _NetworkHomeState extends State<NetworkHome> {
  ProtoNetwork? selectedNetwork;
  static final filterController = NetworkFilterController();

  @override
  void initState() {
    super.initState();
    AppsConnectService.shared.addListener(onNetworksChanged);
    filterController.addListener(onFilterChanged);
  }

  @override
  void dispose() {
    AppsConnectService.shared.removeListener(onNetworksChanged);
    filterController.removeListener(onFilterChanged);
    super.dispose();
  }

  void onNetworksChanged() {
    setState(() {});
  }

  void onFilterChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppsUtil.isMobileMode(context);
    final filteredNetworks = AppsConnectService.shared.allMessages
        .whereType<ProtoNetwork>()
        .where((network) {
      return filterController.shouldDisplay(
        network.requestUri,
        network.requestBody,
        network.responseBody,
      );
    }).where((it) {
      if (AppsConnectService.shared.selectedDevice != null) {
        return it.deviceId ==
            AppsConnectService.shared.selectedDevice?.deviceId;
      } else {
        return true;
      }
    }).toList();
    final selectedNetwork =
        filteredNetworks.isEmpty ? null : this.selectedNetwork;

    return Column(
      children: [
        NetworkFilter(
          controller: filterController,
        ),
        Divider(
          height: 1,
          color: Theme.of(context).dividerColor,
        ),
        Expanded(
          child: isMobile
              ? Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: NetworkList(
                        networks: filteredNetworks,
                        selectedNetwork: selectedNetwork,
                        onSelectNetwork: (network) {
                          setState(() {
                            if (this.selectedNetwork == network) {
                              this.selectedNetwork = null;
                            } else {
                              this.selectedNetwork = network;
                            }
                          });
                        },
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                    selectedNetwork != null ? Expanded(
                      flex: 2,
                      child: NetworkDetail(
                        key: Key(
                            'network_${selectedNetwork.uniqueId}'),
                        network: selectedNetwork,
                      ),
                    ) : const SizedBox(),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: NetworkList(
                        networks: filteredNetworks,
                        selectedNetwork: selectedNetwork,
                        onSelectNetwork: (network) {
                          setState(() {
                            this.selectedNetwork = network;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                    Expanded(
                      flex: 3,
                      child: NetworkDetail(
                        key: Key(
                            'network_${selectedNetwork?.uniqueId ?? "empty"}'),
                        network: selectedNetwork,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
