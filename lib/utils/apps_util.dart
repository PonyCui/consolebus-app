import 'package:flutter/material.dart';

class AppsUtil {
  static bool isMobileMode(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 500;
  }
}