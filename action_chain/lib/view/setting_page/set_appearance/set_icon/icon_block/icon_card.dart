import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/icons_for_checkbox.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/external/ac_ads.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:flutter/material.dart';

class IconCard extends StatefulWidget {
  final bool isEarned;
  final String iconCategoryName;
  final String selectedIconRarity;
  final String iconName;
  const IconCard({
    Key? key,
    required this.isEarned,
    required this.iconCategoryName,
    required this.selectedIconRarity,
    required this.iconName,
  }) : super(key: key);

  @override
  State<IconCard> createState() => _IconCardState();
}

class _IconCardState extends State<IconCard> {
  bool get isFontawesomeCategories =>
      fontawesomeCategories.contains(widget.iconCategoryName);
  @override
  Widget build(BuildContext context) {
    final bool isFocused =
        widget.iconCategoryName == settingData.defaultIconCategory &&
            widget.selectedIconRarity == settingData.iconRarity &&
            widget.iconName == settingData.defaultIconName;
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: isFocused
            ? null
            : !widget.isEarned
                // アイコンを獲得するページに遷移するか確認する
                ? () => acads.confirmToGoToProPageToShowAd(
                    context: context,
                    superKey: settingPageKey,
                    isBannerService: false,
                    title: "アイコンを獲得しますか？",
                    message: "無料で獲得できるCoinでガチャを回すことでアイコンを解放できます！")

                // アイコンを変えるか尋ねる
                : () => settingData.askToSetDefaultIcon(
                    context: context,
                    categoryNameOfThisIcon: widget.iconCategoryName,
                    selectedIconRarity: widget.selectedIconRarity,
                    iconName: widget.iconName),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: isFocused ? 0 : 3,
          color: theme[settingData.selectedTheme]!.panelColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: isFontawesomeCategories ? 3 : 0,
                      bottom: isFontawesomeCategories ? 4 : 2.0),
                  child: Icon(
                    !widget.isEarned
                        ? Icons.help_outline
                        : isFocused
                            ? iconsForCheckBox[widget.iconCategoryName]![widget
                                    .selectedIconRarity]![widget.iconName]!
                                .checkedIcon
                            : iconsForCheckBox[widget.iconCategoryName]![widget
                                    .selectedIconRarity]![widget.iconName]!
                                .notCheckedIcon,
                    color: !widget.isEarned
                        ? Colors.black.withOpacity(0.3)
                        : isFocused
                            ? theme[settingData.selectedTheme]!.checkmarkColor
                            : Colors.black.withOpacity(0.5),
                    size: isFontawesomeCategories ? 17 : 20,
                  ),
                ),
                Text(
                  !widget.isEarned ? "???" : widget.iconName,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: !widget.isEarned
                          ? Colors.black.withOpacity(0.3)
                          : isFocused
                              ? theme[settingData.selectedTheme]!.checkmarkColor
                              : Colors.black.withOpacity(0.5)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
