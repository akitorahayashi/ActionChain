import 'package:action_chain/alerts/yes_no_alert.dart';
import 'package:action_chain/components/actodo_card.dart';
import 'package:action_chain/components/ui/action_chain_sliver_appbar.dart';
import 'package:action_chain/components/ui/controll_icon_button.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_todo/ac_todo.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:action_chain/model/ac_todo/ac_chain.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reorderables/reorderables.dart';

class ChainDetailPage extends StatefulWidget {
  final bool isSavedChain;
  final ACCategory categoryOfThisChain;
  final int indexOfThisChainInChains;
  const ChainDetailPage({
    required Key key,
    required this.isSavedChain,
    required this.categoryOfThisChain,
    required this.indexOfThisChainInChains,
  }) : super(key: key);

  @override
  State<ChainDetailPage> createState() => _ChainDetailPageState();
}

class _ChainDetailPageState extends State<ChainDetailPage> {
  ActionChain get chainOfThisPage =>
      (widget.isSavedChain
              ? currentWorkspace.savedChains
              : currentWorkspace.keepedChains)[widget.categoryOfThisChain.id]
          ?[widget.indexOfThisChainInChains] ??
      ActionChain(title: "", actodos: []);

  bool get isComplited => (() {
        for (ACToDo method in chainOfThisPage.actodos) {
          if (!method.isChecked) {
            return false;
          }
        }
        return true;
      }());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: theme[settingData.selectedTheme]!.backgroundColor),
          ),
          CustomScrollView(
            slivers: [
              ActionChainSliverAppBar(
                  pageTitle: chainOfThisPage.title,
                  titleFontSize: 15,
                  titleSpacing: 0.5,
                  leadingButtonOnPressed: () => Navigator.pop(context),
                  leadingIcon: const Icon(
                    Icons.close,
                    size: 23,
                    color: Colors.white,
                  ),
                  trailingButtonOnPressed: () async {
                    Navigator.pop(context);
                    await Future<void>.delayed(
                            const Duration(milliseconds: 100))
                        .then((_) => Navigator.pop(context));
                  },
                  trailingIcon: const Icon(
                    FontAwesomeIcons.house,
                    size: 18,
                    color: Colors.white,
                  )),
              SliverList(
                  delegate: SliverChildListDelegate([
                // Action Chainの内容を表示する
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        // 削除、編集、実行ボタン
                        Padding(
                          padding: const EdgeInsets.only(top: 32.0, bottom: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 削除
                              ControllIconButton(
                                  onPressed: () =>
                                      ActionChain.askToDeleteThisChain(
                                        context: context,
                                        categoryId:
                                            widget.categoryOfThisChain.id,
                                        indexOfOldChain:
                                            widget.indexOfThisChainInChains,
                                        isSavedChain: widget.isSavedChain,
                                      ),
                                  iconData: Icons.clear,
                                  textContent: "削除"),
                              const SizedBox(width: 20),
                              // 編集
                              ControllIconButton(
                                  onPressed: () {
                                    ActionChain
                                        .askTojumpToHomePageToUseThisChain(
                                            context: context,
                                            chainName: chainOfThisPage.title,
                                            actionMethods:
                                                chainOfThisPage.actodos,
                                            indexOfChain:
                                                widget.indexOfThisChainInChains,
                                            selectedCategoryId:
                                                widget.categoryOfThisChain.id,
                                            oldCategoryId: widget.isSavedChain
                                                ? widget.categoryOfThisChain.id
                                                : null,
                                            wantToConduct: false,
                                            // keepedなら削除
                                            removeKeepedChainAction: () {
                                              if (!widget.isSavedChain) {
                                                currentWorkspace.keepedChains[
                                                        widget
                                                            .categoryOfThisChain
                                                            .id]!
                                                    .removeAt(widget
                                                        .indexOfThisChainInChains);
                                                ActionChain.saveActionChains(
                                                    isSavedChains: false);
                                              }
                                            });
                                  },
                                  iconData: Icons.edit,
                                  textContent: "編集"),
                              const SizedBox(width: 20),
                              // 実行と完了
                              AnimatedCrossFade(
                                duration: const Duration(milliseconds: 300),
                                crossFadeState: !isComplited
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                                // 実行ボタン
                                firstChild: ControllIconButton(
                                    onPressed: () {
                                      ActionChain
                                          .askTojumpToHomePageToUseThisChain(
                                              context: context,
                                              chainName: chainOfThisPage.title,
                                              actionMethods:
                                                  chainOfThisPage.actodos,
                                              selectedCategoryId:
                                                  widget.categoryOfThisChain.id,
                                              oldCategoryId: widget.isSavedChain
                                                  ? widget
                                                      .categoryOfThisChain.id
                                                  : null,
                                              indexOfChain: widget
                                                  .indexOfThisChainInChains,
                                              wantToConduct: true,
                                              // keepedなら削除
                                              removeKeepedChainAction: () {
                                                if (!widget.isSavedChain) {
                                                  currentWorkspace
                                                      .keepedChains[widget
                                                          .categoryOfThisChain
                                                          .id]!
                                                      .removeAt(widget
                                                          .indexOfThisChainInChains);
                                                  ActionChain.saveActionChains(
                                                      isSavedChains: false);
                                                }
                                              });
                                    },
                                    iconData: Icons.near_me,
                                    iconSize: 26,
                                    textContent: "実行"),
                                // 完了ボタン
                                secondChild: ControllIconButton(
                                  onPressed: () => yesNoAlert(
                                      context: context,
                                      title: "このAction Chainを\n完了しますか？",
                                      message: null,
                                      yesAction: () {
                                        Navigator.pop(context);
                                        // カウントする
                                        final int nummberOfActionMethods = (() {
                                          int counter = 0;
                                          for (ACToDo method
                                              in chainOfThisPage.actodos) {
                                            if (method.steps.isEmpty) {
                                              counter++;
                                            } else {
                                              counter += method.steps.length;
                                            }
                                          }
                                          return counter;
                                        }());
                                        // 更新して消す
                                        Navigator.pop(context);
                                        currentWorkspace.keepedChains[
                                                widget.categoryOfThisChain.id]!
                                            .removeAt(widget
                                                .indexOfThisChainInChains);
                                        selectChainWallKey.currentState
                                            ?.setState(() {});
                                        homePageKey.currentState
                                            ?.setState(() {});
                                        // アラート
                                        ACVibration.vibrate();
                                        // 保存
                                        ActionChain.saveActionChains(
                                            isSavedChains: false);
                                        ACWorkspace.saveCurrentWorkspace(
                                            selectedWorkspaceCategoryId:
                                                ACWorkspace
                                                    .currentWorkspaceCategoryId,
                                            selectedWorkspaceIndex: ACWorkspace
                                                .currentWorkspaceIndex,
                                            selectedWorkspace:
                                                currentWorkspace);
                                        ActionChain.saveActionChains(
                                            isSavedChains: true);
                                      }),
                                  iconData: Icons.done,
                                  textContent: "完了",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 3.0, bottom: 5.0),
                            child: ReorderableColumn(
                              children: [
                                for (int indexOfThisActionMethod = 0;
                                    indexOfThisActionMethod <
                                        chainOfThisPage.actodos.length;
                                    indexOfThisActionMethod++)
                                  ACToDoCard(
                                      key: Key(UniqueKey().toString()),
                                      superKey: chainDetailPageKey,
                                      isCurrentChain: false,
                                      isInKeepedChain: !widget.isSavedChain,
                                      disableSliderable: true,
                                      disableTapGesture: widget.isSavedChain,
                                      actionMethods: chainOfThisPage.actodos,
                                      indexOfThisActionMethod:
                                          indexOfThisActionMethod,
                                      actionMethodData: chainOfThisPage
                                          .actodos[indexOfThisActionMethod],
                                      editAction: null)
                              ],
                              onReorder: (oldIndex, newIndex) {
                                final ACToDo reorderedActionMethod =
                                    chainOfThisPage.actodos.removeAt(oldIndex);
                                chainOfThisPage.actodos
                                    .insert(newIndex, reorderedActionMethod);
                                setState(() {});
                                ActionChain.saveActionChains(
                                    isSavedChains: widget.isSavedChain);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 250),
              ]))
            ],
          ),
        ],
      ),
    );
  }
}
