import 'package:consoleapp/features/console/console_content.dart';
import 'package:consoleapp/features/console/console_filter.dart';
import 'package:flutter/material.dart';

class ConsoleHome extends StatefulWidget {
  const ConsoleHome({super.key});

  @override
  State<ConsoleHome> createState() => _ConsoleHomeState();
}

class _ConsoleHomeState extends State<ConsoleHome> {
  static final controller = ConsoleFilterController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConsoleFilter(
          controller: controller,
        ),
        Divider(height: 1, color: Theme.of(context).dividerColor),
        Expanded(
          child: ConsoleContent(
            controller: controller,
          ),
        )
      ],
    );
  }
}
