import 'package:action_chain/alerts/simple_alert.dart';
import 'package:action_chain/alerts/yes_no_alert.dart';
import 'package:action_chain/model/ac_chain.dart';
import 'package:action_chain/model/external/admob.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';

SettingData settingData = SettingData();

class SettingData {
  static const int firstStepOfLogInDay = 3;
  static const int secondStepOfLogInDay = 7;

  // phase:level:todo
  // 1 ~ 45 -> 1:10:5
  // 46 ~ 445 -> 2:50:10
  // 446 ~ 945 -> 3:75:20
  // 946 ~ 1700 -> 4:100:30
  int get currentLevelPhase => (() {
        if (ACChain.numberOfComplitedActionMethods >= 945) {
          return 4;
        } else if (ACChain.numberOfComplitedActionMethods >= 445) {
          return 3;
        } else if (ACChain.numberOfComplitedActionMethods >= 45) {
          return 2;
        } else {
          return 1;
        }
      }());

  int get userLevel => (() {
        if (ACChain.numberOfComplitedActionMethods > 945) {
          return 75 + ((ACChain.numberOfComplitedActionMethods - 945) ~/ 30);
        } else if (ACChain.numberOfComplitedActionMethods > 445) {
          return 50 + ((ACChain.numberOfComplitedActionMethods - 445) ~/ 20);
        } else if (ACChain.numberOfComplitedActionMethods > 45) {
          return 10 + ((ACChain.numberOfComplitedActionMethods - 45) ~/ 10);
        } else {
          return 1 + ACChain.numberOfComplitedActionMethods ~/ 5;
        }
      }());

  // ログイン系
  String lastEnteredDate = DateFormat("yyyy-MM-dd")
      .format(DateTime.now().subtract(const Duration(days: 2)));
  int consecutiveLoginDays = 1;
  // テーマ
  String selectedTheme = "Sun Orange";

  // アイコン
  String defaultIconCategory = "Default";
  String iconRarity = "Common";
  String defaultIconName = "box";
  Map<String, List<String>> earnedIcons = {
    "Default": ["box", "circle"],
  };
  // コード
  List<String> earnedPromotionCodes = [];

  // チュートリアル
  bool isFirstEntry = true;

  // バイブレーションできるかどうか
  bool canVibrate = false;

  SettingData();

  Map<String, dynamic> toJson() {
    return {
      // ログイン系
      "lastEnteredDate": settingData.lastEnteredDate,
      "consecutiveLoginDays": settingData.consecutiveLoginDays,
      // テーマ
      "selectedTheme": settingData.selectedTheme,
      // アイコン
      "defaultIconCategory": settingData.defaultIconCategory,
      "iconRarity": iconRarity,
      "defaultIconName": settingData.defaultIconName,
      "earnedIcons":
          SettingData.earnedIconsToString(earnedIcons: settingData.earnedIcons),
      // コード
      "earnedPromotionCodes": json.encode(settingData.earnedPromotionCodes),
      // チュートリアル
      "isFirstEntry": settingData.isFirstEntry,
    };
  }

  SettingData.fromJson(Map<String, dynamic> jsonData)
      :
        // ログイン系
        lastEnteredDate = jsonData["lastEnteredDate"] ??
            DateFormat("yyyy-MM-dd")
                .format(DateTime.now().subtract(const Duration(days: 2))),
        consecutiveLoginDays = jsonData["consecutiveLoginDays"] ?? 1,
        // テーマ
        selectedTheme = jsonData["selectedTheme"] ?? "Sun Orange",
        // アイコン
        defaultIconCategory = jsonData["defaultIconCategory"] ?? "Default",
        iconRarity = jsonData["iconRarity"] ?? "Common",
        defaultIconName = jsonData["defaultIconName"] ?? "box",
        earnedIcons = jsonData["earnedIcons"] != null
            ? SettingData.stringToEarnedIcons(
                stringEarnedIconsData: jsonData["earnedIcons"])
            : {
                "Default": ["box", "circle"],
              },
        // コード
        earnedPromotionCodes = jsonData["earnedPromotionCodes"] == null
            ? []
            : json.decode(jsonData["earnedPromotionCodes"]).cast<String>()
                as List<String>,
        // チュートリアル
        isFirstEntry = jsonData["isFirstEntry"];

