import 'package:flutter/material.dart';
import 'package:consoleapp/services/apps_connect_service.dart';
import 'package:file_picker/file_picker.dart';

class ImportButton extends StatelessWidget {
  const ImportButton({super.key});

  void _importLogFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['cblog'],
    );
    if (result != null) {
      final file = result.files.first;
      if (file.path != null) {
        await AppsConnectService.shared.importFromLogFile(file.path!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _importLogFile,
      child: const Text('导入日志文件'),
    );
  }
}
