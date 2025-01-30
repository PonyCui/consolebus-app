import 'package:consoleapp/protocols/protocol_defines.dart';

class ProtoDevice extends ProtoMessageBase {
  final String deviceName;
  final String deviceType;

  ProtoDevice({
    required this.deviceName,
    required this.deviceType,
    required super.deviceId,
    required super.msgId,
    required super.featureId,
    required super.createdAt,
  });

  factory ProtoDevice.fromJSON(Map<String, dynamic> json) {
    return ProtoDevice(
      deviceName: json["deviceName"],
      deviceType: json["deviceType"],
      deviceId: json["deviceId"],
      msgId: json["msgId"],
      featureId: "device",
      createdAt: json["createdAt"],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProtoDevice && other.deviceId == deviceId;
  }

  @override
  int get hashCode => deviceId.hashCode;

  @override
  toJson() {
    return {
      "deviceName": deviceName,
      "deviceType": deviceType,
      "deviceId": deviceId,
      "msgId": msgId,
      "featureId": featureId,
      "createdAt": createdAt,
    };
  }
}
