// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:action_chain/constants/icons_for_checkbox.dart';
import 'package:action_chain/view/setting_page/set_appearance/set_icon/icon_category_panel.dart';
import 'package:action_chain/view/setting_page/set_appearance/theme_panels/bottom_theme_panel.dart';
import 'package:action_chain/view/setting_page/set_appearance/theme_panels/top_theme_panel.dart';
import 'package:action_chain/components/ui/panel_with_title.dart';
import 'package:flutter/material.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/constants/theme.dart';

class SetAppearancePage extends StatefulWidget {
  const SetAppearancePage({
    required Key key,
  }) : super(key: key);

  @override
  _SetAppearancePageState createState() => _SetAppearancePageState();
}

class _SetAppearancePageState extends State<SetAppearancePage> {
  @override
  Widget build(BuildContext context) {
    // テーマを表示させるための変数
    List<String> unUsingTheme = acTheme.keys
        .where((themeName) => themeName != settingData.selectedTheme)
        .toList();

    return Center(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: PanelWithTitle(
                title: "THEME",
                content: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: .5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        TopThemePanel(),
                        BottomThemePanel(themeName: unUsingTheme[0]),
                        BottomThemePanel(themeName: unUsingTheme[1]),
                      ],
                    ),
                  ),
                )),
          ),

          // ICONS選択カード
          PanelWithTitle(
              title: "ICONS",
              content: Column(
                children: [
                  for (String iconCategoryName in iconsForCheckBox.keys)
                    IconCategoryPanel(iconCategoryName: iconCategoryName)
                ],
              )),
          const SizedBox(
            height: 250,
          )
        ],
      ),
    );
  }
}
