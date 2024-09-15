import 'package:action_chain/view/drawer_for_workspace/content_views/manage_workspace/manage_workspace_page.dart';
import 'package:action_chain/view/drawer_for_workspace/workspace_card/change_workspace_card.dart';
import 'package:action_chain/view/drawer_for_workspace/workspace_category_block_in_drawer.dart';
import 'package:action_chain/view/drawer_for_workspace/content_views/content_card.dart';
import 'package:action_chain/components/ui/action_chain_sliver_appbar.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:flutter/material.dart';

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
                              stringWorkspace: currentWorkspace.name,
                              workspaceCategoryId:
                                  ACWorkspace.currentWorkspaceCategoryId,
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
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          // カードの表示
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  for (ACCategory workspaceCategory
                                      in workspaceCategories)
                                    WorkspaceCategoryBlockInDrawer(
                                        workspaceCategory: workspaceCategory),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // コンテンツビューを選ぶ
                if (!widget.isContentMode)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(3, 16, 3, 5),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme[settingData.selectedTheme]!
                              .panelBorderColor),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 5),
                              child: Text(
                                "content",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            // manage workspace
                            ContentCard(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) {
                                            return ManageWorkspacePage(
                                              key: manageWorkspacePageKey,
                                            );
                                          }));
                                },
                                contentName: "Manage Workspaces"),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 250,
                )
              ]))
            ],
          ),
        ],
      ),
    );
  }
}
