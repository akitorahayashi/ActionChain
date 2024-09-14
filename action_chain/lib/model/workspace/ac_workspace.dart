import 'package:action_chain/alerts/simple_alert.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/model/workspace/edit_workspace_dialog.dart';
import 'package:action_chain/model/ac_todo/ac_todo.dart';
import 'package:action_chain/model/ac_todo/ac_step.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:action_chain/model/ac_chain.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

ACWorkspace currentWorkspace = ACWorkspace.fromJson(json.decode(
    stringWorkspaces[ACWorkspace.currentWorkspaceCategoryId]![
        ACWorkspace.currentWorkspaceIndex]));

List<ACCategory> workspaceCategories = [ACCategory(id: noneId, title: "なし")];

Map<String, List<String>> stringWorkspaces = {
  noneId: [
    json.encode(ACWorkspace(name: "デフォルト", chainCategories: [
      ACCategory(id: noneId, title: "なし")
    ], savedChains: {
      noneId: [
        ACChain(title: "帰ってからやること", methods: [
          ACToDo(title: "ご飯を炊く", steps: []),
          ACToDo(title: "運動する", steps: [
            ACStep(title: "水筒"),
            ACStep(title: "スマホ"),
            ACStep(title: "カギ"),
          ]),
          ACToDo(title: "お風呂に入る", steps: [
            ACStep(title: "タオルを忘れるな！"),
          ]),
          ACToDo(title: "夕食", steps: []),
          ACToDo(title: "~について勉強する", steps: []),
          ACToDo(title: "明日の計画を立てる", steps: []),
        ]),
      ]
    }, keepedChains: {
      noneId: [
        ACChain(title: "明日の持ち物", methods: [
          ACToDo(
              title: "筆記用具",
              steps: [ACStep(title: "メモ帳"), ACStep(title: "ペン")]),
          ACToDo(title: "水筒", steps: []),
          ACToDo(title: "お弁当", steps: []),
        ]),
      ]
    }).toJson())
  ]
};

class ACWorkspace {
  // workspace
  static String currentWorkspaceCategoryId = noneId;
  static int currentWorkspaceIndex = 0;
  static ACChain? currentChain;

  String name;
  // effort
  int numberOfCompletedTasksInThisWorkspace = 0;
  int numberOfCompletionPerThirty = 0;
  List<ACCategory> chainCategories;
  Map<String, List<ACChain>> savedChains;
  Map<String, List<ACChain>> keepedChains;

