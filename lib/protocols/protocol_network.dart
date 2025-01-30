import 'package:consoleapp/protocols/protocol_defines.dart';

class ProtoNetwork extends ProtoMessageBase {
  final String uniqueId;
  final String requestUri;
  final Map<String, String> requestHeaders;
  final String requestMethod;
  final String? requestBody;
  final Map<String, String> responseHeaders;
  final int responseStatusCode;
  final String? responseBody;
  final DateTime requestTime;
  final DateTime responseTime;

  ProtoNetwork({
    required this.uniqueId,
    required super.deviceId,
    required super.msgId,
    required super.featureId,
    required super.createdAt,
    required this.requestUri,
    required this.requestHeaders,
    required this.requestMethod,
    this.requestBody,
    required this.responseHeaders,
    required this.responseStatusCode,
    this.responseBody,
    required this.requestTime,
    required this.responseTime,
  });

  @override
  String toString() {
    return '$requestMethod $requestUri';
  }

  @override
  toJson() {
    return {
      ...super.toJson(),
      "uniqueId": uniqueId,
      "requestUri": requestUri,
      "requestHeaders": requestHeaders,
      "requestMethod": requestMethod,
      "requestBody": requestBody,
      "responseHeaders": responseHeaders,
      "responseStatusCode": responseStatusCode,
      "responseBody": responseBody,
      "requestTime": requestTime.millisecondsSinceEpoch,
      "responseTime": responseTime.millisecondsSinceEpoch,
    };
  }

  static ProtoNetwork fromJSON(Map<String, dynamic> json) {
    return ProtoNetwork(
      uniqueId: json["uniqueId"],
      deviceId: json["deviceId"],
      msgId: json["msgId"],
      featureId: "network",
      createdAt: json["createdAt"],
      requestUri: json["requestUri"],
      requestHeaders: Map<String, String>.from(json["requestHeaders"]),
      requestMethod: json["requestMethod"],
      requestBody: json["requestBody"],
      responseHeaders: Map<String, String>.from(json["responseHeaders"]),
      responseStatusCode: json["responseStatusCode"],
      responseBody: json["responseBody"],
      requestTime: DateTime.fromMillisecondsSinceEpoch(json["requestTime"]),
      responseTime: DateTime.fromMillisecondsSinceEpoch(json["responseTime"]),
    );
  }
}