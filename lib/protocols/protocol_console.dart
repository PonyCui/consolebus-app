import 'package:consoleapp/protocols/protocol_defines.dart';

class ProtoConsole extends ProtoMessageBase {
  final String logTag;
  final String logContent;
  final String logLevel; // debug/info/warn/error

  ProtoConsole({
    this.logTag = "",
    required this.logContent,
    required this.logLevel,
    required super.deviceId,
    required super.msgId,
    required super.featureId,
    required super.createdAt,
  });

  @override
  toJson() {
    return {
      "logTag": logTag,
      "logContent": logContent,
      "logLevel": logLevel,
      "deviceId": deviceId,
      "msgId": msgId,
      "featureId": featureId,
      "createdAt": createdAt,
    };
  }

  static ProtoConsole? fromJSON(Map<String, dynamic> json) {
    return ProtoConsole(
      deviceId: json["deviceId"],
      msgId: json["msgId"],
      featureId: "console",
      createdAt: json["createdAt"],
      logTag: json["logTag"],
      logContent: json["logContent"],
      logLevel: json["logLevel"],
    );
  }
}
