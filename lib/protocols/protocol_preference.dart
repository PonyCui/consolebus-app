import 'package:consoleapp/protocols/protocol_defines.dart';

class ProtoPreference extends ProtoMessageBase {
  final String key;
  final dynamic value;
  final String operation; // 'set' or 'get' or 'sync'
  final String type; // 'string', 'number', 'boolean', 'map', 'list', 'null'

  ProtoPreference({
    required this.key,
    required this.value,
    required this.operation,
    required this.type,
    required super.deviceId,
    required super.msgId,
    required super.featureId,
    required super.createdAt,
  });

  factory ProtoPreference.fromJson(Map<String, dynamic> json) {
    return ProtoPreference(
      key: json['key'] as String,
      value: json['value'],
      operation: json['operation'] as String,
      type: json['type'] as String,
      deviceId: json['deviceId'],
      msgId: json['msgId'],
      featureId: 'preference',
      createdAt: json['createdAt'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'key': key,
      'value': value,
      'operation': operation,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'ProtoPreference{key: $key, value: $value, type: $type, operation: $operation}';
  }

  String get uniqueId => '$key:$operation:$deviceId';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProtoPreference && other.uniqueId == uniqueId;
  }

  @override
  int get hashCode => uniqueId.hashCode;
}