import 'package:action_chain/constants/icons_for_checkbox.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_theme.dart';
import 'package:flutter/material.dart';

void notifyActionMethodOrStepIsEditted({
  required BuildContext context,
  required String title,
  required bool isChecked,
}) {
  SnackBar snackBar = SnackBar(
    duration: const Duration(milliseconds: 900),
    behavior: SnackBarBehavior.floating,
    backgroundColor:
        acThemeDataList[SettingData.shared.selectedThemeIndex].panelColor,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // 左側のチェックボックス
            Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 16, 0),
                // const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Transform.scale(
                    scale: 1.2,
                    child: getIcon(isChecked: isChecked),
                  ),
                )),
            // toDoのタイトル
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(isChecked ? 0.3 : 0.5)),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  // スナックバーが表示されていたら消す
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
