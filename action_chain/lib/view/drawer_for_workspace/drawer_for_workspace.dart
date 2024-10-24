import 'package:action_chain/model/ac_workspace/ac_workspaces.dart';
import 'package:action_chain/view/drawer_for_workspace/workspace_card/change_workspace_card.dart';
import 'package:action_chain/components/ui/action_chain_sliver_appbar.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class DrawerForWorkspace extends StatefulWidget {
  final bool isContentMode;
  const DrawerForWorkspace({required Key key, required this.isContentMode})
      : super(key: key);

  @override
  State<DrawerForWorkspace> createState() => _DrawerForWorkspaceState();
}

class _DrawerForWorkspaceState extends State<DrawerForWorkspace> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          // 背景色
          Container(color: theme[settingData.selectedTheme]!.backgroundColor),
          CustomScrollView(
            slivers: [
              ActionChainSliverAppBar(
                  pageTitle: "Workspace",
                  leadingButtonOnPressed: null,
                  leadingIcon: Container(),
                  trailingButtonOnPressed: null,
                  trailingIcon: null),
              SliverList(
                  delegate: SliverChildListDelegate([
                // 現在のworkspace
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 16, 3, 5),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            theme[settingData.selectedTheme]!.panelBorderColor),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                            child: Text(
                              "current workspace",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.4),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          ChangeWorkspaceCard(
                              isInList: false,
                              acWorkspace: ACWorkspace.currentWorkspace.name,
                              indexInStringWorkspaces:
                                  ACWorkspace.currentWorkspaceIndex)
                        ],
                      ),
                    ),
                  ),
                ),
                // workspaceを選ぶ
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            theme[settingData.selectedTheme]!.panelBorderColor),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                        child: Column(
                          children: [
                            ReorderableColumn(
                              children: [
                                for (ACWorkspace acWorkspace
                                    in acWorkspaces) // すべてのworkspaceを表示
                                  ChangeWorkspaceCard(
                                      isInList: true,
                                      acWorkspace: acWorkspace.name,
                                      indexInStringWorkspaces:
                                          acWorkspaces.indexOf(acWorkspace)),
                              ],
                              onReorder: (oldIndex, newIndex) {
                                // currentWorkspaceをまたぐときの処理
                                setState(() {
                                  if (newIndex > oldIndex) {
                                    newIndex -= 1;
                                  }
                                  final ACWorkspace item =
                                      acWorkspaces.removeAt(oldIndex);
                                  acWorkspaces.insert(newIndex, item);

                                  // currentWorkspaceIndexの更新
                                  if (ACWorkspace.currentWorkspaceIndex ==
                                      oldIndex) {
                                    ACWorkspace.changeCurrentWorkspace(
                                        newWorkspaceIndex: newIndex);
                                  } else if (ACWorkspace.currentWorkspaceIndex >
                                          oldIndex &&
                                      ACWorkspace.currentWorkspaceIndex <=
                                          newIndex) {
                                    ACWorkspace.changeCurrentWorkspace(
                                        newWorkspaceIndex:
                                            ACWorkspace.currentWorkspaceIndex -
                                                1);
                                  } else if (ACWorkspace.currentWorkspaceIndex <
                                          oldIndex &&
                                      ACWorkspace.currentWorkspaceIndex >=
                                          newIndex) {
                                    ACWorkspace.changeCurrentWorkspace(
                                        newWorkspaceIndex:
                                            ACWorkspace.currentWorkspaceIndex +
                                                1);
                                  }

                                  ACWorkspace.saveACWorkspaces();
                                });
                              },
                            ),
                            // 新しくworkspaceを追加する
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  ACWorkspace.addWorkspaceAlert(
                                      context: context);
                                },
                                child: Icon(
                                  Icons.add,
                                  color: theme[settingData.selectedTheme]!
                                      .accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 250.0,
                ),
              ]))
            ],
          ),
        ],
      ),
    );
  }
}
