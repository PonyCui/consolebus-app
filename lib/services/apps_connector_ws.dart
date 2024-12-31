import 'dart:io';
import 'package:consoleapp/services/apps_connector.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

class AppsConnectorWS extends AppsConnector {
  final int wsPort;
  dynamic webSocket;

  AppsConnectorWS({required this.wsPort});

  connect() async {
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

  @override
  sendMessage(String message) {
    if (webSocket != null) {
      webSocket.sink.add(message);
    }
  }
}
