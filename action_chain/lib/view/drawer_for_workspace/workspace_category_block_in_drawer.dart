import 'package:action_chain/model/ac_workspace/ac_workspaces.dart';
import 'package:action_chain/view/drawer_for_workspace/workspace_card/change_workspace_card.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:flutter/material.dart';

import 'package:reorderables/reorderables.dart';

class WorkspaceCategoryBlockInDrawer extends StatefulWidget {
  final ACCategory workspaceCategory;
  const WorkspaceCategoryBlockInDrawer(
      {Key? key, required this.workspaceCategory})
      : super(key: key);

  @override
  State<WorkspaceCategoryBlockInDrawer> createState() =>
      _WorkspaceCategoryBlockInDrawerState();
}

class _WorkspaceCategoryBlockInDrawerState
    extends State<WorkspaceCategoryBlockInDrawer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // header
        if (widget.workspaceCategory.id != noneId &&
            acWorkspaces[widget.workspaceCategory.id]!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(widget.workspaceCategory.title,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ),
        ReorderableColumn(
            children: [
              for (int index = 0;
                  index < acWorkspaces[widget.workspaceCategory.id]!.length;
                  index++)
                ChangeWorkspaceCard(
                    key: Key(UniqueKey().toString()),
                    isInList: true,
                    stringWorkspace:
                        acWorkspaces[widget.workspaceCategory.id]![index],
                    workspaceCategoryId: widget.workspaceCategory.id,
                    indexInStringWorkspaces: index),
            ],
            onReorder: (oldIndex, newIndex) {
              final List<dynamic> stringWorkspaceList =
                  acWorkspaces[widget.workspaceCategory.id]!;
              final String reorderedWorkspace =
                  stringWorkspaceList.removeAt(oldIndex);
              stringWorkspaceList.insert(newIndex, reorderedWorkspace);
              // current workspaceを移動した場合
              if (widget.workspaceCategory.id ==
                      ACWorkspace.currentWorkspaceCategoryId &&
                  oldIndex == ACWorkspace.currentWorkspaceIndex) {
                currentWorkspace.changeCurrentWorkspace(
                    selectedWorkspaceCategoryId: widget.workspaceCategory.id,
                    newWorkspaceIndex: newIndex);
              } else if (widget.workspaceCategory.id ==
                      ACWorkspace.currentWorkspaceCategoryId &&
                  newIndex == ACWorkspace.currentWorkspaceIndex) {
                currentWorkspace.changeCurrentWorkspace(
                    selectedWorkspaceCategoryId: widget.workspaceCategory.id,
                    newWorkspaceIndex:
                        ACWorkspace.currentWorkspaceIndex > oldIndex
                            ? newIndex - 1
                            : newIndex + 1);
              }
              setState(() {});
              ACWorkspace.saveStringWorkspaces();
            }),
      ],
    );
  }
}
