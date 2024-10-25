import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/model/ac_workspace/ac_workspaces.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_todo/ac_category.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/model/ac_theme.dart';
import 'package:action_chain/alerts/simple_alert.dart';
import 'package:flutter/material.dart';

class EditACWorkspaceDialog extends StatefulWidget {
  final int? oldWorkspaceIndex;
  const EditACWorkspaceDialog({Key? key, required this.oldWorkspaceIndex})
      : super(key: key);

  @override
  State<EditACWorkspaceDialog> createState() => _EditACWorkspaceDialogState();
}

class _EditACWorkspaceDialogState extends State<EditACWorkspaceDialog> {
  bool hasComplitedTextPasteToController = false;
  final TextEditingController _workspaceNameInputController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (widget.oldWorkspaceIndex != null &&
        !hasComplitedTextPasteToController) {
      hasComplitedTextPasteToController = true;
      _workspaceNameInputController.text =
          acWorkspaces[widget.oldWorkspaceIndex!].name;
    }
    return Dialog(
      backgroundColor:
          acThemeDataList[SettingData.shared.selectedThemeIndex].alertColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // スペーサー
          const SizedBox(
            height: 30,
          ),
          // 新しいworkspace名を入力するTextFormField
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: SizedBox(
                width: 230,
                child: TextField(
                  autofocus: true,
                  controller: _workspaceNameInputController,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "Workspace",
                    hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.35),
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ),
          // 閉じる 追加するボタン
          OverflowBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              // カテゴリーを作らずにアラートを閉じるボタン
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("閉じる")),
              // workspaceを追加するボタン
              TextButton(
                  onPressed: () {
                    if (_workspaceNameInputController.text.trim().isNotEmpty) {
                      final String _enteredWorkspaceName =
                          _workspaceNameInputController.text;
                      // アラートを閉じる
                      Navigator.pop(context);
                      // workspacesを更新
                      if (widget.oldWorkspaceIndex == null) {
                        // add action
                        acWorkspaces.add(ACWorkspace(
                            name: _enteredWorkspaceName,
                            chainCategories: [
                              ACCategory(id: noneId, title: "なし")
                            ],
                            savedChains: {
                              noneId: []
                            },
                            keepedChains: {
                              noneId: []
                            }));
                        ACWorkspace.notifyWorkspaceIsAdded(
                            context: context,
                            newWorkspaceName: _enteredWorkspaceName);
                      } else {
                        // edit action
                        final ACWorkspace editedWorkspace =
                            acWorkspaces[widget.oldWorkspaceIndex!];
                        editedWorkspace.name = _enteredWorkspaceName;
                        // 消していれる
                        acWorkspaces.removeAt(widget.oldWorkspaceIndex!);
                        acWorkspaces.insert(
                            widget.oldWorkspaceIndex!, editedWorkspace);
                        simpleAlert(
                            context: context,
                            title: "変更することに\n成功しました",
                            message: null,
                            buttonText: "OK");
                      }
                      drawerForWorkspaceKey.currentState?.setState(() {});
                      manageWorkspacePageKey.currentState?.setState(() {});
                      homePageKey.currentState?.setState(() {});
                      ACVibration.vibrate();
                      // workspacesをセーブする
                      ACWorkspace.saveACWorkspaces();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.oldWorkspaceIndex == null ? "追加" : "編集"))
            ],
          )
        ],
      ),
    );
  }
}
