import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/model/ac_workspace/ac_workspaces.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/alerts/simple_alert.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class EditACWorkspaceDialog extends StatefulWidget {
  final String? oldWorkspaceCategoryId;
  final int? oldWorkspaceIndex;
  const EditACWorkspaceDialog(
      {Key? key,
      required this.oldWorkspaceCategoryId,
      required this.oldWorkspaceIndex})
      : super(key: key);

  @override
  State<EditACWorkspaceDialog> createState() => _EditACWorkspaceDialogState();
}

class _EditACWorkspaceDialogState extends State<EditACWorkspaceDialog> {
  String? _selectedWorkspaceCategoryId;
  bool isInitialized = false;
  final TextEditingController _workspaceNameInputController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (widget.oldWorkspaceCategoryId != null && !isInitialized) {
      isInitialized = true;
      _selectedWorkspaceCategoryId = widget.oldWorkspaceCategoryId;
      _workspaceNameInputController.text = json.decode(acWorkspaces[
          widget.oldWorkspaceCategoryId]![widget.oldWorkspaceIndex!])["name"];
    }
    return Dialog(
      backgroundColor: theme[settingData.selectedTheme]!.alertColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // スペーサー
          const SizedBox(
            height: 30,
          ),
          // カテゴリー選択のためのDropdownButton
          SizedBox(
            width: 230,
            child: DropdownButton(
                iconEnabledColor: theme[settingData.selectedTheme]!.accentColor,
                isExpanded: true,
                // smallCategoryをなしにすることで選択できるようになることを知らせる
                hint: Text(
                  _selectedWorkspaceCategoryId == null
                      ? "Category"
                      : workspaceCategories[workspaceCategories.indexWhere(
                              (workspaceCategory) =>
                                  _selectedWorkspaceCategoryId ==
                                  workspaceCategory.id)]
                          .title,
                  style: TextStyle(
                      color: Colors.black.withOpacity(
                          _selectedWorkspaceCategoryId == null ? 0.35 : 0.5),
                      fontWeight: FontWeight.w600),
                ),
                items: [
                  ACCategory(id: noneId, title: "なし"),
                  ...workspaceCategories.sublist(1),
                  ACCategory(id: "---makeNew", title: "新しく作る"),
                ].map((ACCategory item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item.title,
                      style: (item.id == noneId &&
                                  _selectedWorkspaceCategoryId == null) ||
                              item.id == _selectedWorkspaceCategoryId
                          ? TextStyle(
                              color:
                                  theme[settingData.selectedTheme]!.accentColor,
                              fontWeight: FontWeight.bold)
                          : TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                onChanged: (ACCategory? newSmallCategory) async {
                  if (newSmallCategory != null) {
                    switch (newSmallCategory.id) {
                      case noneId:
                        _selectedWorkspaceCategoryId = null;
                        break;
                      case "---makeNew":
                        _selectedWorkspaceCategoryId =
                            await ACCategory.addCategoryAlert(
                          context: context,
                          isChainCategory: false,
                        );
                        break;
                      default:
                        _selectedWorkspaceCategoryId = newSmallCategory.id;
                    }
                    setState(() {});
                  }
                }),
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
          ButtonBar(
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
                      if (widget.oldWorkspaceCategoryId == null) {
                        // add action
                        acWorkspaces[_selectedWorkspaceCategoryId ?? noneId]!
                            .add(json.encode(ACWorkspace(
                                name: _enteredWorkspaceName,
                                chainCategories: [
                              ACCategory(id: noneId, title: "なし")
                            ],
                                savedChains: {
                              noneId: []
                            },
                                keepedChains: {
                              noneId: []
                            }).toJson()));
                        ACWorkspace.notifyWorkspaceIsAdded(
                            context: context,
                            newWorkspaceName: _enteredWorkspaceName);
                      } else {
                        // edit action
                        final ACWorkspace editedWorkspace =
                            ACWorkspace.fromJson(json.decode(
                                acWorkspaces[widget.oldWorkspaceCategoryId!]![
                                    widget.oldWorkspaceIndex!]));
                        editedWorkspace.name = _enteredWorkspaceName;
                        // 消していれる
                        acWorkspaces[widget.oldWorkspaceCategoryId]!
                            .removeAt(widget.oldWorkspaceIndex!);
                        acWorkspaces[_selectedWorkspaceCategoryId ?? noneId]!
                            .insert(widget.oldWorkspaceIndex!,
                                json.encode(editedWorkspace.toJson()));
                        simpleAlert(
                            context: context,
                            title: "変更することに\n成功しました!!",
                            message: null,
                            buttonText: "thank you!");
                      }
                      drawerForWorkspaceKey.currentState?.setState(() {});
                      manageWorkspacePageKey.currentState?.setState(() {});
                      homePageKey.currentState?.setState(() {});
                      ACVibration.vibrate();
                      // workspacesをセーブする
                      ACWorkspace.saveStringWorkspaces();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child:
                      Text(widget.oldWorkspaceCategoryId == null ? "追加" : "編集"))
            ],
          )
        ],
      ),
    );
  }
}
