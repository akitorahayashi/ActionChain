import 'package:action_chain/alerts/simple_alert.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/model/ac_todo/ac_todo.dart';
import 'package:action_chain/model/ac_workspace/edit_acworkspace_dialog.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:action_chain/model/ac_todo/ac_chain.dart';
import 'package:action_chain/model/ac_workspace/ac_workspaces.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

ACWorkspace currentWorkspace = ACWorkspace.fromJson(acWorkspaces[ACWorkspace
    .currentWorkspaceCategoryId]![ACWorkspace.currentWorkspaceIndex]);

List<ACCategory> workspaceCategories = [ACCategory(id: noneId, title: "なし")];

class ACWorkspace {
  // workspace
  static String currentWorkspaceCategoryId = noneId;
  static int currentWorkspaceIndex = 0;
  static ActionChain? currentChain;

  String name;
  List<ACCategory> chainCategories;
  Map<String, List<ActionChain>> savedChains;
  Map<String, List<ActionChain>> keepedChains;

  ACWorkspace(
      {required this.name,
      required this.chainCategories,
      required this.savedChains,
      required this.keepedChains});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "chainCategories":
          ACCategory.categoriesToJson(categoryArray: chainCategories),
      "savedChains": savedChains.map((chainName, actodos) {
        final mappedACToDos =
            actodos.map((actodoData) => actodoData.toJson()).toList();
        return MapEntry(chainName, mappedACToDos);
      }),
      "keepedChains": keepedChains.map((chainName, actodos) {
        final mappedACToDos =
            actodos.map((actodoData) => actodoData.toJson()).toList();
        return MapEntry(chainName, mappedACToDos);
      }),
    };
  }

  ACWorkspace.fromJson(Map<String, dynamic> jsonData)
      : name = jsonData["name"],
        chainCategories = ACCategory.jsonToCategories(
            jsonCategoriesData: jsonData["chainCategories"]),
        savedChains = jsonData["savedChains"].map((chainName, actodos) {
          final createdACToDos = actodos
              .map((jsonACToDoData) => ACToDo.fromJson(jsonACToDoData))
              .toList();
          return MapEntry(chainName, createdACToDos);
        }),
        keepedChains = jsonData["keepedChains"].map((chainName, actodos) {
          final createdACToDos = actodos
              .map((jsonACToDoData) => ACToDo.fromJson(jsonACToDoData))
              .toList();
          return MapEntry(chainName, createdACToDos);
        });

  static void addWorkspaceAlert({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const EditACWorkspaceDialog(
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
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: "workspaceに\n",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: newWorkspaceName,
                          style: TextStyle(
                            color:
                                theme[settingData.selectedTheme]!.accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: "\nを追加しました!",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
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
          return EditACWorkspaceDialog(
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
        acWorkspaces[selectedWorkspaceCategoryId]![indexInStringWorkspaces]));
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
                              acWorkspaces[selectedWorkspaceCategoryId]!
                                  .removeAt(indexInStringWorkspaces);
                              drawerForWorkspaceKey.currentState
                                  ?.setState(() {});
                              manageWorkspacePageKey.currentState
                                  ?.setState(() {});
                              // このアラートを消して thank you アラートを表示する
                              Navigator.pop(context);
                              ACVibration.vibrate();
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
    currentWorkspace = ACWorkspace.fromJson(json
        .decode(acWorkspaces[selectedWorkspaceCategoryId]![newWorkspaceIndex]));
    SharedPreferences.getInstance().then((pref) {
      pref.setString(
          "currentWorkspaceCategoryId", ACWorkspace.currentWorkspaceCategoryId);
      pref.setInt("currentWorkspaceIndex", ACWorkspace.currentWorkspaceIndex);
    });
  }

  // --- save ---
  static void readWorkspaces() async {
    SharedPreferences.getInstance().then((pref) {
      ACWorkspace.currentWorkspaceCategoryId =
          pref.getString("currentWorkspaceCategoryId") ?? noneId;
      ACWorkspace.currentWorkspaceIndex =
          pref.getInt("currentWorkspaceIndex") ?? 0;
      if (pref.getString("acWorkspaces") != null) {
        acWorkspaces = json.decode(pref.getString("acWorkspaces")!);
      }
      if (pref.getString("currentChain") != null) {
        ACWorkspace.currentChain =
            ActionChain.fromJson(json.decode(pref.getString("currentChain")!));
      }
    });
  }

  static void saveCurrentChain() =>
      SharedPreferences.getInstance().then((value) => value.setString(
          "currentChain", json.encode(ACWorkspace.currentChain)));

  static void saveStringWorkspaces() async {
    SharedPreferences.getInstance().then(
        (pref) => pref.setString("acWorkspaces", json.encode(acWorkspaces)));
  }

  static void saveCurrentWorkspace(
      {required String selectedWorkspaceCategoryId,
      required int selectedWorkspaceIndex,
      required ACWorkspace selectedWorkspace}) {
    acWorkspaces[selectedWorkspaceCategoryId]![selectedWorkspaceIndex] =
        json.encode(currentWorkspace.toJson());
    ACWorkspace.saveStringWorkspaces();
  }
  // --- save ---
}
