import 'package:consoleapp/protocols/protocol_defines.dart';

class ProtoConsole extends ProtoMessageBase {
  final String logTag;
  final String logContent;
  final String logLevel; // debug/info/warn/error

  ProtoConsole({
    this.logTag = "",
    required this.logContent,
    required this.logLevel,
    required super.msgId,
    required super.featureId,
    required super.createdAt,
  });

  static ProtoConsole? fromJSON(Map<String, dynamic> json) {
    return ProtoConsole(
      msgId: json["msgId"],
      featureId: json["featureId"],
      createdAt: json["createdAt"],
      logTag: json["logTag"],
      logContent: json["logContent"],
      logLevel: json["logLevel"],
    );
  }
}
