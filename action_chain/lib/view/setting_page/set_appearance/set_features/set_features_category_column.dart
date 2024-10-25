import 'package:flutter/material.dart';
import 'package:action_chain/model/ac_theme.dart';
import 'package:action_chain/model/user/setting_data.dart';

class SetFeaturesCategoryColumn extends StatelessWidget {
  final String featuresCategoryName;
  final List<Widget> children;
  const SetFeaturesCategoryColumn(
      {Key? key, required this.featuresCategoryName, required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "- $featuresCategoryName -",
              style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: acThemeDataList[SettingData.shared.selectedThemeIndex]
                      .titleColorOfSettingPage),
            ),
          ),
          Column(
            children: children,
          )
        ],
      ),
    );
  }
}
