import 'package:action_chain/components/ui/action_chain_sliver_appbar.dart';
import 'package:action_chain/model/ac_todo/ac_category.dart';
import 'package:action_chain/model/ac_theme.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/view/chain_wall/chain_category_panel/chain_category_panel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:reorderables/reorderables.dart';

class SelectChainWall extends StatefulWidget {
  final bool isSavedChains;
  const SelectChainWall({required Key key, required this.isSavedChains})
      : super(key: key);

  @override
  State<SelectChainWall> createState() => _SelectChainWallState();
}

class _SelectChainWallState extends State<SelectChainWall> {
  @override
  Widget build(BuildContext context) {
    final ACThemeData _acThemeData = ACTheme.of(context);
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(color: _acThemeData.backgroundColor),
        ),
        CustomScrollView(
          slivers: [
            ActionChainSliverAppBar(
              titleFontSize: 18.3,
              titleSpacing: 0.5,
              pageTitle:
                  widget.isSavedChains ? "Saved Chains" : "Keeped Chains",
              leadingButtonOnPressed: () => Navigator.pop(context),
              leadingIcon: const Icon(
                Icons.close,
                size: 23,
                color: Colors.white,
              ),
              trailingButtonOnPressed: () =>
                  ACCategory.addCategoryAlert(context: context),
              trailingIcon: const Icon(
                FontAwesomeIcons.objectGroup,
                size: 23,
                color: Colors.white,
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 3, right: 3),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 1.5),
                    child: Column(
                      children: [
                        // カテゴリーごとのパネル
                        ReorderableColumn(
                            children: [
                              for (int indexOfCategory = 0;
                                  indexOfCategory <
                                      ACWorkspace.currentWorkspace
                                          .chainCategories.length;
                                  indexOfCategory++)
                                // なしで中身がなかったら非表示
                                if (!(indexOfCategory == 0 &&
                                    (widget.isSavedChains
                                            ? ACWorkspace
                                                .currentWorkspace.savedChains
                                            : ACWorkspace.currentWorkspace
                                                .keepedChains)[noneId]!
                                        .isEmpty))
                                  ChainCategoryPanel(
                                    key: Key(UniqueKey().toString()),
                                    isSavedChain: widget.isSavedChains,
                                    indexOfCategory: indexOfCategory,
                                  )
                            ],
                            onReorder: ((oldIndex, newIndex) {
                              if (newIndex != 0) {
                                final ACCategory reorderedCategory = ACWorkspace
                                    .currentWorkspace.chainCategories
                                    .removeAt(oldIndex);
                                ACWorkspace.currentWorkspace.chainCategories
                                    .insert(newIndex, reorderedCategory);
                                setState(() {});
                                ACCategory
                                    .saveChainCategoriesInCurrentWorkspace();
                              }
                            })),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 250),
              ],
            ))
          ],
        ),
      ]),
    );
  }
}
