import 'package:consoleapp/protocols/protocol_console.dart';
import 'package:consoleapp/protocols/protocol_device.dart';
import 'package:consoleapp/protocols/protocol_network.dart';

class ProtoMessageBase {
  final String deviceId;
  final String msgId;
  final String featureId;
  final int createdAt; // unit = ms

  ProtoMessageBase({
    required this.deviceId,
    required this.msgId,
    required this.featureId,
    required this.createdAt,
  });

  toJson() {
    return {
      "deviceId": deviceId,
      "msgId": msgId,
      "featureId": featureId,
      "createdAt": createdAt,
    };
  }
}

class ProtocolMessageFactory {
  static ProtoMessageBase? fromJSON(Map<String, dynamic> json) {
    if (json["featureId"] == "console") {
      return ProtoConsole.fromJSON(json);
    } else if (json["featureId"] == "device") {
      return ProtoDevice.fromJSON(json);
    } else if (json["featureId"] == "network") {
      return ProtoNetwork.fromJSON(json);
    }
    return null;
  }
}
