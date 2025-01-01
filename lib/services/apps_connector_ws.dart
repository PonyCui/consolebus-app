import 'dart:convert';
import 'dart:math';
import 'package:consoleapp/protocols/protocol_console.dart';
import 'package:consoleapp/services/apps_connector.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

class AppsConnectorWS extends AppsConnector {
  final int wsPort;
  dynamic webSocket;

  AppsConnectorWS({required this.wsPort});

  connect() async {
    mock();
    var handler =
        const shelf.Pipeline().addMiddleware(shelf.logRequests()).addHandler(
      webSocketHandler((webSocket) {
        this.webSocket = webSocket;
        webSocket.stream.listen((message) {
          if (message is String) {
            onReceiveMessage?.call(message);
          }
        });
      }),
    );
    await io.serve(handler, 'localhost', wsPort);
  }

  mock() async {
    final a = ProtoConsole(
      logContent:
          "random string ${Random.secure().nextDouble()} random string ${Random.secure().nextDouble()} random string ${Random.secure().nextDouble()} random string ${Random.secure().nextDouble()} random string ${Random.secure().nextDouble()}",
      logLevel: () {
        // random output log level
        final r = Random().nextInt(4);
        switch (r) {
          case 0:
            return "debug";
          case 1:
            return "info";
          case 2:
            return "warn";
          case 3:
            return "error";
        }
        return "debug";
      }(),
      deviceId: "000000",
      msgId: Random().nextInt(2000000000).toString(),
      featureId: "console",
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    onReceiveMessage?.call(json.encode(a));
    await Future.delayed(const Duration(seconds: 1));
    mock();
  }

  @override
  sendMessage(String message) {
    if (webSocket != null) {
      webSocket.sink.add(message);
    }
  }
}
