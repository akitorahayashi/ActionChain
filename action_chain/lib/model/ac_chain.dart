import 'package:action_chain/alerts/yes_no_alert.dart';
import 'package:action_chain/alerts/simple_alert.dart';
import 'package:action_chain/model/ac_todo/ac_todo.dart';
import 'package:action_chain/model/ac_todo/ac_step.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/workspace/ac_workspace.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ACChain {
  String title;
  List<ACToDo> methods;

  // コンストラクタ
  ACChain({required this.title, required this.methods});

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "methods": ACToDo.actodoArrayToJson(actodoArray: methods),
    };
  }

  ACChain.fromJson(Map<String, dynamic> jsonData)
      : title = jsonData["title"],
        methods = ACToDo.stringToMethods(jsonMethodsData: jsonData["methods"]);

  void uncheckAllActionMethods() {
    bool isConducted = false;
    for (ACToDo actionMethod in methods) {
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
      ACChain.saveSavedChains();
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
          settingData.vibrate();
          // detail -> collection -> home
          Navigator.pop(context);
          ACWorkspace.currentChain =
              ACChain(title: chainName, methods: actionMethods);
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
    yesNoAlert(
        context: context,
        title: wantToKeep ? "キープしますか？" : "保存しますか？",
        message:
            "Action Chainを${wantToKeep ? "キープ" : "保存"}することで簡単に呼び出して使えるようになります",
        yesAction: () {
          Navigator.pop(context);
          settingData.vibrate();
          if (wantToKeep) {
            currentWorkspace.keepedChains[categoryId]!.add(selectedChain);
            releaseEditModeAction!();
            // ホームに戻る
            Navigator.pop(context);
            simpleAlert(
                context: context,
                title: "キープすることに\n成功しました！",
                message: null,
                buttonText: "thank you!");
            ACChain.saveKeepedChains();
          } else {
            currentWorkspace.savedChains[categoryId]!.add(ACChain(
                title: selectedChain.title,
                methods: ACToDo.getNewMethods(
                    selectedMethods: selectedChain.methods)));
            simpleAlert(
                context: context,
                title: "保村することに\n成功しました！",
                message: null,
                buttonText: "thank you!");
            ACChain.saveSavedChains();
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
            ACChain.saveSavedChains();
          } else {
            currentWorkspace.keepedChains[categoryId]!
                .removeAt(indexOfOldChain);
            ACChain.saveKeepedChains();
          }
          selectChainWallKey.currentState?.setState(() {});
          settingData.vibrate();
          simpleAlert(
              context: context,
              title: "削除することに\n成功しました!",
              message: null,
              buttonText: "thank you!");
        });
  }

  // --- save ---
  static void saveSavedChains() {
    final decodedWorkspaceData = json.decode(stringWorkspaces[ACWorkspace
        .currentWorkspaceCategoryId]![ACWorkspace.currentWorkspaceIndex]);
    decodedWorkspaceData["savedChains"] =
        ACChain.chainsToString(chains: currentWorkspace.savedChains);
    stringWorkspaces[ACWorkspace.currentWorkspaceCategoryId]![
        ACWorkspace.currentWorkspaceIndex] = json.encode(decodedWorkspaceData);
    ACWorkspace.saveStringWorkspaces();
  }

  static void saveKeepedChains() {
    final decodedWorkspaceData = json.decode(stringWorkspaces[ACWorkspace
        .currentWorkspaceCategoryId]![ACWorkspace.currentWorkspaceIndex]);
    decodedWorkspaceData["keepedChains"] =
        ACChain.chainsToString(chains: currentWorkspace.keepedChains);
    stringWorkspaces[ACWorkspace.currentWorkspaceCategoryId]![
        ACWorkspace.currentWorkspaceIndex] = json.encode(decodedWorkspaceData);
    ACWorkspace.saveStringWorkspaces();
  }
  // --- save ---

  // --- json convert ---

  static String chainsToString({required Map<String, List<ACChain>> chains}) {
    final categoryNames = chains.keys;
    Map<String, String> willEncodedMap = {};

    for (String category in categoryNames) {
      final List<String> jsonChainsListData = chains[category]!.map((chain) {
        final Map<String, dynamic> willEncodedMapOfToDo = chain.toJson();
        return json.encode(willEncodedMapOfToDo);
      }).toList();

      final String encodedList = json.encode(jsonChainsListData);

      willEncodedMap[category] = encodedList;
    }

    return json.encode(willEncodedMap);
  }

  static Map<String, List<ACChain>> stringToChains(
      {required String stringChainsData}) {
    Map<String, List<ACChain>> shouldBeReturnedMap = {};
    Map<String, String> shouldDecodedChainsMap = json
        .decode(stringChainsData)
        .cast<String, String>() as Map<String, String>;
    final categories = shouldDecodedChainsMap.keys;

    for (String category in categories) {
      final stringArrayOfChains =
          json.decode(shouldDecodedChainsMap[category]!).toList();

      final chainArray = stringArrayOfChains.map((chain) {
        final decodedChainData = json.decode(chain);
        return ACChain.fromJson(decodedChainData);
      }).toList();

      shouldBeReturnedMap[category] =
          chainArray.cast<ACChain>() as List<ACChain>;
    }

    return shouldBeReturnedMap;
  }

// --- json convert ---
}
