import 'package:action_chain/constants/icons_for_checkbox.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/view/setting_page/set_appearance/set_icon/icon_block/icon_block.dart';
import 'package:flutter/material.dart';

class IconCategoryPanel extends StatelessWidget {
  final String iconCategoryName;
  const IconCategoryPanel({Key? key, required this.iconCategoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            // カテゴリー名
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
              child: Text(
                iconCategoryName,
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: theme[settingData.selectedTheme]!.checkmarkColor),
              ),
            ),
            // Super Rare, Rare
            Row(
              children: [
                if (iconsForCheckBox[iconCategoryName]!["Super Rare"]!
                    .isNotEmpty)
                  Expanded(
                      flex: 2,
                      child: IconBlock(
                        categoryNameForIcons: iconCategoryName,
                        iconRarity: "Super Rare",
                      )),
                if (iconsForCheckBox[iconCategoryName]!["Rare"]!.isNotEmpty)
                  Expanded(
                      flex: 3,
                      child: IconBlock(
                        categoryNameForIcons: iconCategoryName,
                        iconRarity: "Rare",
                      )),
              ],
            ),
            // Common
            IconBlock(
              categoryNameForIcons: iconCategoryName,
              iconRarity: "Common",
            ),
          ],
        ),
      ),
    );
  }
}
