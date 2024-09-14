import 'package:action_chain/view/setting_page/my_page/tips_page/tips.dart';
import 'package:action_chain/view/setting_page/my_page/tips_page/tips_category_card/button_to_docs.dart';
import 'package:action_chain/view/setting_page/my_page/tips_page/tips_category_card/tips_category_block.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';

class SelectTipsPanel extends StatefulWidget {
  const SelectTipsPanel({Key? key}) : super(key: key);

  @override
  State<SelectTipsPanel> createState() => _SelectTipsPanelState();
}

class _SelectTipsPanelState extends State<SelectTipsPanel> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme[settingData.selectedTheme]!.myPagePanelColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          // 基本機能
          TipsCategoryBlock(
              shouldShowTips: true,
              headerForThisTips: actionChainTips.keys.toList()[0],
              contents: [
                for (int tutorialIndex = 0;
                    tutorialIndex <
                        actionChainTips[actionChainTips.keys.toList()[0]]!
                            .length;
                    tutorialIndex++)
                  ButtonToDocs(
                      title: actionChainTips[actionChainTips.keys.toList()[0]]![
                              tutorialIndex]
                          .titleInCard,
                      url: actionChainTips[actionChainTips.keys.toList()[0]]![
                              tutorialIndex]
                          .urlOfThisTutorial),
              ]),
          // 補助機能などに関するtips
          for (String categoryOfTips
              in actionChainTips.keys.toList().sublist(1))
            TipsCategoryBlock(
                shouldShowTips: false,
                headerForThisTips: categoryOfTips,
                contents: [
                  for (int tutorialIndex = 0;
                      tutorialIndex < actionChainTips[categoryOfTips]!.length;
                      tutorialIndex++)
                    ButtonToDocs(
                        title: actionChainTips[categoryOfTips]![tutorialIndex]
                            .titleInCard,
                        url: actionChainTips[categoryOfTips]![tutorialIndex]
                            .urlOfThisTutorial),
                ]),
        ],
      ),
    );
  }
}
