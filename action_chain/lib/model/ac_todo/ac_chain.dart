import 'package:action_chain/component/dialog/ac_single_option_dialog.dart';
import 'package:action_chain/component/dialog/ac_yes_no_dialog.dart';
import 'package:action_chain/model/ac_todo/ac_todo.dart';
import 'package:action_chain/model/ac_todo/ac_step.dart';
import 'package:action_chain/model/ac_workspace/ac_workspaces.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:flutter/material.dart';

class ACChain {
  String title;
  List<ACToDo> actodos;

  // コンストラクタ
  ACChain({required this.title, required this.actodos});

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "actodos": actodos.map((method) {
        return method.toJson();
      }).toList()
    };
  }

  ACChain.fromJson(Map<String, dynamic> jsonData)
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
      ACChain.saveActionChains(isSavedChains: true);
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
    ACYesNoDialog.show(
        context: context,
        title: "このAction Chainを\n${wantToConduct ? "実行" : "編集"}しますか？",
        message: null,
        yesAction: () {
          ACVibration.vibrate();
          // detail -> collection -> home
          Navigator.pop(context);
          ACWorkspace.runningActionChain =
              ACChain(title: chainName, actodos: actionMethods);
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
    required ACChain selectedChain,
    // キープでホームに戻った時に編集モードを解除する関数
    required Function()? releaseEditModeAction,
  }) {
    ACYesNoDialog.show(
        context: context,
        title: wantToKeep ? "キープしますか？" : "保存しますか？",
        message:
            "Action Chainを${wantToKeep ? "キープ" : "保存"}することで簡単に呼び出して使えるようになります",
        yesAction: () {
          Navigator.pop(context);
          ACVibration.vibrate();
          if (wantToKeep) {
            ACWorkspace.currentWorkspace.keepedChains[categoryId]!
                .add(selectedChain);
            releaseEditModeAction!();
            // ホームに戻る
            Navigator.pop(context);
            ACSingleOptionDialog.show(
                context: context, title: "キープすることに\n成功しました", message: null);
          } else {
            ACWorkspace.currentWorkspace.savedChains[categoryId]!.add(ACChain(
                title: selectedChain.title,
                actodos: ACToDo.getNewMethods(
                    selectedMethods: selectedChain.actodos)));

            ACSingleOptionDialog.show(
              context: context,
              title: "保村することに\n成功しました",
              message: null,
            );
            ACChain.saveActionChains(isSavedChains: true);
          }
        });
  }

  static void askToDeleteThisChain({
    required BuildContext context,
    required String categoryId,
    required int indexOfOldChain,
    required bool isSavedChain,
  }) {
    ACYesNoDialog.show(
        context: context,
        title: "このAction Chainを\n削除しますか？",
        message: null,
        yesAction: () {
          // alert -> detail -> collection
          Navigator.pop(context);
          Navigator.pop(context);
          if (isSavedChain) {
            ACWorkspace.currentWorkspace.savedChains[categoryId]!
                .removeAt(indexOfOldChain);
            ACChain.saveActionChains(isSavedChains: true);
          } else {
            ACWorkspace.currentWorkspace.keepedChains[categoryId]!
                .removeAt(indexOfOldChain);
            ACChain.saveActionChains(isSavedChains: false);
          }
          selectChainWallKey.currentState?.setState(() {});
          ACVibration.vibrate();
          ACSingleOptionDialog.show(
              context: context, title: "削除することに\n成功しました", message: null);
        });
  }

  static void saveActionChains({required bool isSavedChains}) {
    final currentACWorkspaceData =
        acWorkspaces[ACWorkspace.currentWorkspaceIndex];
    isSavedChains
        ? currentACWorkspaceData.savedChains
        : currentACWorkspaceData.keepedChains = (isSavedChains
            ? ACWorkspace.currentWorkspace.savedChains
            : ACWorkspace.currentWorkspace.keepedChains);
    acWorkspaces[ACWorkspace.currentWorkspaceIndex] = currentACWorkspaceData;
    ACWorkspace.saveACWorkspaces();
  }
}
