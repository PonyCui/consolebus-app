import 'dart:convert';
import 'package:consoleapp/protocols/protocol_defines.dart';
import 'package:consoleapp/protocols/protocol_device.dart';
import 'package:consoleapp/protocols/protocol_filesystem.dart';
import 'package:consoleapp/services/apps_connect_service.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FilesystemHome extends StatefulWidget {
  const FilesystemHome({super.key});

  @override
  State<FilesystemHome> createState() => _FilesystemHomeState();
}

class _FilesystemHomeState extends State<FilesystemHome> {
  String currentPath = '/'; // 默认起始路径
  List<ProtoFilesystemEntry> items = [];
  bool isLoading = false;
  String? errorMessage;
  TextEditingController pathController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppsConnectService.shared.addListener(_onMessageReceived);
    pathController.text = currentPath;
    // 如果没有选择设备，并且有可用设备，则选择第一个
    if (AppsConnectService.shared.selectedDevice == null && AppsConnectService.shared.allDevices.isNotEmpty) {
      AppsConnectService.shared.setSelectedDevice(AppsConnectService.shared.allDevices.first);
    }
    _fetchDirectoryContents(currentPath);
  }

  @override
  void dispose() {
    AppsConnectService.shared.removeListener(_onMessageReceived);
    pathController.dispose();
    super.dispose();
  }

  void _onMessageReceived() {
    final messages = AppsConnectService.shared.allMessages
        .whereType<ProtoFilesystem>()
        .where((msg) =>
            msg.deviceId == AppsConnectService.shared.selectedDevice?.deviceId);

    for (final msg in messages) {
      if (msg.operation == 'list_response') {
        setState(() {
            items = msg.entries ?? [];
            items.sort((a, b) {
              if (a.isDirectory == b.isDirectory) {
                return a.name.toLowerCase().compareTo(b.name.toLowerCase());
              } else {
                return a.isDirectory ? -1 : 1;
              }
            });
            isLoading = false;
            errorMessage = msg.error;
          });
      } else if (msg.operation == 'read_response') {
        // 处理读文件响应
        setState(() {
          isLoading = false;
          errorMessage = msg.error;
        });
        if (msg.error == null && msg.content != null) {
          _showFileContentDialog(msg.path ?? 'File', msg.content!); 
        }
      } else if (msg.operation == 'write_response' || msg.operation == 'delete_response') {
         // 操作完成后刷新当前目录
        setState(() {
          isLoading = false;
          errorMessage = msg.error;
        });
        if (msg.error == null) {
          _fetchDirectoryContents(currentPath);
        }
      }
      AppsConnectService.shared.allMessages.removeWhere((it) => it == msg);
    }
  }

  void _fetchDirectoryContents(String path) {
    if (AppsConnectService.shared.selectedDevice == null) {
      setState(() {
        errorMessage = "请先选择一个设备";
        items = [];
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = null;
      currentPath = path;
      pathController.text = path;
    });
    final request = ProtoFilesystem(
      path: path,
      operation: 'list',
      deviceId: AppsConnectService.shared.selectedDevice!.deviceId,
      msgId: ProtoMessageBase.generateUUID(),
      featureId: 'filesystem',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    AppsConnectService.shared.appsConnector?.sendMessage(json.encode(request.toJson()));
  }

  void _navigateTo(ProtoFilesystemEntry item) {
    if (item.isDirectory) {
      String newPath = currentPath.endsWith('/') ? currentPath : '$currentPath/';
      newPath += item.name;
      _fetchDirectoryContents(newPath);
    }
  }

  void _goUp() {
    if (currentPath == '/' || currentPath.isEmpty) return;
    int lastSlash = currentPath.lastIndexOf('/');
    if (lastSlash == 0) {
      _fetchDirectoryContents('/');
    } else if (lastSlash > 0) {
      _fetchDirectoryContents(currentPath.substring(0, lastSlash));
    }
  }
  
  void _readFile(ProtoFilesystemEntry item) {
    if (AppsConnectService.shared.selectedDevice == null) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final request = ProtoFilesystem(
      path: '$currentPath/${item.name}'.replaceAll('//', '/'),
      operation: 'read',
      deviceId: AppsConnectService.shared.selectedDevice!.deviceId,
      msgId: ProtoMessageBase.generateUUID(),
      featureId: 'filesystem',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    AppsConnectService.shared.appsConnector?.sendMessage(json.encode(request.toJson()));
  }

  void _deleteItem(ProtoFilesystemEntry item) {
    if (AppsConnectService.shared.selectedDevice == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认删除'),
          content: Text('你确定要删除 "${item.name}"吗? 这个操作无法撤销。'),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('删除', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                final request = ProtoFilesystem(
                  path: '$currentPath/${item.name}'.replaceAll('//', '/'),
                  operation: 'delete',
                  deviceId: AppsConnectService.shared.selectedDevice!.deviceId,
                  msgId: ProtoMessageBase.generateUUID(),
                  featureId: 'filesystem',
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                );
                AppsConnectService.shared.appsConnector?.sendMessage(json.encode(request.toJson()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFileContentDialog(String fileName, String content) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(fileName),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('关闭'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allDevices = AppsConnectService.shared.allDevices.toList();
    final selectedDevice = AppsConnectService.shared.selectedDevice;

    return Column(
      children: [
        // 设备选择下拉菜单
        if (allDevices.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<ProtoDevice>(
              decoration: InputDecoration(
                labelText: '选择设备',
                border: OutlineInputBorder(),
              ),
              value: selectedDevice,
              items: allDevices.map((ProtoDevice device) {
                return DropdownMenuItem<ProtoDevice>(
                  value: device,
                  child: Text(device.deviceName ?? device.deviceId),
                );
              }).toList(),
              onChanged: (ProtoDevice? newValue) {
                AppsConnectService.shared.setSelectedDevice(newValue);
                // 设备切换后，如果当前路径不是根目录，则返回根目录并重新获取内容
                if (newValue != null) {
                  _fetchDirectoryContents('/'); // 或者 currentPath，取决于产品逻辑
                } else {
                  setState(() {
                    items = [];
                    errorMessage = "请选择一个设备";
                  });
                }
              },
            ),
          ),
        if (allDevices.isEmpty)
           const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('没有可用的设备。请先连接设备。', style: TextStyle(color: Colors.orange)),
          ),
        _buildPathBar(),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
          ),
        if (isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (items.isEmpty && AppsConnectService.shared.selectedDevice != null)
           Expanded(child: Center(child: Text(currentPath == '/' ? '根目录为空或无法访问。' : '目录为空或无法访问。')))
        else if (AppsConnectService.shared.selectedDevice == null && allDevices.isNotEmpty)
          const Expanded(child: Center(child: Text('请先选择一个设备。')))
        else if (AppsConnectService.shared.selectedDevice == null && allDevices.isEmpty)
          Container() // 如果没有设备，也不显示“请先选择设备”，因为上面已经有提示了
        else
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Icon(item.isDirectory ? Icons.folder : Icons.insert_drive_file),
                  title: Text(item.name),
                  subtitle: Text(item.isDirectory ? '目录' : '文件 (${_formatSize(item.size)})'),
                  onTap: () => _navigateTo(item),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!item.isDirectory)
                        IconButton(
                          icon: Icon(Icons.remove_red_eye_outlined, size: 20),
                          tooltip: '查看',
                          onPressed: () => _readFile(item),
                        ),
                      // IconButton(
                      //   icon: Icon(Icons.download_outlined, size: 20),
                      //   tooltip: '下载',
                      //   onPressed: () { /* TODO: Implement download */ },
                      // ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                        tooltip: '删除',
                        onPressed: () => _deleteItem(item),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPathBar() {
    return Material(
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              tooltip: '上一级',
              onPressed: (currentPath == '/' || isLoading) ? null : _goUp,
            ),
            Expanded(
              child: TextField(
                controller: pathController,
                decoration: InputDecoration(
                  hintText: '当前路径',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8)
                ),
                onSubmitted: (newPath) {
                  _fetchDirectoryContents(newPath);
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: '刷新',
              onPressed: isLoading ? null : () => _fetchDirectoryContents(currentPath),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSize(int? bytes) {
    if (bytes == null) return '-';
    if (bytes == 0) return '0 B'; // Handle 0 byte case
    if (bytes < 1024) return '$bytes B';
    int exp = (math.log(bytes) / math.log(1024)).floor();
    String pre = 'KMGTPE'[exp - 1];
    return '${(bytes / math.pow(1024, exp)).toStringAsFixed(1)} ${pre}B';
  }
}