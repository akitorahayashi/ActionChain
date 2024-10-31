import 'package:flutter/material.dart';

class DoubleCard extends StatelessWidget {
  final Widget child;
  final Color doubleCardColor;
  const DoubleCard(
      {Key? key, required this.doubleCardColor, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: doubleCardColor,
      // color: acThemeDataList[SettingData.shared.selectedThemeIndex]
      //     .niceAppsCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: child,
      ),
    );
  }
}
