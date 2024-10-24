import 'package:action_chain/alerts/simple_alert.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/model/ac_workspace/ac_workspaces.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_todo/ac_chain.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const String noneId = "---n";

class ACCategory {
  String id;
  String title;

  ACCategory({required this.id, required this.title});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
    };
  }

  ACCategory.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData["id"] ?? UniqueKey().toString(),
        title = jsonData["title"];

  static Future<String?> addCategoryAlert({
    required BuildContext context,
  }) async {
    String? returnedCategoryId;
    // カテゴリーを作成するためのmember
    String? _enteredCategoryName;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: acTheme[settingData.selectedTheme]!.alertColor,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // スペーサー
                const SizedBox(
                  height: 30,
                ),
                // 新しいカテゴリー名を入力するTextFormField
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: SizedBox(
                      width: 230,
                      child: TextField(
                        autofocus: true,
                        onChanged: (String? enteredCategoryName) {
                          if (enteredCategoryName != null &&
                              enteredCategoryName.trim().isNotEmpty) {
                            _enteredCategoryName = enteredCategoryName;
                          } else {
                            _enteredCategoryName = null;
                          }
                        },
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "新しいカテゴリー名",
                          hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.35),
                              fontWeight: FontWeight.w600),
                        ),
                      )),
                ),
                // 閉じる 追加するボタン
                OverflowBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // カテゴリーを作らずにアラートを閉じるボタン
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("閉じる")),
                    // カテゴリーを追加するボタン
                    TextButton(
                        onPressed: () {
                          if (_enteredCategoryName != null) {
                            final String newCategoryId = UniqueKey().toString();
                            // todo category
                            // categoriesを更新
                            ACWorkspace.currentWorkspace.chainCategories.add(
                                ACCategory(
                                    id: newCategoryId,
                                    title: _enteredCategoryName!));
                            ACWorkspace.currentWorkspace
                                .savedChains[newCategoryId] = [];
                            // chainsを更新
                            ACWorkspace.currentWorkspace
                                .keepedChains[newCategoryId] = [];
                            selectChainWallKey.currentState?.setState(() {});
                            // 保存
                            ACCategory.saveChainCategoriesInCurrentWorkspace();
                            ActionChain.saveActionChains(isSavedChains: true);
                            ActionChain.saveActionChains(isSavedChains: false);

                            ACVibration.vibrate();
                            returnedCategoryId = newCategoryId;
                            Navigator.pop(context);
                            ACCategory.notifyCategoryIsAdded(
                                context: context,
                                addedCategoryName: _enteredCategoryName!);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("追加"))
                  ],
                )
              ],
            ),
          );
        });
    return returnedCategoryId;
  }

  static void notifyCategoryIsAdded(
      {required BuildContext context, required String addedCategoryName}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: acTheme[settingData.selectedTheme]!.alertColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 12),
                    child: Text(
                      addedCategoryName,
                      style: TextStyle(
                          color:
                              acTheme[settingData.selectedTheme]!.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Text(
                    "を追加しました",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"))
                ],
              ),
            ),
          );
        });
  }

  static void showRenameCategoryDialog(
      {required BuildContext context,
      required int indexOfCategoryInCategories}) {
    final ACCategory _oldCategory = ACWorkspace
        .currentWorkspace.chainCategories[indexOfCategoryInCategories];
    // textFieldに改名する準備をする
    String? newCategoryName = _oldCategory.title;
    TextEditingController _controllerForRename =
        TextEditingController(text: _oldCategory.title);
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            backgroundColor: acTheme[settingData.selectedTheme]!.alertColor,
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text("元のカテゴリー名",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.w600)),
                ),
                Text(
                  _oldCategory.title,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            content: SizedBox(
              height: 150,
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 新しいカテゴリー名を入力するTextFormField
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: SizedBox(
                          width: 230,
                          child: TextFormField(
                            autofocus: true,
                            controller: _controllerForRename,
                            onChanged: (String? enteredCategoryName) {
                              if (enteredCategoryName != null &&
                                  enteredCategoryName.trim() != "") {
                                newCategoryName = enteredCategoryName;
                              } else {
                                newCategoryName = null;
                              }
                            },
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: "新しいカテゴリー名",
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.35),
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ),
                    // 戻す、完了ボタン
                    OverflowBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 戻すボタン
                        TextButton(
                          onPressed: () {
                            newCategoryName = null;
                            Navigator.pop(context);
                          },
                          child: Text(
                            "戻す",
                            style: TextStyle(
                                color: acTheme[settingData.selectedTheme]!
                                    .accentColor),
                          ),
                        ),
                        // 完了ボタン
                        TextButton(
                          // なかったらdisable
                          onPressed: () {
                            if (newCategoryName == null) {
                              Navigator.pop(context);
                            } else {
                              // chain category
                              ACWorkspace
                                  .currentWorkspace
                                  .chainCategories[indexOfCategoryInCategories]
                                  .title = newCategoryName!;
                              selectChainWallKey.currentState?.setState(() {});
                              ACCategory
                                  .saveChainCategoriesInCurrentWorkspace();

                              ACVibration.vibrate();
                              Navigator.pop(context);
                              // thank you アラート
                              simpleAlert(
                                  context: context,
                                  title: "変更することに\n成功しました",
                                  message: null,
                                  buttonText: "OK");
                            }
                          },
                          child: Text(
                            "完了",
                            style: TextStyle(
                                color: acTheme[settingData.selectedTheme]!
                                    .accentColor),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void confirmToDeleteThisCategory(
      {required BuildContext context,
      required int indexOfCategoryInCategories}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: acTheme[settingData.selectedTheme]!.alertColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // カテゴリーの削除
                  Text(
                    "カテゴリーの削除",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600),
                  ),
                  // カテゴリー名を表示
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 15.0, left: 12, right: 10),
                    child: Text(
                      ACWorkspace.currentWorkspace
                          .chainCategories[indexOfCategoryInCategories].title,
                      style: TextStyle(
                          color:
                              acTheme[settingData.selectedTheme]!.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  // ※カテゴリーに含まれる分析も削除されます
                  Text(
                    "※ カテゴリーに含まれるChain\n  も一緒に削除されます",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600),
                  ),
                  // はい、いいえボタン
                  OverflowBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // いいえボタン
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("戻る")),
                      // はいボタン
                      TextButton(
                          onPressed: () {
                            // アラートを消す
                            Navigator.pop(context);
                            // categoriesから削除
                            final ACCategory removedCategory = ACWorkspace
                                .currentWorkspace.chainCategories
                                .removeAt(indexOfCategoryInCategories);
                            // savedChainsから削除
                            ACWorkspace.currentWorkspace.savedChains
                                .remove(removedCategory.id);
                            // keepedChainsから削除
                            ACWorkspace.currentWorkspace.keepedChains
                                .remove(removedCategory.id);
                            // このアラートを消して thank you アラートを表示する
                            selectChainWallKey.currentState?.setState(() {});
                            // セーブする
                            ACCategory.saveChainCategoriesInCurrentWorkspace();
                            ActionChain.saveActionChains(isSavedChains: true);
                            ActionChain.saveActionChains(isSavedChains: false);

                            ACVibration.vibrate();
                            simpleAlert(
                                context: context,
                                title: "削除することに\n成功しました",
                                message: null,
                                buttonText: "OK");
                          },
                          child: const Text("削除"))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  // --- save ---

  static void saveChainCategoriesInCurrentWorkspace() {
    final currenWorkspaceData = acWorkspaces[ACWorkspace.currentWorkspaceIndex];
    currenWorkspaceData.chainCategories =
        ACWorkspace.currentWorkspace.chainCategories;
    acWorkspaces[ACWorkspace.currentWorkspaceIndex] = currenWorkspaceData;
    SharedPreferences.getInstance().then((pref) {
      pref.setString("acWorkspaces", json.encode(acWorkspaces));
    });
  }
}
