import 'package:action_chain/component/dialog/ac_single_option_dialog.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/model/ac_theme.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/external/ac_pref.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class SettingData {
  static SettingData shared = SettingData(
      selectedThemeIndex: 0,
      defaultIconCategory: "Default",
      iconRarity: "Common",
      defaultIconName: "box",
      isFirstEntry: true,
      canVibrate: false);
  // テーマ
  int selectedThemeIndex;
  // アイコン
  String defaultIconCategory;
  String iconRarity;
  String defaultIconName;
  // チュートリアル
  bool isFirstEntry;
  // バイブレーションできるかどうか
  bool canVibrate;

  SettingData({
    required this.selectedThemeIndex,
    required this.defaultIconCategory,
    required this.iconRarity,
    required this.defaultIconName,
    required this.isFirstEntry,
    required this.canVibrate,
  });

  Map<String, dynamic> toJson() {
    return {
      // テーマ
      "selectedThemeIndex": SettingData.shared.selectedThemeIndex,
      // アイコン
      "defaultIconCategory": SettingData.shared.defaultIconCategory,
      "iconRarity": iconRarity,
      "defaultIconName": SettingData.shared.defaultIconName,
      // チュートリアル
      "isFirstEntry": SettingData.shared.isFirstEntry,
    };
  }

  factory SettingData.fromJson(Map<String, dynamic> jsonData) {
    return SettingData(
      selectedThemeIndex: jsonData["selectedThemeIndex"] ?? 0,
      defaultIconCategory: jsonData["defaultIconCategory"] ?? "Default",
      iconRarity: jsonData["iconRarity"] ?? "Common",
      defaultIconName: jsonData["defaultIconName"] ?? "box",
      isFirstEntry: jsonData["isFirstEntry"],
      canVibrate: jsonData["canVibrate"] ?? false,
    );
  }

  // 設定を読み込む関数
  Future<void> readSettings() async {
    await ACPref().getPref.then((pref) {
      if (pref.getString("settingData") != null) {
        SettingData.shared =
            SettingData.fromJson(json.decode(pref.getString("settingData")!));
      }
    });
  }

  // 全ての設定を保存する関数
  void saveSettings() {
    ACPref().getPref.then((pref) {
      pref.setString("settingData", json.encode(SettingData.shared.toJson()));
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
            backgroundColor: acThemeDataList[relevantThemeIndex].alertColor,
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
                          gradient: acThemeDataList[relevantThemeIndex]
                              .gradientOfNavBar,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GlassContainer(
                          child: Align(
                            alignment: Alignment.center,
                            child: Card(
                              elevation: 5,
                              color: acThemeDataList[relevantThemeIndex]
                                  .panelColor,
                              child: Container(
                                width: 150,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  acThemeDataList[relevantThemeIndex].themeName,
                                  style: TextStyle(
                                      color: acThemeDataList[relevantThemeIndex]
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
                  OverflowBar(
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
                              color: acThemeDataList[relevantThemeIndex]
                                  .accentColor),
                        ),
                        // InkWell
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.resolveWith(
                              (states) => acThemeDataList[relevantThemeIndex]
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
                            SettingData.shared.selectedThemeIndex =
                                relevantThemeIndex;
                            setAppearancePageKey.currentState?.setState(() {});
                            actionChainAppKey.currentState?.setState(() {});
                            ACVibration.vibrate();
                            ACSingleOptionDialog.show(
                                context: context,
                                title: "変更成功",
                                message: "変更することに\n成功しました！");
                            SettingData.shared.saveSettings();
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
                                (states) => acThemeDataList[relevantThemeIndex]
                                    .accentColor
                                    .withOpacity(0.2)),
                          ),
                          child: Text("変更",
                              style: TextStyle(
                                  color: acThemeDataList[relevantThemeIndex]
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
  void setDefaultIcon(
      {required BuildContext context,
      required String categoryNameOfThisIcon,
      required String selectedIconRarity,
      required String iconName}) {
    SettingData.shared.defaultIconCategory = categoryNameOfThisIcon;
    SettingData.shared.iconRarity = selectedIconRarity;
    SettingData.shared.defaultIconName = iconName;
    setAppearancePageKey.currentState?.setState(() {});
    ACVibration.vibrate();
    ACSingleOptionDialog.show(
      context: context,
      title: "アイコンの変更",
      message: "チェックマークのアイコンを\n変更しました",
    );
    SettingData.shared.saveSettings();
  }
}
