import 'package:action_chain/alerts/simple_alert.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_chain.dart';
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
    required bool isChainCategory,
  }) async {
    String? returnedCategoryId;
    // カテゴリーを作成するためのmember
    String? _enteredCategoryName;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: theme[settingData.selectedTheme]!.alertColor,
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
                ButtonBar(
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
                            if (isChainCategory) {
                              // todo category
                              // categoriesを更新
                              currentWorkspace.chainCategories.add(ACCategory(
                                  id: newCategoryId,
                                  title: _enteredCategoryName!));
                              currentWorkspace.savedChains[newCategoryId] = [];
                              // chainsを更新
                              currentWorkspace.keepedChains[newCategoryId] = [];
                              selectChainWallKey.currentState?.setState(() {});
                              // 保存
                              ACCategory
                                  .saveChainCategoriesInCurrentWorkspace();
                              ACChain.saveKeepedChains();
                              ACChain.saveSavedChains();
                            } else {
                              // workspace category
                              workspaceCategories.add(ACCategory(
                                  id: newCategoryId,
                                  title: _enteredCategoryName!));
                              // workspacesを更新
                              acWorkspaces[newCategoryId] = [];

                              manageWorkspacePageKey.currentState
                                  ?.setState(() {});
                              // 保存
                              ACCategory.saveWorkspaceCategories();
                              ACWorkspace.saveStringWorkspaces();
                            }
                            settingData.vibrate();
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
            backgroundColor: theme[settingData.selectedTheme]!.alertColor,
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
                          color: theme[settingData.selectedTheme]!.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Text(
                    "を追加しました!",
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
                      child: const Text("thank you!"))
                ],
              ),
            ),
          );
        });
  }

  static void showRenameCategoryDialog(
      {required BuildContext context,
      required bool isChainCategory,
      required int indexOfCategoryInCategories}) {
    final ACCategory _oldCategory = isChainCategory
        ? currentWorkspace.chainCategories[indexOfCategoryInCategories]
        : workspaceCategories[indexOfCategoryInCategories];
    // textFieldに改名する準備をする
    String? newCategoryName = _oldCategory.title;
    TextEditingController _controllerForRename =
        TextEditingController(text: _oldCategory.title);
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            backgroundColor: theme[settingData.selectedTheme]!.alertColor,
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
                    ButtonBar(
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
                                color: theme[settingData.selectedTheme]!
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
                              if (isChainCategory) {
                                // chain category
                                currentWorkspace
                                    .chainCategories[
                                        indexOfCategoryInCategories]
                                    .title = newCategoryName!;
                                selectChainWallKey.currentState
                                    ?.setState(() {});
                                ACCategory
                                    .saveChainCategoriesInCurrentWorkspace();
                              } else {
                                // workspace category
                                workspaceCategories[indexOfCategoryInCategories]
                                    .title = newCategoryName!;
                                ACCategory.saveWorkspaceCategories();
                                manageWorkspacePageKey.currentState
                                    ?.setState(() {});
                              }
                              settingData.vibrate();
                              Navigator.pop(context);
                              // thank you アラート
                              simpleAlert(
                                  context: context,
                                  title: "変更することに\n成功しました!",
                                  message: null,
                                  buttonText: "thank you!");
                            }
                          },
                          child: Text(
                            "完了",
                            style: TextStyle(
                                color: theme[settingData.selectedTheme]!
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
      required bool isChainCategory,
      required int indexOfCategoryInCategories}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: theme[settingData.selectedTheme]!.alertColor,
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
                      (isChainCategory
                                  ? currentWorkspace.chainCategories
                                  : workspaceCategories)[
                              indexOfCategoryInCategories]
                          .title,
                      style: TextStyle(
                          color: theme[settingData.selectedTheme]!.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  // ※カテゴリーに含まれる分析も削除されます
                  Text(
                    "※ カテゴリーに含まれる${isChainCategory ? "Chain" : "Workspace"}\n  も一緒に削除されます",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600),
                  ),
                  // はい、いいえボタン
                  ButtonBar(
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
                            if (isChainCategory) {
                              // categoriesから削除
                              final ACCategory removedCategory =
                                  currentWorkspace.chainCategories
                                      .removeAt(indexOfCategoryInCategories);
                              // savedChainsから削除
                              currentWorkspace.savedChains
                                  .remove(removedCategory.id);
                              // keepedChainsから削除
                              currentWorkspace.keepedChains
                                  .remove(removedCategory.id);
                              // このアラートを消して thank you アラートを表示する
                              selectChainWallKey.currentState?.setState(() {});
                              // セーブする
                              ACCategory
                                  .saveChainCategoriesInCurrentWorkspace();
                              ACChain.saveSavedChains();
                              ACChain.saveKeepedChains();
                            } else {
                              // workspace category
                              // 削除
                              final ACCategory removedCategory =
                                  workspaceCategories
                                      .removeAt(indexOfCategoryInCategories);
                              acWorkspaces.remove(removedCategory.id);
                              manageWorkspacePageKey.currentState
                                  ?.setState(() {});
                              // 保存
                              ACWorkspace.saveStringWorkspaces();
                              ACCategory.saveWorkspaceCategories();
                            }
                            settingData.vibrate();
                            simpleAlert(
                                context: context,
                                title: "削除することに\n成功しました!",
                                message: null,
                                buttonText: "thank you!");
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
    final decodedWorkspaceData = json.decode(acWorkspaces[ACWorkspace
        .currentWorkspaceCategoryId]![ACWorkspace.currentWorkspaceIndex]);
    decodedWorkspaceData["chainCategories"] = ACCategory.categoriesToString(
        categories: currentWorkspace.chainCategories);
    acWorkspaces[ACWorkspace.currentWorkspaceCategoryId]![
        ACWorkspace.currentWorkspaceIndex] = json.encode(decodedWorkspaceData);
    SharedPreferences.getInstance().then((pref) {
      pref.setString("stringWorkspaces", json.encode(acWorkspaces));
    });
  }

  static void saveWorkspaceCategories() {
    SharedPreferences.getInstance().then((pref) => pref.setString(
        "workspaceCategories",
        ACCategory.categoriesToString(categories: workspaceCategories)));
  }

  static void readWorkspaceCategories() {
    SharedPreferences.getInstance().then((pref) {
      if (pref.getString("workspaceCategories") != null) {
        workspaceCategories = ACCategory.stringToCategories(
            stringCategoriesData: pref.getString("workspaceCategories")!);
      }
    });
  }

  // --- save ---

  // --- json convert ---

  // List<Category> → String
  static String categoriesToString({required List<ACCategory> categories}) {
    final List<String> jsonCategoriesData = categories.map((category) {
      final Map<String, dynamic> willEncodedData = category.toJson();
      return json.encode(willEncodedData);
    }).toList();

    return json.encode(jsonCategoriesData);
  }

  // String → List<Category>
  static List<ACCategory> stringToCategories(
      {required String stringCategoriesData}) {
    final mapInstanceList = json.decode(stringCategoriesData).toList();

    var instanceList = mapInstanceList.map((stringCategoryData) {
      final decodedCategoryData = json.decode(stringCategoryData);
      return ACCategory.fromJson(decodedCategoryData);
    }).toList();

    return instanceList.cast<ACCategory>() as List<ACCategory>;
  }

  // --- json convert ---
}
