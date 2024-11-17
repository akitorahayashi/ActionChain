import 'package:action_chain/component/dialog/ac_yes_no_dialog.dart';
import 'package:action_chain/constants/icons_for_checkbox.dart';
import 'package:action_chain/model/ac_theme.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:flutter/material.dart';

class IconCard extends StatefulWidget {
  final String iconCategoryName;
  final String selectedIconRarity;
  final String iconName;
  const IconCard({
    Key? key,
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
    final ACThemeData _acThemeData = ACTheme.of(context);
    final bool isFocused =
        widget.iconCategoryName == SettingData.shared.defaultIconCategory &&
            widget.selectedIconRarity == SettingData.shared.iconRarity &&
            widget.iconName == SettingData.shared.defaultIconName;
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: isFocused
            ? null
            : () async {
                ACYesNoDialog.show(
                    context: context,
                    title: "アイコンの変更",
                    message: "チェックマークのアイコンを\n変更しますか?",
                    yesAction: () {
                      Navigator.pop(context);
                    });
                SettingData.shared.setDefaultIcon(
                    context: context,
                    categoryNameOfThisIcon: widget.iconCategoryName,
                    selectedIconRarity: widget.selectedIconRarity,
                    iconName: widget.iconName);
              },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: isFocused ? 0 : 3,
          color: _acThemeData.panelColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: isFontawesomeCategories ? 3 : 0,
                      bottom: isFontawesomeCategories ? 4 : 2.0),
                  child: Icon(
                    isFocused
                        ? iconsForCheckBox[widget.iconCategoryName]![
                                widget.selectedIconRarity]![widget.iconName]!
                            .checkedIcon
                        : iconsForCheckBox[widget.iconCategoryName]![
                                widget.selectedIconRarity]![widget.iconName]!
                            .notCheckedIcon,
                    color: isFocused
                        ? _acThemeData.checkmarkColor
                        : Colors.black.withOpacity(0.5),
                    size: isFontawesomeCategories ? 17 : 20,
                  ),
                ),
                Text(
                  widget.iconName,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isFocused
                          ? _acThemeData.checkmarkColor
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
