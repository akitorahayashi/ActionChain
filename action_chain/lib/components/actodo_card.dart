import 'package:action_chain/constants/icons_for_checkbox.dart';
import 'package:action_chain/functions/notify_method_or_step_is_edited.dart';
import 'package:action_chain/model/ac_todo/ac_chain.dart';
import 'package:action_chain/model/ac_todo/ac_step.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_todo/ac_todo.dart';
import 'package:action_chain/model/ac_theme.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:flutter/material.dart';

import 'package:reorderables/reorderables.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

bool hasShowCelebrate = false;

class ACToDoCard extends StatefulWidget {
  final GlobalKey superKey;
  final bool isCurrentChain;
  final bool isInKeepedChain;
  final bool disableTapGesture;
  final bool disableSliderable;
  // action method
  final List<ACToDo> actionMethods;
  final int indexOfThisActionMethod;
  final ACToDo actionMethodData;
  final Function()? editAction;

  const ACToDoCard({
    Key? key,
    required this.superKey,
    required this.isCurrentChain,
    required this.isInKeepedChain,
    required this.disableTapGesture,
    required this.disableSliderable,
    // action method
    required this.actionMethods,
    required this.indexOfThisActionMethod,
    required this.actionMethodData,
    required this.editAction,
  }) : super(key: key);

  @override
  _ACToDoCardState createState() => _ACToDoCardState();
}

class _ACToDoCardState extends State<ACToDoCard> {
  // todoのチェックを切り替える処理
  void _toggleActionMethodCheckBox() {
    // チェックの状態が変わったtodoの位置を変える関数

    // チェックの状態を切り替える
    widget.actionMethodData.isChecked = !widget.actionMethodData.isChecked;
    // stepsがあるならその全てのstepsのcheck状態を同じにする
    for (ACStep step in widget.actionMethodData.steps) {
      step.isChecked = widget.actionMethodData.isChecked;
    }
    // チェックが切り替わったことをsnackbarで知らせる
    notifyActionMethodOrStepIsEditted(
        context: context,
        title: widget.actionMethodData.title,
        isChecked: widget.actionMethodData.isChecked);
    ACVibration.vibrate();
    widget.superKey.currentState?.setState(() {});
    if (widget.isCurrentChain) {
      ACWorkspace.saveCurrentChain();
    } else if (widget.isInKeepedChain) {
      ActionChain.saveActionChains(isSavedChains: false);
    }
  }

  // stepのチェックを切り替える処理
  void _toggleStepCheckBox({required ACStep stepData}) {
    // 主要のactionMethodがチェックされているときはチェック状態から変えたらそっちもかえる
    if (widget.actionMethodData.isChecked) {
      stepData.isChecked = !stepData.isChecked;
      widget.actionMethodData.isChecked = false;
    } else {
      // それ以外は単に切り替える
      stepData.isChecked = !stepData.isChecked;
    }
    // stepが全てチェックされたら主要なほうもチェックする
    if (() {
      for (ACStep step in widget.actionMethodData.steps) {
        if (!step.isChecked) {
          return false;
        }
      }
      return true;
    }()) {
      widget.actionMethodData.isChecked = true;
    }
    // チェックが切り替わったことをsnackbarで知らせる
    notifyActionMethodOrStepIsEditted(
      context: context,
      title: stepData.title,
      isChecked: stepData.isChecked,
    );
    // バイブレーション
    ACVibration.vibrate();
    widget.superKey.currentState?.setState(() {});
    if (widget.isCurrentChain) {
      ACWorkspace.saveCurrentChain();
    } else if (widget.isInKeepedChain) {
      ActionChain.saveActionChains(isSavedChains: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 全体を囲むカード
    return GestureDetector(
      onTap:
          widget.disableTapGesture ? null : () => _toggleActionMethodCheckBox(),
      onLongPress: widget.actionMethodData.isChecked ? () {} : null,
      child: Card(
        color:
            acThemeDataList[SettingData.shared.selectedThemeIndex].panelColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Slidable(
          enabled: !widget.actionMethodData.isChecked,
          startActionPane: widget.disableSliderable
              ? null
              : ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.118,
                  children: [
                      // editAction
                      SlidableAction(
                        // タップしたらクローズ
                        autoClose: true,
                        backgroundColor: acThemeDataList[
                                SettingData.shared.selectedThemeIndex]
                            .panelColor,
                        foregroundColor: acThemeDataList[
                                SettingData.shared.selectedThemeIndex]
                            .accentColor,
                        onPressed: (BuildContext context) async {
                          // タップしたらこれをremoveする
                          widget.actionMethods
                              .removeAt(widget.indexOfThisActionMethod);
                          ACVibration.vibrate();
                          widget.superKey.currentState?.setState(() {});
                        },
                        icon: Icons.remove,
                      ),
                    ]),
          endActionPane: widget.disableSliderable
              ? null
              : ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.33,
                  children: [
                    SlidableAction(
                      autoClose: true,
                      flex: 10,
                      spacing: 8,
                      backgroundColor:
                          acThemeDataList[SettingData.shared.selectedThemeIndex]
                              .panelColor,
                      foregroundColor:
                          acThemeDataList[SettingData.shared.selectedThemeIndex]
                              .accentColor,
                      onPressed: (BuildContext context) => widget.editAction!(),
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 18, 16,
                      widget.actionMethodData.steps.isNotEmpty ? 15 : 18),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // 左側のチェックボックス
                      Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 16, 0),
                          // const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          child: Transform.scale(
                            scale: 1.2,
                            child: getIcon(
                                isChecked: widget.actionMethodData.isChecked),
                          )),
                      // toDoのタイトル
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.actionMethodData.title,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(
                                    widget.actionMethodData.isChecked
                                        ? 0.3
                                        : 0.6)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // steps
                if (widget.actionMethodData.steps.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: PrimaryScrollController(
                      controller: ScrollController(),
                      child: ReorderableColumn(
                        children: widget.actionMethodData.steps.map((stepData) {
                          return Padding(
                            key: Key(UniqueKey().toString()),
                            padding: const EdgeInsets.fromLTRB(8, 0, 2, 0),
                            child: GestureDetector(
                              onTap: widget.disableTapGesture
                                  ? null
                                  : () =>
                                      _toggleStepCheckBox(stepData: stepData),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                  child: Row(
                                    children: [
                                      // 左側のチェックボックス
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 0, 16, 0),
                                        child: Transform.scale(
                                          scale: 1.2,
                                          child: getIcon(
                                              isChecked: stepData.isChecked),
                                        ),
                                      ),
                                      // stepのタイトル
                                      Expanded(
                                        child: Text(stepData.title,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black.withOpacity(
                                                    stepData.isChecked
                                                        ? 0.3
                                                        : 0.6))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onReorder: (oldIndex, newIndex) {
                          final reOrderedToDo =
                              widget.actionMethodData.steps[oldIndex];
                          widget.actionMethodData.steps.remove(reOrderedToDo);
                          widget.actionMethodData.steps
                              .insert(newIndex, reOrderedToDo);
                          setState(() {});
                        },
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
