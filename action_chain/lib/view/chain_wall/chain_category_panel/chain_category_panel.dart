import 'package:action_chain/model/ac_theme.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/model/ac_todo/ac_chain.dart';
import 'package:action_chain/model/ac_todo/ac_category.dart';
import 'package:action_chain/view/chain_wall/chain_category_panel/chain_card.dart';
import 'package:flutter/material.dart';

import 'package:reorderables/reorderables.dart';

class ChainCategoryPanel extends StatefulWidget {
  final bool isSavedChain;
  final int indexOfCategory;
  const ChainCategoryPanel(
      {Key? key, required this.isSavedChain, required this.indexOfCategory})
      : super(key: key);

  @override
  State<ChainCategoryPanel> createState() => _ChainCategoryPanelState();
}

class _ChainCategoryPanelState extends State<ChainCategoryPanel> {
  ACCategory get categoryOfThisCard =>
      ACWorkspace.currentWorkspace.chainCategories[widget.indexOfCategory];
  @override
  Widget build(BuildContext context) {
    final ACThemeData _acThemeData = ACTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0, left: 3, right: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: DecoratedBox(
          decoration: BoxDecoration(
              border:
                  Border.all(color: _acThemeData.panelBorderColor, width: 20)),
          child: GestureDetector(
            onLongPress: ACWorkspace.currentWorkspace
                        .chainCategories[widget.indexOfCategory].id ==
                    noneId
                ? () {}
                : null,
            child: Card(
              color: _acThemeData.categoryPanelColorInCollection,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(3, 10, 3, 3),
                child: Column(
                  children: [
                    // カテゴリー名と削除、編集ボタン
                    if (categoryOfThisCard.id != noneId)
                      Padding(
                        padding: const EdgeInsets.only(top: 3, bottom: 8),
                        child: Row(
                          children: [
                            // カテゴリー削除ボタン
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 14.0, right: 16),
                              child: GestureDetector(
                                onTap: () {
                                  ACCategory.confirmToDeleteThisCategory(
                                      context: context,
                                      indexOfCategoryInCategories:
                                          widget.indexOfCategory);
                                },
                                child: Icon(
                                  Icons.remove,
                                  color: _acThemeData.accentColor,
                                  size: 19,
                                ),
                              ),
                            ),
                            // カテゴリー名
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  categoryOfThisCard.title,
                                  style: TextStyle(
                                      color: _acThemeData.accentColor,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            // カテゴリー編集ボタン
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 12.0, left: 12),
                              child: GestureDetector(
                                onTap: () {
                                  ACCategory.showRenameCategoryDialog(
                                      context: context,
                                      indexOfCategoryInCategories:
                                          widget.indexOfCategory);
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: _acThemeData.accentColor,
                                  size: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // chainsを表示する
                    ReorderableColumn(
                        children: [
                          for (int index = 0;
                              index <
                                  (widget.isSavedChain
                                              ? ACWorkspace
                                                  .currentWorkspace.savedChains
                                              : ACWorkspace.currentWorkspace
                                                  .keepedChains)[
                                          categoryOfThisCard.id]!
                                      .length;
                              index++)
                            ChainCard(
                              key: Key(UniqueKey().toString()),
                              isSavedChain: widget.isSavedChain,
                              categoryOfThisChain: ACWorkspace.currentWorkspace
                                  .chainCategories[widget.indexOfCategory],
                              indexOfThisChainInChains: index,
                              chainOfThisCard: (widget.isSavedChain
                                      ? ACWorkspace.currentWorkspace.savedChains
                                      : ACWorkspace
                                          .currentWorkspace.keepedChains)[
                                  categoryOfThisCard.id]![index],
                            )
                        ],
                        onReorder: ((oldIndex, newIndex) {
                          if (oldIndex != newIndex) {
                            final ACChain reorderedChain = (widget.isSavedChain
                                    ? ACWorkspace.currentWorkspace.savedChains
                                    : ACWorkspace.currentWorkspace
                                        .keepedChains)[categoryOfThisCard.id]!
                                .removeAt(oldIndex);
                            (widget.isSavedChain
                                    ? ACWorkspace.currentWorkspace.savedChains
                                    : ACWorkspace.currentWorkspace
                                        .keepedChains)[categoryOfThisCard.id]!
                                .insert(newIndex, reorderedChain);
                            setState(() {});
                            ACChain.saveActionChains(
                                isSavedChains: widget.isSavedChain);
                          }
                        }))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
