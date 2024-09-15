import 'package:action_chain/view/drawer_for_workspace/workspace_card/change_workspace_card.dart';
import 'package:action_chain/view/drawer_for_workspace/content_views/manage_workspace/workspace_category_block.dart';
import 'package:action_chain/view/drawer_for_workspace/drawer_for_workspace.dart';
import 'package:action_chain/components/ui/action_chain_sliver_appbar.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:action_chain/model/external/ac_ads.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';

import 'package:reorderables/reorderables.dart';

class ManageWorkspacePage extends StatefulWidget {
  const ManageWorkspacePage({required Key key}) : super(key: key);

  @override
  State<ManageWorkspacePage> createState() => _ManageWorkspacePageState();
}

class _ManageWorkspacePageState extends State<ManageWorkspacePage> {
  @override
  void initState() {
    super.initState();
    if (!acads.ticketIsActive) {
      acads.loadBanner();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: manageWorkspacesPageScaffoldKey,
      drawer:
          DrawerForWorkspace(key: drawerForWorkspaceKey, isContentMode: true),
      body: Stack(children: [
        // 背景色
        Container(color: theme[settingData.selectedTheme]!.backgroundColor),
        // 本体
        CustomScrollView(
          slivers: [
            ActionChainSliverAppBar(
              titleFontSize: 17,
              titleSpacing: 0.3,
              pageTitle: "Manage Workspaces",
              // drawerを表示するボタン
              leadingButtonOnPressed: () =>
                  manageWorkspacesPageScaffoldKey.currentState!.openDrawer(),
              leadingIcon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              // home pageへ移動するボタン
              trailingButtonOnPressed: () {
                Navigator.pop(context);
                homePageKey.currentState?.setState(() {});
              },
              trailingIcon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 27.5,
              ),
              actions: null,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              // 現在のworkspaceのためのカード
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Card(
                  color: theme[settingData.selectedTheme]!.myPagePanelColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        // currrent workspace card
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 3.0),
                          child: Text(
                            "current workspace",
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ChangeWorkspaceCard(
                            isInList: false,
                            stringWorkspace: acWorkspaces[
                                    ACWorkspace.currentWorkspaceCategoryId]![
                                ACWorkspace.currentWorkspaceIndex],
                            workspaceCategoryId:
                                ACWorkspace.currentWorkspaceCategoryId,
                            indexInStringWorkspaces:
                                ACWorkspace.currentWorkspaceIndex)
                      ],
                    ),
                  ),
                ),
              ),
              // workspace categoryなどを表示する
              Card(
                  color: theme[settingData.selectedTheme]!.myPagePanelColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
                    child: Column(
                      children: [
                        ReorderableColumn(
                            children: [
                              for (int indexOfWorkspaceCategory = 0;
                                  indexOfWorkspaceCategory <
                                      workspaceCategories.length;
                                  indexOfWorkspaceCategory++)
                                WorkspaceCategoryBlock(
                                  key: Key(UniqueKey().toString()),
                                  indexOfWorkspaceCategory:
                                      indexOfWorkspaceCategory,
                                ),
                            ],
                            onReorder: (oldIndex, newIndex) {
                              if (newIndex != 0) {
                                final ACCategory reorderedCategory =
                                    workspaceCategories.removeAt(oldIndex);
                                workspaceCategories.insert(
                                    newIndex, reorderedCategory);
                                manageWorkspacePageKey.currentState
                                    ?.setState(() {});
                                ACCategory.saveWorkspaceCategories();
                              }
                            }),
                        // 新しくworkspaceを追加する
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              ACWorkspace.addWorkspaceAlert(context: context);
                            },
                            child: Icon(
                              Icons.add,
                              color:
                                  theme[settingData.selectedTheme]!.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 250)
            ])),
          ],
        ),
        Positioned(bottom: 0, child: acads.getBannerAds(context: context)),
      ]),
    );
  }
}
