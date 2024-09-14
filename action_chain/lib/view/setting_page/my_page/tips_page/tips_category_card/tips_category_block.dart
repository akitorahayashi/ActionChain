import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:flutter/material.dart';

class TipsCategoryBlock extends StatelessWidget {
  final bool shouldShowTips;
  final String headerForThisTips;
  final List<Widget> contents;
  const TipsCategoryBlock(
      {Key? key,
      required this.shouldShowTips,
      required this.headerForThisTips,
      required this.contents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // tips
            if (shouldShowTips)
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
                child: Align(
                  child: Text(
                    "Tips",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: theme[settingData.selectedTheme]!
                            .accentColor
                            .withOpacity(0.8)),
                  ),
                ),
              ),
            // tips_header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 0, 6),
              child: Text(
                headerForThisTips,
                style: TextStyle(
                    color: theme[settingData.selectedTheme]!.accentColor,
                    fontSize: 21,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // contents
            ...contents,
          ],
        ),
      ),
    );
  }
}
