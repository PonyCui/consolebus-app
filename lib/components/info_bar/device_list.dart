import 'package:consoleapp/protocols/protocol_device.dart';
import 'package:consoleapp/services/apps_connect_service.dart';
import 'package:flutter/material.dart';

class DeviceList extends StatelessWidget {
  const DeviceList({
    super.key,
    required this.devices,
    this.selectedDevice,
  });

  final List<ProtoDevice> devices;
  final ProtoDevice? selectedDevice;

  onTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择设备以筛选结果', style: TextStyle(fontSize: 16)),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (devices.isEmpty)
                  const Text('暂无设备连接', style: TextStyle(color: Colors.black45))
                else
                  ...devices.map(
                    (device) => ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        device.deviceName,
                        style: const TextStyle(fontSize: 14),
                      ),
                      selected: device == selectedDevice,
                      onTap: () {
                        AppsConnectService.shared.setSelectedDevice(device);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.devices, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        InkWell(
          onTap: () {
            onTap(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            constraints: const BoxConstraints(maxWidth: 200),
            child: devices.isEmpty
                ? const Text('暂无设备连接',
                    style: TextStyle(fontSize: 14, color: Colors.black45))
                : Text(
                    selectedDevice != null
                        ? selectedDevice!.deviceName
                        : '${devices.length} 台设备已连接',
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}
