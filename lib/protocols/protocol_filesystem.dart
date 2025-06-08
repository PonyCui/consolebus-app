import 'package:consoleapp/protocols/protocol_defines.dart';

class ProtoFilesystemEntry {
  final String name;
  final bool isDirectory;
  final int? size; // Size in bytes, null for directories or if not applicable
  final int? modifiedAt; // Unix timestamp (milliseconds since epoch)

  ProtoFilesystemEntry({
    required this.name,
    required this.isDirectory,
    this.size,
    this.modifiedAt,
  });

  factory ProtoFilesystemEntry.fromJson(Map<String, dynamic> json) {
    return ProtoFilesystemEntry(
      name: json['name'],
      isDirectory: json['isDirectory'],
      size: json['size'],
      modifiedAt: json['modifiedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isDirectory': isDirectory,
      'size': size,
      'modifiedAt': modifiedAt,
    };
  }
}

class ProtoFilesystem extends ProtoMessageBase {
  final String path;
  final String operation; // e.g., 'list', 'read', 'write', 'delete', 'list_response', 'read_response', etc.
  final List<ProtoFilesystemEntry>? entries; // For 'list_response'
  final String? content; // For 'read_response' (file content) or 'write' (content to write)
  final String? error; // For responses, to indicate an error
  final String? newPath; // For 'rename' or 'move' operations

  ProtoFilesystem({
    required this.path,
    required this.operation,
    this.entries,
    this.content,
    this.error,
    this.newPath,
    required String deviceId,
    required String msgId,
    required String featureId,
    required int createdAt,
  }) : super(
          deviceId: deviceId,
          msgId: msgId,
          featureId: featureId,
          createdAt: createdAt,
        );

  factory ProtoFilesystem.fromJson(Map<String, dynamic> json) {
    var entriesList = json['entries'] as List?;
    List<ProtoFilesystemEntry>? parsedEntries;
    if (entriesList != null) {
      parsedEntries = entriesList.map((i) => ProtoFilesystemEntry.fromJson(i)).toList();
    }

    return ProtoFilesystem(
      path: json['path'],
      operation: json['operation'],
      entries: parsedEntries,
      content: json['content'],
      error: json['error'],
      newPath: json['newPath'],
      deviceId: json['deviceId'],
      msgId: json['msgId'],
      featureId: json['featureId'],
      createdAt: json['createdAt'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['path'] = path;
    data['operation'] = operation;
    if (entries != null) {
      data['entries'] = entries!.map((v) => v.toJson()).toList();
    }
    if (content != null) {
      data['content'] = content;
    }
    if (error != null) {
      data['error'] = error;
    }
    if (newPath != null) {
      data['newPath'] = newPath;
    }
    return data;
  }
}