import 'package:action_chain/alerts/yes_no_alert.dart';
import 'package:action_chain/alerts/simple_alert.dart';
import 'package:action_chain/model/ac_todo/ac_todo.dart';
import 'package:action_chain/model/ac_todo/ac_step.dart';
import 'package:action_chain/model/ac_workspace/ac_workspaces.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:flutter/material.dart';

class ActionChain {
  String title;
  List<ACToDo> actodos;

  // コンストラクタ
  ActionChain({required this.title, required this.actodos});

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "actodos": actodos.map((method) {
        return method.toJson();
      }).toList()
    };
  }

  ActionChain.fromJson(Map<String, dynamic> jsonData)
      : title = jsonData["title"],
        actodos = (jsonData["actodos"] as List<dynamic>).map((jsonAcToDoData) {
          return ACToDo.fromJson(jsonAcToDoData);
        }).toList();

  void uncheckAllActionMethods() {
    bool isConducted = false;
    for (ACToDo actionMethod in actodos) {
      if (actionMethod.isChecked) {
        isConducted = true;
        actionMethod.isChecked = false;
      }
      for (ACStep step in actionMethod.steps) {
        if (step.isChecked) {
          isConducted = true;
          step.isChecked = false;
        }
      }
    }
    if (isConducted) {
      ActionChain.saveActionChains(isSavedChains: true);
    }
  }

  static void askTojumpToHomePageToUseThisChain({
    required BuildContext context,
    required String chainName,
    required List<ACToDo> actionMethods,
    required String? selectedCategoryId,
    required String? oldCategoryId,
    required bool wantToConduct,
    required int indexOfChain,
    required Function() removeKeepedChainAction,
  }) async {
    yesNoAlert(
        context: context,
        title: wantToConduct
            ? "このAction Chainを\n実行しますか？"
            : "このAction Chainを\n編集しますか？",
        message: null,
        yesAction: () {
          Navigator.pop(context);
          ACVibration.vibrate();
          // detail -> collection -> home
          Navigator.pop(context);
          ACWorkspace.currentChain =
              ActionChain(title: chainName, actodos: actionMethods);
          removeKeepedChainAction();
          Future<void>.delayed(const Duration(milliseconds: 100))
              .then((value) => Navigator.pop(context, <String, dynamic>{
                    "selectedCategoryId": selectedCategoryId,
                    "oldCategoryId": oldCategoryId,
                    "indexOfChain": indexOfChain,
                    "wantToConduct": wantToConduct,
                  }));
        });
  }

  static void askToSaveChain({
    required BuildContext context,
    required bool wantToKeep,
    required String categoryId,
    required ActionChain selectedChain,
    // キープでホームに戻った時に編集モードを解除する関数
    required Function()? releaseEditModeAction,
  }) {
    yesNoAlert(
        context: context,
        title: wantToKeep ? "キープしますか？" : "保存しますか？",
        message:
            "Action Chainを${wantToKeep ? "キープ" : "保存"}することで簡単に呼び出して使えるようになります",
        yesAction: () {
          Navigator.pop(context);
          ACVibration.vibrate();
          if (wantToKeep) {
            currentWorkspace.keepedChains[categoryId]!.add(selectedChain);
            releaseEditModeAction!();
            // ホームに戻る
            Navigator.pop(context);
            simpleAlert(
                context: context,
                title: "キープすることに\n成功しました",
                message: null,
                buttonText: "OK");
            ActionChain.saveActionChains(isSavedChains: false);
          } else {
            currentWorkspace.savedChains[categoryId]!.add(ActionChain(
                title: selectedChain.title,
                actodos: ACToDo.getNewMethods(
                    selectedMethods: selectedChain.actodos)));
            simpleAlert(
                context: context,
                title: "保村することに\n成功しました",
                message: null,
                buttonText: "OK");
            ActionChain.saveActionChains(isSavedChains: true);
          }
        });
  }

  static void askToDeleteThisChain({
    required BuildContext context,
    required String categoryId,
    required int indexOfOldChain,
    required bool isSavedChain,
  }) {
    yesNoAlert(
        context: context,
        title: "このAction Chainを\n削除しますか？",
        message: null,
        yesAction: () {
          // alert -> detail -> collection
          Navigator.pop(context);
          Navigator.pop(context);
          if (isSavedChain) {
            currentWorkspace.savedChains[categoryId]!.removeAt(indexOfOldChain);
            ActionChain.saveActionChains(isSavedChains: true);
          } else {
            currentWorkspace.keepedChains[categoryId]!
                .removeAt(indexOfOldChain);
            ActionChain.saveActionChains(isSavedChains: false);
          }
          selectChainWallKey.currentState?.setState(() {});
          ACVibration.vibrate();
          simpleAlert(
              context: context,
              title: "削除することに\n成功しました",
              message: null,
              buttonText: "OK");
        });
  }

  static void saveActionChains({required bool isSavedChains}) {
    final currentACWorkspaceData = acWorkspaces[ACWorkspace
        .currentWorkspaceCategoryId]![ACWorkspace.currentWorkspaceIndex];
    currentACWorkspaceData[isSavedChains ? "savedChains" : "keepedChains"] =
        (isSavedChains
                ? currentWorkspace.savedChains
                : currentWorkspace.keepedChains)
            .map((chainName, actodos) {
      final mappedACToDos =
          actodos.map((actodoData) => actodoData.toJson()).toList();
      return MapEntry(chainName, mappedACToDos);
    });
    acWorkspaces[ACWorkspace.currentWorkspaceCategoryId]![
        ACWorkspace.currentWorkspaceIndex] = currentACWorkspaceData;
    ACWorkspace.saveStringWorkspaces();
  }
}
