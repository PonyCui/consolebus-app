import 'package:consoleapp/apps_feature.dart';
import 'package:consoleapp/features/console/console_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConsoleFeature extends AppsFeature {
  @override
  String featureIdentifier() {
    return "console";
  }

  @override
  Builder faetureBody() {
    return Builder(builder: (context) {
      return const ConsoleHome();
    });
  }

  @override
  Widget featureIcon(BuildContext context, bool selected) {
    return Icon(
      Icons.print,
      size: 18,
      color: selected
          ? Theme.of(context).primaryColor
          : Colors.black.withAlpha(135),
    );
  }

  @override
  String featureTitle() {
    return "控制台";
  }
}