  // 設定を読み込む関数
  void readSettings() {
    SharedPreferences.getInstance().then((pref) {
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

  int numberOfRequiredTaskToLevelUp({required int levelPhase}) {
    switch (levelPhase) {
      case 4:
        return 30;
      case 3:
        return 20;
      case 2:
        return 10;
      default:
        return 5;
    }
  }

  // 今レベル1で8個こなしてるんだったら3を返す関数
  int countRestToLevelUp() {
    int numOfComplitedToDos = ACChain.numberOfComplitedActionMethods;
    int levelPhase = settingData.currentLevelPhase;
    late int rest;
    switch (levelPhase) {
      case 4:
        rest = numOfComplitedToDos -= 945;
        return rest % 30;
      case 3:
        rest = numOfComplitedToDos -= 445;
        return rest % 20;
      case 2:
        rest = numOfComplitedToDos -= 45;
        return rest % 10;
      default:
        rest = numOfComplitedToDos;
        return rest % 5;
    }
  }

  // 削除時などにレベルを表示する関数
  Future<void> showLevelAlert({
    required BuildContext context,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: theme[settingData.selectedTheme]!.alertColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // levelを表示
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 24),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3.0),
                          child: Text(
                            "User Level: ${settingData.userLevel}",
                            style: TextStyle(
                                color: theme[settingData.selectedTheme]!
                                    .accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 23),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        "今までこなしたActionの総数: ${ACChain.numberOfComplitedActionMethods}",
                        style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.5)),
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
                      padding: const EdgeInsets.only(bottom: 16.0),
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
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void receiveLogInAction({required BuildContext context}) {
    final DateFormat dateformatter = DateFormat("yyyy-MM-dd");
    final String dateOfYesterDay =
        dateformatter.format(DateTime.now().subtract(const Duration(days: 1)));
    // 報酬
    if (DateTime.parse(settingData.lastEnteredDate)
            .difference(DateTime.now())
            .inDays <=
        -8) {
      // 一週間ログインしていない場合
      settingData.consecutiveLoginDays = 1;
      admob.coinShards += 3;
      settingData.vibrate();
      simpleAlert(
          context: context,
          title: "おかえりなさい！",
          message: "戻ってきてくれてありがとう！\nコインの欠片を3つプレゼントします",
          buttonText: "thank you!");
      admob.saveAdsData();
    } else if (settingData.lastEnteredDate == dateOfYesterDay) {
      // 連続ログイン
      settingData.consecutiveLoginDays++;
      final int earnedCoinShards = settingData.consecutiveLoginDays >=
              SettingData.secondStepOfLogInDay
          ? 3
          : settingData.consecutiveLoginDays >= SettingData.firstStepOfLogInDay
              ? 2
              : 1;
      admob.coinShards += earnedCoinShards;
      settingData.vibrate();
      simpleAlert(
          context: context,
          title: settingData.consecutiveLoginDays >= 3
              ? "連続ログイン日数: ${settingData.consecutiveLoginDays}日"
              : "ログインボーナス！",
          message:
              "- 現在のCoinの欠片: ${admob.coinShards}枚-\n今回のログインでCoinの欠片を\n$earnedCoinShards枚獲得しました！${settingData.consecutiveLoginDays >= 7 ? "" : "\n\nあと${(settingData.consecutiveLoginDays < SettingData.firstStepOfLogInDay ? 3 : 7) - settingData.consecutiveLoginDays}日で獲得できる枚数が\n1枚増えます！"}",
          buttonText: "thank you!");
      admob.saveAdsData();
    } else {
      settingData.consecutiveLoginDays = 1;
      admob.coinShards++;
      settingData.vibrate();
      simpleAlert(
          context: context,
          title: "ログインボーナス！",
          message:
              "- 現在のCoinの欠片: ${admob.coinShards}枚 -\n今回のログインでCoinの欠片を1枚獲得しました！\n\nあと${SettingData.firstStepOfLogInDay - 1}日で獲得できる枚数が1枚増えます！",
          buttonText: "thank you!");
      admob.saveAdsData();
    }

    // ログインした日を記録
    settingData.lastEnteredDate = dateformatter.format(DateTime.now());
    settingData.saveSettings();
  }

  // テーマを変更する関数
  Future<void> confirmToChangeTheme(
      {required BuildContext context, required String themeName}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: theme[themeName]!.alertColor,
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
                          gradient: theme[themeName]!.gradientOfNavBar,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GlassContainer(
                          child: Align(
                            alignment: Alignment.center,
                            child: Card(
                              elevation: 5,
                              color: theme[themeName]!.panelColor,
                              child: Container(
                                width: 150,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  themeName,
                                  style: TextStyle(
                                      color: theme[themeName]!.checkmarkColor,
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
                    child: Text("$themeNameに変更しますか？"),
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
                          style:
                              TextStyle(color: theme[themeName]!.accentColor),
                        ),
                        // InkWell
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith(
                              (states) => theme[themeName]!
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
                            selectedTheme = themeName;
                            setAppearancePageKey.currentState?.setState(() {});
                            actionChainAppKey.currentState?.setState(() {});
                            settingData.vibrate();
                            // thank youアラート
                            simpleAlert(
                                context: context,
                                title: "変更することに\n成功しました!",
                                message: null,
                                buttonText: "thank you!");
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
                            overlayColor: MaterialStateProperty.resolveWith(
                                (states) => theme[themeName]!
                                    .accentColor
                                    .withOpacity(0.2)),
                          ),
                          child: Text("変更",
                              style: TextStyle(
                                  color: theme[themeName]!.accentColor))),
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
          settingData.vibrate();
          simpleAlert(
              context: context,
              title: "チェックマークのアイコンを変更しました!",
              message: null,
              buttonText: "thank you!");
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

  // バイブレーション
  void initVibrate() async {
    bool canVibrateOrNot = await Vibrate.canVibrate;
    settingData.canVibrate = canVibrateOrNot;
  }

  void vibrate() {
    if (settingData.canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }
  }

  // --- json convert ---

  static String earnedIconsToString(
      {required Map<String, List<dynamic>> earnedIcons}) {
    final iconCategories = earnedIcons.keys;
    Map<String, String> willEncodedMap = {};

    for (String iconCategoryName in iconCategories) {
      willEncodedMap[iconCategoryName] =
          json.encode(earnedIcons[iconCategoryName]!);
    }

    return json.encode(willEncodedMap);
  }

  static Map<String, List<String>> stringToEarnedIcons(
      {required String stringEarnedIconsData}) {
    var willDecodedMap = json.decode(stringEarnedIconsData);
    final iconCategoryNames = willDecodedMap.keys;

    Map<String, List<String>> willReturnedMap = {};

    for (String iconCategoryName in iconCategoryNames) {
      willReturnedMap[iconCategoryName] = json
          .decode(willDecodedMap[iconCategoryName]!)
          .cast<String>() as List<String>;
    }

    return willReturnedMap;
  }

  // --- json convert ---
}
