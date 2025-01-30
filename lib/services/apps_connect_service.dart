import 'dart:convert';

import 'package:consoleapp/protocols/protocol_defines.dart';
import 'package:consoleapp/protocols/protocol_device.dart';
import 'package:consoleapp/protocols/protocol_network.dart';
import 'package:consoleapp/services/apps_connector.dart';
import 'package:flutter/material.dart';

class AppsConnectService extends ChangeNotifier {
  static final shared = AppsConnectService();
  final List<ProtoMessageBase> allMessages = [];
  final Set<ProtoDevice> allDevices = {};
  AppsConnector? appsConnector;
  ProtoDevice? selectedDevice;

  void setAppsConnector(AppsConnector appsConnector) {
    this.appsConnector = appsConnector;
    appsConnector.onReceiveMessage = (message) {
      final obj = json.decode(message);
      if (obj is Map<String, dynamic>) {
        final msg = ProtocolMessageFactory.fromJSON(obj);
        if (msg != null) {
          receivedMessage(msg);
        }
      }
    };
  }

  void receivedMessage(ProtoMessageBase msg) {
    if (msg is ProtoDevice) {
      allDevices.add(msg);
    }
    if (msg is ProtoNetwork) {
      allMessages.removeWhere((it) {
        return it is ProtoNetwork && it.uniqueId == msg.uniqueId;
      });
    }
    allMessages.add(msg);
    notifyListeners();
  }

  void setSelectedDevice(ProtoDevice? device) {
    selectedDevice = device;
    notifyListeners();
  }
}