  ACWorkspace(
      {required this.name,
      required this.chainCategories,
      required this.savedChains,
      required this.keepedChains});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "numberOfCompletedTasksInThisWorkspace":
          numberOfCompletedTasksInThisWorkspace,
      "chainCategories":
          ACCategory.categoriesToString(categories: chainCategories),
      "savedChains": ACChain.chainsToString(chains: savedChains),
      "keepedChains": ACChain.chainsToString(chains: keepedChains),
    };
  }

  ACWorkspace.fromJson(Map<String, dynamic> jsonData)
      : name = jsonData["name"],
        numberOfCompletedTasksInThisWorkspace =
            jsonData["numberOfCompletedTasksInThisWorkspace"] ??
                jsonData["numberOfCompletedChainInThisWorkspace"] ??
                0,
        chainCategories = ACCategory.stringToCategories(
            stringCategoriesData: jsonData["chainCategories"]),
        savedChains =
            ACChain.stringToChains(stringChainsData: jsonData["savedChains"]),
        keepedChains =
            ACChain.stringToChains(stringChainsData: jsonData["keepedChains"]);

  static void addWorkspaceAlert({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const EditWorkspaceDialog(
              oldWorkspaceCategoryId: null, oldWorkspaceIndex: null);
        });
  }

  static void notifyWorkspaceIsAdded(
      {required BuildContext context, required String newWorkspaceName}) {
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
                    padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                    child: Text(
                      "workspaceに",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      newWorkspaceName,
                      style: TextStyle(
                          color: theme[settingData.selectedTheme]!.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Text(
                    "を追加しました!",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
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

  static void editWorkspaceAlert(
      {required BuildContext context,
      required String selectedWorkspaceCategoryId,
      required int selectedWorkspaceIndex}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return EditWorkspaceDialog(
              oldWorkspaceCategoryId: selectedWorkspaceCategoryId,
              oldWorkspaceIndex: selectedWorkspaceIndex);
        });
  }

  static void deleteWorkspaceAlert({
    required BuildContext context,
    required String selectedWorkspaceCategoryId,
    required int indexInStringWorkspaces,
  }) {
    final ACWorkspace willDeletedWorkspace = ACWorkspace.fromJson(json.decode(
        stringWorkspaces[selectedWorkspaceCategoryId]![
            indexInStringWorkspaces]));
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
                  // workspaceの削除
                  Text(
                    "workspaceの削除",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  // workspaceを表示
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 15.0, left: 10, right: 10),
                    child: Text(
                      willDeletedWorkspace.name,
                      style: TextStyle(
                          color: theme[settingData.selectedTheme]!.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Text(
                    "※ workspaceに含まれる\n  Chainも削除されます",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
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
                            // stringWorkspacesから削除
                            SharedPreferences.getInstance().then((pref) {
                              if (ACWorkspace.currentWorkspaceCategoryId ==
                                      selectedWorkspaceCategoryId &&
                                  ACWorkspace.currentWorkspaceIndex >
                                      indexInStringWorkspaces) {
                                ACWorkspace.currentWorkspaceIndex--;
                                pref.setInt("currentWorkspaceIndex",
                                    ACWorkspace.currentWorkspaceIndex);
                              }
                              stringWorkspaces[selectedWorkspaceCategoryId]!
                                  .removeAt(indexInStringWorkspaces);
                              drawerForWorkspaceKey.currentState
                                  ?.setState(() {});
                              manageWorkspacePageKey.currentState
                                  ?.setState(() {});
                              // このアラートを消して thank you アラートを表示する
                              Navigator.pop(context);
                              settingData.vibrate();
                              simpleAlert(
                                  context: context,
                                  title: "削除することに\n成功しました!",
                                  message: null,
                                  buttonText: "thank you!");
                              // セーブする
                              ACWorkspace.saveStringWorkspaces();
                            });
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

  void changeCurrentWorkspace(
      {required String selectedWorkspaceCategoryId,
      required int newWorkspaceIndex}) {
    ACWorkspace.currentWorkspaceCategoryId = selectedWorkspaceCategoryId;
    ACWorkspace.currentWorkspaceIndex = newWorkspaceIndex;
    currentWorkspace = ACWorkspace.fromJson(json.decode(
        stringWorkspaces[selectedWorkspaceCategoryId]![newWorkspaceIndex]));
    SharedPreferences.getInstance().then((pref) {
      pref.setString(
          "currentWorkspaceCategoryId", ACWorkspace.currentWorkspaceCategoryId);
      pref.setInt("currentWorkspaceIndex", ACWorkspace.currentWorkspaceIndex);
    });
  }

  // --- save ---
  static void readWorkspaces() async {
    SharedPreferences.getInstance().then((pref) {
      ACChain.numberOfComplitedActionMethods =
          pref.getInt("numberOfExecutions") ??
              pref.getInt("numberOfComplitedActionMethods") ??
              0;
      ACWorkspace.currentWorkspaceCategoryId =
          pref.getString("currentWorkspaceCategoryId") ?? noneId;
      ACWorkspace.currentWorkspaceIndex =
          pref.getInt("currentWorkspaceIndex") ?? 0;
      if (pref.getString("stringWorkspaces") != null) {
        stringWorkspaces = ACWorkspace.stringToStringWorkspaces(
            stringWorkspacesData: pref.getString("stringWorkspaces")!);
      }
      if (pref.getString("currentChain") != null) {
        ACWorkspace.currentChain =
            ACChain.fromJson(json.decode(pref.getString("currentChain")!));
      }
    });
  }

  static void saveCurrentChain() =>
      SharedPreferences.getInstance().then((value) => value.setString(
          "currentChain", json.encode(ACWorkspace.currentChain)));

  static void saveStringWorkspaces() async {
    SharedPreferences.getInstance().then((pref) => pref.setString(
        "stringWorkspaces",
        ACWorkspace.stringWorkspacesToString(
            stringWorkspaces: stringWorkspaces)));
  }

  static void saveCurrentWorkspace(
      {required String selectedWorkspaceCategoryId,
      required int selectedWorkspaceIndex,
      required ACWorkspace selectedWorkspace}) {
    stringWorkspaces[selectedWorkspaceCategoryId]![selectedWorkspaceIndex] =
        json.encode(currentWorkspace.toJson());
    ACWorkspace.saveStringWorkspaces();
  }
  // --- save ---

  // --- json convert ---

  static String stringWorkspacesToString(
      {required Map<String, List<dynamic>> stringWorkspaces}) {
    final workspaceCategoryIds = stringWorkspaces.keys.toList();
    Map<String, String> willEncodedMap = {};

    for (String workspaceCategoryId in workspaceCategoryIds) {
      final String encodedList =
          json.encode(stringWorkspaces[workspaceCategoryId]!);

      willEncodedMap[workspaceCategoryId] = encodedList;
    }

    return json.encode(willEncodedMap);
  }

  static Map<String, List<String>> stringToStringWorkspaces(
      {required String stringWorkspacesData}) {
    Map<String, List<String>> shouldBeReturnedMap = {};
    Map<String, String> shouldDecodedToDosMap = json
        .decode(stringWorkspacesData)
        .cast<String, String>() as Map<String, String>;
    final workspaceCategoryIds = shouldDecodedToDosMap.keys;

    for (String workspaceCategoryId in workspaceCategoryIds) {
      try {
        shouldBeReturnedMap[workspaceCategoryId] = json
            .decode(shouldDecodedToDosMap[workspaceCategoryId]!)
            .cast<String>() as List<String>;
      } catch (e) {
        print(e.toString());
      }
    }

    return shouldBeReturnedMap;
  }

  // --- json convert ---
}
