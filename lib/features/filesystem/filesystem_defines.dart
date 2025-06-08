import 'package:consoleapp/apps_feature.dart';
import 'package:consoleapp/features/filesystem/filesystem_home.dart';
import 'package:flutter/material.dart';

class FilesystemFeature extends AppsFeature {
  @override
  String featureIdentifier() {
    return "filesystem";
  }

  @override
  Builder faetureBody() {
    return Builder(builder: (context) {
      return const FilesystemHome();
    });
  }

  @override
  Widget featureIcon(BuildContext context, bool selected) {
    return Icon(
      Icons.folder_open,
      size: 18,
      color: selected
          ? Theme.of(context).primaryColor
          : Colors.black.withAlpha(135),
    );
  }

  @override
  String featureTitle() {
    return "文件管理";
  }
}