import 'package:consoleapp/apps_feature.dart';
import 'package:flutter/material.dart';

class AppsMenuBar extends StatelessWidget {
  final String selectedFeature;
  final Function(String) onSelectFeature;

  const AppsMenuBar({
    super.key,
    required this.selectedFeature,
    required this.onSelectFeature,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 247, 247, 247),
      width: 40,
      child: Column(
        children: AppsFeatureManager.shared.allFeatures().map((el) {
          return AppsMenuButton(
            feature: el,
            selected: el.featureIdentifier() == selectedFeature,
            onSelect: () {
              onSelectFeature(el.featureIdentifier());
            },
          );
        }).toList(),
      ),
    );
  }
}

class AppsMenuButton extends StatelessWidget {
  final AppsFeature feature;
  final bool selected;
  final Function onSelect;

  const AppsMenuButton({
    super.key,
    required this.feature,
    this.selected = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: feature.featureTitle(),
      child: MaterialButton(
        onPressed: () {
          onSelect();
        },
        padding: EdgeInsets.zero,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 3,
                color: selected
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
              ),
              Expanded(
                child: feature.featureIcon(context, selected),
              )
            ],
          ),
        ),
      ),
    );
  }
}
