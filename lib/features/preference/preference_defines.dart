import 'package:consoleapp/apps_feature.dart';
import 'package:consoleapp/features/preference/preference_home.dart';
import 'package:flutter/material.dart';

class PreferenceFeature extends AppsFeature {
  @override
  String featureIdentifier() {
    return "preference";
  }

  @override
  Builder faetureBody() {
    return Builder(builder: (context) {
      return const PreferenceHome();
    });
  }

  @override
  Widget featureIcon(BuildContext context, bool selected) {
    return Icon(
      Icons.storage,
      size: 18,
      color: selected
          ? Theme.of(context).primaryColor
          : Colors.black.withAlpha(135),
    );
  }

  @override
  String featureTitle() {
    return "偏好设置";
  }
}