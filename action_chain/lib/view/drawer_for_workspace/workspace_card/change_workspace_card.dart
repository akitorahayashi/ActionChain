import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/view/drawer_for_workspace/workspace_card/notify_current_workspace_is_changed.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_slidable/flutter_slidable.dart';

class ChangeWorkspaceCard extends StatelessWidget {
  final bool isInList;
  final String stringWorkspace;
  final String workspaceCategoryId;
  final int indexInStringWorkspaces;
  const ChangeWorkspaceCard(
      {Key? key,
      required this.isInList,
      required this.stringWorkspace,
      required this.workspaceCategoryId,
      required this.indexInStringWorkspaces})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          5,
          1,
          5,
          (workspaceCategoryId == ACWorkspace.currentWorkspaceCategoryId &&
                  indexInStringWorkspaces ==
                      ACWorkspace.currentWorkspaceIndex &&
                  !isInList)
              ? 5
              : 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 70),
        child: Card(
          color: theme[settingData.selectedTheme]!.panelColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              radius: 10,
              onTap: () async {
                if (workspaceCategoryId ==
                        ACWorkspace.currentWorkspaceCategoryId &&
                    indexInStringWorkspaces ==
                        ACWorkspace.currentWorkspaceIndex) {
                  Navigator.pop(context);
                } else {
                  currentWorkspace.changeCurrentWorkspace(
                      selectedWorkspaceCategoryId: workspaceCategoryId,
                      newWorkspaceIndex: indexInStringWorkspaces);
                  ACVibration.vibrate();
                  Navigator.pop(context);
                  notifyCurrentWorkspaceIsChanged(
                      context: context,
                      newWorkspaceName: currentWorkspace.name);
                  homePageKey.currentState?.setState(() {});
                }
              },
              child: Slidable(
                startActionPane: workspaceCategoryId ==
                            ACWorkspace.currentWorkspaceCategoryId &&
                        indexInStringWorkspaces ==
                            ACWorkspace.currentWorkspaceIndex
                    ? null
                    : ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.35,
                        children: [
                          SlidableAction(
                            autoClose: true,
                            spacing: 8,
                            backgroundColor:
                                theme[settingData.selectedTheme]!.panelColor,
                            foregroundColor:
                                theme[settingData.selectedTheme]!.accentColor,
                            onPressed: (BuildContext context) {
                              if (!isInList) {
                                Navigator.pop(context);
                              }
                              ACWorkspace.deleteWorkspaceAlert(
                                  context: context,
                                  selectedWorkspaceCategoryId:
                                      workspaceCategoryId,
                                  indexInStringWorkspaces:
                                      indexInStringWorkspaces);
                            },
                            icon: Icons.remove,
                            label: "Delete",
                          ),
                        ],
                      ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.35,
                  children: [
                    SlidableAction(
                      autoClose: true,
                      spacing: 8,
                      backgroundColor:
                          theme[settingData.selectedTheme]!.panelColor,
                      foregroundColor:
                          theme[settingData.selectedTheme]!.accentColor,
                      onPressed: (BuildContext context) {
                        if (!isInList) {
                          Navigator.pop(context);
                        }
                        ACWorkspace.editWorkspaceAlert(
                            context: context,
                            selectedWorkspaceCategoryId: workspaceCategoryId,
                            selectedWorkspaceIndex: indexInStringWorkspaces);
                      },
                      icon: Icons.edit,
                      label: "Edit",
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Text(
                        ((workspaceCategoryId ==
                                        ACWorkspace
                                            .currentWorkspaceCategoryId &&
                                    indexInStringWorkspaces ==
                                        ACWorkspace.currentWorkspaceIndex &&
                                    isInList)
                                ? "☆ "
                                : "") +
                            ((workspaceCategoryId ==
                                        ACWorkspace
                                            .currentWorkspaceCategoryId &&
                                    indexInStringWorkspaces ==
                                        ACWorkspace.currentWorkspaceIndex)
                                ? currentWorkspace.name
                                : json.decode(stringWorkspace)["name"]) +
                            ((workspaceCategoryId ==
                                        ACWorkspace
                                            .currentWorkspaceCategoryId &&
                                    indexInStringWorkspaces ==
                                        ACWorkspace.currentWorkspaceIndex &&
                                    isInList)
                                ? "   "
                                : ""),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color:
                                theme[settingData.selectedTheme]!.accentColor,
                            letterSpacing: 1)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
