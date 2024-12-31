import 'package:flutter/material.dart';

abstract class AppsFeature {
  String featureIdentifier();
  Widget featureIcon(BuildContext context, bool selected);
  String featureTitle();
  Builder faetureBody();
}

class AppsFeatureManager {
  static final shared = AppsFeatureManager._();

  AppsFeatureManager._();

  final List<AppsFeature> _features = [];

  void registerFeature(AppsFeature value) {
    _features.add(value);
  }

  List<AppsFeature> allFeatures() {
    return _features.toList();
  }

  AppsFeature findFeature(String featureIdentifier) {
    return _features.firstWhere((el) {
      return el.featureIdentifier() == featureIdentifier;
    });
  }
}
