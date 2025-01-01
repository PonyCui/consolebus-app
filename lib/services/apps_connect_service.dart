import 'dart:convert';

import 'package:consoleapp/protocols/protocol_defines.dart';
import 'package:consoleapp/services/apps_connector.dart';
import 'package:flutter/material.dart';

class AppsConnectService extends ChangeNotifier {
  static final shared = AppsConnectService();
  final List<ProtoMessageBase> allMessages = [];
  final Set<String> allDevices = {};
  AppsConnector? appsConnector;

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
    allDevices.add(msg.deviceId);
    allMessages.add(msg);
    notifyListeners();
  }
}
