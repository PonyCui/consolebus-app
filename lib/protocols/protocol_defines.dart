import 'package:consoleapp/protocols/protocol_console.dart';

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
    }
    return null;
  }
}
