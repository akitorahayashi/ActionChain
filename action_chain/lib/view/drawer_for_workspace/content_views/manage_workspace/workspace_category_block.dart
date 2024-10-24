import 'package:action_chain/alerts/simple_alert.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/model/ac_workspace/ac_workspaces.dart';
import 'package:action_chain/view/drawer_for_workspace/workspace_card/change_workspace_card.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:flutter/material.dart';

import 'package:reorderables/reorderables.dart';

class WorkspaceCategoryBlock extends StatelessWidget {
  final int indexOfWorkspaceCategory;
  const WorkspaceCategoryBlock(
      {Key? key, required this.indexOfWorkspaceCategory})
      : super(key: key);

  ACCategory get workspaceCategory =>
      workspaceCategories[indexOfWorkspaceCategory];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: indexOfWorkspaceCategory != 0 ? null : () {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.5),
          child: Column(
            children: [
              // header
              if (indexOfWorkspaceCategory != 0)
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0,
                      bottom: acWorkspaces[workspaceCategory.id]!.isNotEmpty
                          ? 5.0
                          : 12),
                  child: Row(
                    children: [
                      // workspace カテゴリー削除ボタン
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 0),
                        child: GestureDetector(
                          onTap: () {
                            if (ACWorkspace.currentWorkspaceCategoryId !=
                                workspaceCategories[indexOfWorkspaceCategory]
                                    .id) {
                              ACCategory.confirmToDeleteThisCategory(
                                  context: context,
                                  isChainCategory: false,
                                  indexOfCategoryInCategories:
                                      indexOfWorkspaceCategory);
                            } else {
                              simpleAlert(
                                  context: context,
                                  title: "エラー",
                                  message:
                                      "このカテゴリーを削除するためにはcurrent workspaceを変更する必要があります",
                                  buttonText: "OK");
                            }
                          },
                          child: const Icon(
                            Icons.remove,
                            color: Colors.black45,
                            size: 25,
                          ),
                        ),
                      ),
                      // workspace category name
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            workspaceCategory.title,
                            style: const TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      // workspace カテゴリー編集ボタン
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0, left: 0),
                        child: GestureDetector(
                          onTap: () {
                            ACCategory.showRenameCategoryDialog(
                                context: context,
                                isChainCategory: false,
                                indexOfCategoryInCategories:
                                    indexOfWorkspaceCategory);
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black45,
                            size: 23,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ReorderableColumn(
                  children: [
                    // body
                    for (int indexInStringWorkspaces = 0;
                        indexInStringWorkspaces <
                            acWorkspaces[workspaceCategory.id]!.length;
                        indexInStringWorkspaces++)
                      ChangeWorkspaceCard(
                          key: Key(UniqueKey().toString()),
                          isInList: true,
                          acWorkspace: acWorkspaces[workspaceCategory.id]![
                              indexInStringWorkspaces],
                          workspaceCategoryId: workspaceCategory.id,
                          indexInStringWorkspaces: indexInStringWorkspaces)
                  ],
                  onReorder: (oldIndex, newIndex) {
                    final List<dynamic> stringWorkspaceList =
                        acWorkspaces[workspaceCategory.id]!;
                    final String reorderedWorkspace =
                        stringWorkspaceList.removeAt(oldIndex);
                    stringWorkspaceList.insert(newIndex, reorderedWorkspace);
                    // current workspaceを移動した場合
                    if (workspaceCategory.id ==
                            ACWorkspace.currentWorkspaceCategoryId &&
                        oldIndex == ACWorkspace.currentWorkspaceIndex) {
                      currentWorkspace.changeCurrentWorkspace(
                          selectedWorkspaceCategoryId: workspaceCategory.id,
                          newWorkspaceIndex: newIndex);
                    } else if (workspaceCategory.id ==
                            ACWorkspace.currentWorkspaceCategoryId &&
                        newIndex == ACWorkspace.currentWorkspaceIndex) {
                      currentWorkspace.changeCurrentWorkspace(
                          selectedWorkspaceCategoryId: workspaceCategory.id,
                          newWorkspaceIndex:
                              ACWorkspace.currentWorkspaceIndex > oldIndex
                                  ? newIndex - 1
                                  : newIndex + 1);
                    }
                    manageWorkspacePageKey.currentState?.setState(() {});
                    ACWorkspace.saveStringWorkspaces();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
