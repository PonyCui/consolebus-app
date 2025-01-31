import 'package:consoleapp/protocols/protocol_network.dart';

class NetworkExporter {
  static String generateCurlCommand(ProtoNetwork network) {
    var command = 'curl -X ${network.requestMethod} "${network.requestUri}"';

    if (network.requestHeaders.isNotEmpty) {
      network.requestHeaders.forEach((key, value) {
        command += ' -H "$key: $value"';
      });
    }

    if (network.requestBody != null && network.requestBody!.isNotEmpty) {
      command += ' -d "${network.requestBody!.replaceAll('"', '\\"')}"';
    }

    return command;
  }
}
