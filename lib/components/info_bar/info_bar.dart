import 'package:consoleapp/components/info_bar/device_list.dart';
import 'package:flutter/material.dart';
import 'package:consoleapp/services/apps_connect_service.dart';

class AppsInfoBar extends StatefulWidget {
  const AppsInfoBar({super.key});

  @override
  State<AppsInfoBar> createState() => _AppsInfoBarState();
}

class _AppsInfoBarState extends State<AppsInfoBar> {
  @override
  void initState() {
    super.initState();
    AppsConnectService.shared.addListener(onDevicesChanged);
  }

  @override
  void dispose() {
    AppsConnectService.shared.removeListener(onDevicesChanged);
    super.dispose();
  }

  void onDevicesChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final devices = AppsConnectService.shared.allDevices.toList();
    final selectedDevice = AppsConnectService.shared.selectedDevice;
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          DeviceList(devices: devices, selectedDevice: selectedDevice),
        ],
      ),
    );
  }
}
