import 'dart:convert';

class NetworkExporter {
  static String toCurl(String requestUri, String requestMethod,
      Map<String, String> requestHeaders, String? requestBody) {
    final buffer = StringBuffer();
    buffer.write('curl -X $requestMethod');

    // Add headers
    requestHeaders.forEach((key, value) {
      buffer.write('-H "$key: $value"');
    });

    // Add request body if present
    if (requestBody != null && requestBody.isNotEmpty) {
      try {
        // Try to format JSON body
        final dynamic jsonBody = json.decode(requestBody);
        final formattedBody = json.encode(jsonBody);
        buffer.write('-d "${formattedBody.replaceAll('"', '\\"')}"');
      } catch (e) {
        // If not JSON, add as raw body
        buffer.write('-d "${requestBody.replaceAll('"', '\\"')}"');
      }
    }

    // Add URL (must be the last parameter)
    buffer.write('"$requestUri"');

    return buffer.toString();
  }
}