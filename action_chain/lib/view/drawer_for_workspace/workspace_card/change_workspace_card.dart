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
  final String acWorkspace;
  final int indexInStringWorkspaces;
  const ChangeWorkspaceCard(
      {Key? key,
      required this.isInList,
      required this.acWorkspace,
      required this.indexInStringWorkspaces})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          5,
          1,
          5,
          (indexInStringWorkspaces == ACWorkspace.currentWorkspaceIndex &&
                  !isInList)
              ? 5
              : 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 70),
        child: Card(
          color: acTheme[SettingData.shared.selectedThemeIndex].panelColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              radius: 10,
              onTap: () async {
                if (indexInStringWorkspaces ==
                    ACWorkspace.currentWorkspaceIndex) {
                  Navigator.pop(context);
                } else {
                  ACWorkspace.changeCurrentWorkspace(
                      newWorkspaceIndex: indexInStringWorkspaces);
                  ACVibration.vibrate();
                  Navigator.pop(context);
                  notifyCurrentWorkspaceIsChanged(
                      context: context,
                      newWorkspaceName: ACWorkspace.currentWorkspace.name);
                  homePageKey.currentState?.setState(() {});
                }
              },
              child: Slidable(
                startActionPane: indexInStringWorkspaces ==
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
                                acTheme[SettingData.shared.selectedThemeIndex]
                                    .panelColor,
                            foregroundColor:
                                acTheme[SettingData.shared.selectedThemeIndex]
                                    .accentColor,
                            onPressed: (BuildContext context) {
                              if (!isInList) {
                                Navigator.pop(context);
                              }
                              ACWorkspace.deleteWorkspaceAlert(
                                  context: context,
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
                          acTheme[SettingData.shared.selectedThemeIndex]
                              .panelColor,
                      foregroundColor:
                          acTheme[SettingData.shared.selectedThemeIndex]
                              .accentColor,
                      onPressed: (BuildContext context) {
                        if (!isInList) {
                          Navigator.pop(context);
                        }
                        ACWorkspace.editWorkspaceAlert(
                            context: context,
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
                        ((indexInStringWorkspaces ==
                                        ACWorkspace.currentWorkspaceIndex &&
                                    isInList)
                                ? "☆ "
                                : "") +
                            ((indexInStringWorkspaces ==
                                    ACWorkspace.currentWorkspaceIndex)
                                ? ACWorkspace.currentWorkspace.name
                                : json.decode(acWorkspace)["name"]) +
                            ((indexInStringWorkspaces ==
                                        ACWorkspace.currentWorkspaceIndex &&
                                    isInList)
                                ? "   "
                                : ""),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color:
                                acTheme[SettingData.shared.selectedThemeIndex]
                                    .accentColor,
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
