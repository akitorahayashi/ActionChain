import 'package:action_chain/model/ac_chain.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';

class ShowLevelPanel extends StatefulWidget {
  const ShowLevelPanel({Key? key}) : super(key: key);

  @override
  State<ShowLevelPanel> createState() => _ShowLevelPanelState();
}

class _ShowLevelPanelState extends State<ShowLevelPanel> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme[settingData.selectedTheme]!.myPagePanelColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          // 今のLevelを表示
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
            child: Align(
              child: Text(
                "User Level: ${settingData.userLevel}",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: theme[settingData.selectedTheme]!
                        .accentColor
                        .withOpacity(0.8)),
              ),
            ),
          ),
          // indicator
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: theme[settingData.selectedTheme]!
                    .accentColor
                    .withOpacity(0.1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                child: LinearProgressIndicator(
                  value: settingData.countRestToLevelUp() /
                      settingData.numberOfRequiredTaskToLevelUp(
                          levelPhase: settingData.currentLevelPhase),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: Text(
                    "次のレベルまであと${settingData.numberOfRequiredTaskToLevelUp(levelPhase: settingData.currentLevelPhase) - settingData.countRestToLevelUp()}個！",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.3)),
                  ),
                )
              ],
            ),
          ),
          // 自分がこなしたToDoの数
          Text(
            "- いままでこなしたActionの数 -",
            style: TextStyle(
              color: Colors.black.withOpacity(0.45),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0, bottom: 16.0),
            child: Text(
              ACChain.numberOfComplitedActionMethods.toString(),
              style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: theme[settingData.selectedTheme]!
                      .accentColor
                      .withOpacity(0.8)),
            ),
          )
        ]),
      ),
    );
  }
}
