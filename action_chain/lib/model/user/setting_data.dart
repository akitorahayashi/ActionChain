import 'package:action_chain/alerts/simple_alert.dart';
import 'package:action_chain/alerts/yes_no_alert.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

SettingData settingData = SettingData();

class SettingData {
  // テーマ
  int selectedThemeIndex = 0;

  // アイコン
  String defaultIconCategory = "Default";
  String iconRarity = "Common";
  String defaultIconName = "box";
  // チュートリアル
  bool isFirstEntry = true;

  // バイブレーションできるかどうか
  bool canVibrate = false;

  SettingData();

  Map<String, dynamic> toJson() {
    return {
      // テーマ
      "selectedThemeIndex": settingData.selectedThemeIndex,
      // アイコン
      "defaultIconCategory": settingData.defaultIconCategory,
      "iconRarity": iconRarity,
      "defaultIconName": settingData.defaultIconName,
      // チュートリアル
      "isFirstEntry": settingData.isFirstEntry,
    };
  }

  SettingData.fromJson(Map<String, dynamic> jsonData)
      :
        // テーマ
        selectedThemeIndex = jsonData["selectedThemeIndex"] ?? 0,
        // アイコン
        defaultIconCategory = jsonData["defaultIconCategory"] ?? "Default",
        iconRarity = jsonData["iconRarity"] ?? "Common",
        defaultIconName = jsonData["defaultIconName"] ?? "box",
        // チュートリアル
        isFirstEntry = jsonData["isFirstEntry"];

  // 設定を読み込む関数
  Future<void> readSettings() async {
    await SharedPreferences.getInstance().then((pref) {
      if (pref.getString("settingData") != null) {
        settingData =
            SettingData.fromJson(json.decode(pref.getString("settingData")!));
      }
    });
  }

  // 全ての設定を保存する関数
  void saveSettings() {
    SharedPreferences.getInstance().then((pref) {
      pref.setString("settingData", json.encode(settingData.toJson()));
    });
  }

  // テーマを変更する関数
  Future<void> confirmToChangeTheme(
      {required BuildContext context, required int relevantThemeIndex}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: acTheme[relevantThemeIndex].alertColor,
            child: DefaultTextStyle(
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black45),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // テーマの模型
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      width: 250,
                      height: 80,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient:
                              acTheme[relevantThemeIndex].gradientOfNavBar,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GlassContainer(
                          child: Align(
                            alignment: Alignment.center,
                            child: Card(
                              elevation: 5,
                              color: acTheme[relevantThemeIndex].panelColor,
                              child: Container(
                                width: 150,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  acTheme[relevantThemeIndex].themeName,
                                  style: TextStyle(
                                      color: acTheme[relevantThemeIndex]
                                          .checkmarkColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text("$relevantThemeIndexに変更しますか？"),
                  ),
                  // 操作ボタン
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 戻るボタン
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "戻る",
                          style: TextStyle(
                              color: acTheme[relevantThemeIndex].accentColor),
                        ),
                        // InkWell
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.resolveWith(
                              (states) => acTheme[relevantThemeIndex]
                                  .accentColor
                                  .withOpacity(0.2)),
                        ),
                      ),
                      // 変更するボタン
                      TextButton(
                          onPressed: () {
                            // このアラートを消す
                            Navigator.pop(context);
                            // if (settingData.userLevel >= 5) {
                            settingData.selectedThemeIndex = relevantThemeIndex;
                            setAppearancePageKey.currentState?.setState(() {});
                            actionChainAppKey.currentState?.setState(() {});
                            ACVibration.vibrate();
                            // thank youアラート
                            simpleAlert(
                                context: context,
                                title: "変更することに\n成功しました！",
                                message: null,
                                buttonText: "OK");
                            settingData.saveSettings();
                            // } else {
                            //   simpleAlert(
                            //       context: context,
                            //       title: "エラー",
                            //       message: "User Levelが5以上になるとテーマを変更できるようになります",
                            //       buttonText: "OK");
                            // }
                          },
                          // InkWell
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.resolveWith(
                                (states) => acTheme[relevantThemeIndex]
                                    .accentColor
                                    .withOpacity(0.2)),
                          ),
                          child: Text("変更",
                              style: TextStyle(
                                  color: acTheme[relevantThemeIndex]
                                      .accentColor))),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  // チェックマークのアイコンを変える関数
  Future<void> askToSetDefaultIcon(
      {required BuildContext context,
      required String categoryNameOfThisIcon,
      required String selectedIconRarity,
      required String iconName}) {
    return yesNoAlert(
        context: context,
        title: "アイコンの変更",
        message: "チェックマークのアイコンを\n変更しますか?",
        yesAction: () {
          Navigator.pop(context);
          // if (settingData.userLevel >= 10) {
          settingData.defaultIconCategory = categoryNameOfThisIcon;
          settingData.iconRarity = selectedIconRarity;
          settingData.defaultIconName = iconName;
          setAppearancePageKey.currentState?.setState(() {});
          ACVibration.vibrate();
          simpleAlert(
              context: context,
              title: "チェックマークのアイコンを変更しました",
              message: null,
              buttonText: "OK");
          settingData.saveSettings();
          // } else {
          //   simpleAlert(
          //       context: context,
          //       title: "エラー",
          //       message: "User Levelが10以上になるとアイコンを変更できるようになります",
          //       buttonText: "OK");
          // }
        });
  }
}
