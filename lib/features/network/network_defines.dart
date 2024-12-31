import 'package:consoleapp/apps_feature.dart';
import 'package:flutter/material.dart';

class NetworkFeature extends AppsFeature {
  @override
  String featureIdentifier() {
    return "network";
  }

  @override
  Builder faetureBody() {
    return Builder(builder: (context) {
      return Container();
    });
  }

  @override
  Widget featureIcon(BuildContext context, bool selected) {
    return Icon(
      Icons.network_ping,
      size: 18,
      color: selected
          ? Theme.of(context).primaryColor
          : Colors.black.withAlpha(135),
    );
  }

  @override
  String featureTitle() {
    return "网络";
  }
}
