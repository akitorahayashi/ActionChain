import 'package:action_chain/alerts/simple_alert.dart';
import 'package:action_chain/alerts/yes_no_alert.dart';
import 'package:action_chain/components/actodo_card.dart';
import 'package:action_chain/components/ui/action_chain_sliver_appbar.dart';
import 'package:action_chain/components/ui/controll_icon_button.dart';
import 'package:action_chain/model/ac_todo/ac_chain.dart';
import 'package:action_chain/model/ac_todo/ac_todo.dart';
import 'package:action_chain/model/ac_todo/ac_step.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_todo/ac_category.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';

import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/model/ac_theme.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reorderables/reorderables.dart';

// ignore: must_be_immutable
class MakeChainPage extends StatefulWidget {
  String? selectedCategoryId;
  String? oldCategoryId;
  int? indexOfChainInSavedChains;
  MakeChainPage({
    required Key key,
    required this.selectedCategoryId,
    required this.oldCategoryId,
    required this.indexOfChainInSavedChains,
  }) : super(key: key);

  @override
  State<MakeChainPage> createState() => _MakeChainPageState();
}

class _MakeChainPageState extends State<MakeChainPage> {
  String? _selectedChainCategoryId;
  final TextEditingController _chainTitleInputController =
      TextEditingController();

  // action系の変数
  List<ACToDo> _addedActionMethods = [];
  final TextEditingController _actionTitleInputController =
      TextEditingController();
  int? _indexOfEditedActionInActions;

  void _addOrEditMethodAction() {
    if (_indexOfEditedActionInActions == null) {
      _addedActionMethods.add(
          ACToDo(title: _actionTitleInputController.text, steps: _addedSteps));
    } else {
      _addedActionMethods.removeAt(_indexOfEditedActionInActions!);
      _addedActionMethods.insert(_indexOfEditedActionInActions!,
          ACToDo(title: _actionTitleInputController.text, steps: _addedSteps));
    }
    // 追加カードを初期化する
    _actionTitleInputController.clear();
    _indexOfEditedActionInActions = null;
    // step
    _addedSteps = [];
    _stepTitleInputController.clear();
    setState(() {});
    ACVibration.vibrate();
  }

  // step追加系の変数
  List<ACStep> _addedSteps = [];
  final TextEditingController _stepTitleInputController =
      TextEditingController();
  int? _indexOfEditedStep;

  void _addOrEditStepAction() {
    if (_indexOfEditedStep == null) {
      _addedSteps.add(ACStep(title: _stepTitleInputController.text));
    } else {
      _addedSteps.removeAt(_indexOfEditedStep!);
      _addedSteps.insert(
          _indexOfEditedStep!, ACStep(title: _stepTitleInputController.text));
      _indexOfEditedStep = null;
    }
    _stepTitleInputController.clear();
    setState(() {});
    ACVibration.vibrate();
  }

  @override
  void initState() {
    super.initState();
    if (ACWorkspace.runningActionChain != null) {
      // 編集モードの処理
      _selectedChainCategoryId = widget.selectedCategoryId;
      _chainTitleInputController.text = ACWorkspace.runningActionChain!.title;
      _addedActionMethods = ACWorkspace.runningActionChain!.actodos;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _chainTitleInputController.dispose();
    _actionTitleInputController.dispose();
    _stepTitleInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景色
          Container(
              color: acThemeDataList[SettingData.shared.selectedThemeIndex]
                  .backgroundColor),
          CustomScrollView(
            slivers: [
              ActionChainSliverAppBar(
                pageTitle: "Make Action Chain",
                titleFontSize: 16,
                leadingButtonOnPressed: () {
                  // 実行したりしないで戻ってしまうのか確認する
                  if (_addedActionMethods.isEmpty) {
                    // 元のページに戻る
                    Navigator.pop(context);
                  } else {
                    yesNoAlert(
                        context: context,
                        title: "本当に戻りますか?",
                        message: "作成されたAction Chainが\n完全に削除されます",
                        yesAction: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                  }
                },
                leadingIcon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                trailingButtonOnPressed: null,
                trailingIcon: null,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                const SizedBox(height: 10),
                // action chainの体裁を整える
                GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        // カテゴリーを選択してsmallCategory選択のためのdropdownを更新する
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                          child: DropdownButton(
                              iconEnabledColor: acThemeDataList[
                                      SettingData.shared.selectedThemeIndex]
                                  .accentColor,
                              isExpanded: true,
                              hint: Text(
                                _selectedChainCategoryId == null
                                    ? "Category"
                                    : ACWorkspace
                                        .currentWorkspace.chainCategories
                                        .where((chainCategory) =>
                                            chainCategory.id ==
                                            _selectedChainCategoryId!)
                                        .first
                                        .title,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.45),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              items: [
                                ...ACWorkspace.currentWorkspace.chainCategories,
                                ACCategory(id: "---makeNew", title: "新しく作る"),
                              ].map((ACCategory chainCategory) {
                                return DropdownMenuItem(
                                  value: chainCategory,
                                  child: Text(
                                    chainCategory.title,
                                    style: chainCategory.id == noneId &&
                                                _selectedChainCategoryId ==
                                                    null ||
                                            chainCategory.id ==
                                                _selectedChainCategoryId
                                        ? TextStyle(
                                            color: acThemeDataList[SettingData
                                                    .shared.selectedThemeIndex]
                                                .accentColor,
                                            fontWeight: FontWeight.bold)
                                        : TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList(),
                              onChanged: (ACCategory? newBigCategoryId) async {
                                if (newBigCategoryId != null) {
                                  switch (newBigCategoryId.id) {
                                    case noneId:
                                      _selectedChainCategoryId = null;
                                      break;
                                    case "---makeNew":
                                      _selectedChainCategoryId =
                                          await ACCategory.addCategoryAlert(
                                              context: context);
                                      break;
                                    default:
                                      _selectedChainCategoryId =
                                          newBigCategoryId.id;
                                  }
                                  setState(() {});
                                }
                              }),
                        ),

                        // chainのtitleを入力する
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 36.0),
                            child: TextField(
                              autofocus:
                                  ACWorkspace.runningActionChain == null ||
                                      (ACWorkspace.runningActionChain!.title
                                          .trim()
                                          .isEmpty),
                              controller: _chainTitleInputController,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: "Chain Title",
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.45),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 作成した内容を表示する、操作ボタン集
                GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0, bottom: 8),
                          // タイトル
                          child: Text(
                            "Action Chain",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                                letterSpacing: 0.8,
                                color: acThemeDataList[
                                        SettingData.shared.selectedThemeIndex]
                                    .backupButtonTextColor),
                          ),
                        ),
                        // methodsを表示する
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: PrimaryScrollController(
                            controller: ScrollController(),
                            child: ReorderableColumn(
                              children: [
                                for (int indexOfThisActionMethod = 0;
                                    indexOfThisActionMethod <
                                        _addedActionMethods.length;
                                    indexOfThisActionMethod++)
                                  ACToDoCard(
                                    key: Key(UniqueKey().toString()),
                                    superKey: makeActionChainPageKey,
                                    isCurrentChain: true,
                                    isInKeepedChain: false,
                                    disableSliderable: false,
                                    disableTapGesture: true,
                                    // action method
                                    actionMethods: _addedActionMethods,
                                    indexOfThisActionMethod:
                                        indexOfThisActionMethod,
                                    actionMethodData: _addedActionMethods[
                                        indexOfThisActionMethod],
                                    // スライドして編集した時の関数
                                    editAction: () {
                                      // action method
                                      final ACToDo selectedActionMethod =
                                          _addedActionMethods[
                                              indexOfThisActionMethod];
                                      _actionTitleInputController.text =
                                          selectedActionMethod.title;
                                      for (ACStep step
                                          in selectedActionMethod.steps) {
                                        _addedSteps.add(step);
                                      }
                                      _indexOfEditedActionInActions =
                                          indexOfThisActionMethod;
                                      setState(() {});
                                    },
                                  ),
                              ],
                              onReorder: (oldIndex, newIndex) {
                                final ACToDo reorderedMethod =
                                    _addedActionMethods.removeAt(oldIndex);
                                _addedActionMethods.insert(
                                    newIndex, reorderedMethod);
                                setState(() {});
                              },
                            ),
                          ),
                        ),

                        // ActionMethodのタイトルを入力するTextFormField
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            // ActionMethod追加ボタン
                            child: TextField(
                              controller: _actionTitleInputController,
                              onChanged: (_) => setState(() {}),
                              onSubmitted: _actionTitleInputController.text
                                      .trim()
                                      .isEmpty
                                  ? null
                                  : (_) => _addOrEditMethodAction(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.6)),
                              decoration: InputDecoration(
                                icon: FaIcon(
                                  FontAwesomeIcons.square,
                                  color: Colors.black.withOpacity(0.35),
                                ),
                                label: const Text("Action"),
                                labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.45)),
                                // 完了ボタン
                                suffixIcon: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: _actionTitleInputController.text
                                          .trim()
                                          .isNotEmpty
                                      ? 1
                                      : 0.5,
                                  child: TextButton(
                                    child: Icon(
                                      _indexOfEditedActionInActions == null
                                          ? Icons.add
                                          : Icons.edit,
                                      color: _actionTitleInputController.text
                                              .trim()
                                              .isEmpty
                                          ? Colors.black45
                                          : acThemeDataList[SettingData
                                                  .shared.selectedThemeIndex]
                                              .accentColor,
                                      size: 25,
                                    ),
                                    onPressed: _actionTitleInputController.text
                                            .trim()
                                            .isEmpty
                                        ? null
                                        : () => _addOrEditMethodAction(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 入力したstepsを表示
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: PrimaryScrollController(
                            controller: ScrollController(),
                            child: ReorderableColumn(
                              children: List<Widget>.generate(
                                  _addedSteps.length, (index) {
                                return Padding(
                                  key: Key(UniqueKey().toString()),
                                  padding:
                                      const EdgeInsets.only(left: 16.0, top: 1),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 21.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16.0),
                                          child: FaIcon(
                                            FontAwesomeIcons.square,
                                            color:
                                                Colors.black.withOpacity(0.35),
                                            size: 23,
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                _stepTitleInputController.text =
                                                    _addedSteps[index].title;
                                                _indexOfEditedStep = index;
                                                ACVibration.vibrate();
                                                setState(() {});
                                              },
                                              child: Text(
                                                _addedSteps[index].title,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black
                                                        .withOpacity(0.55)),
                                              )),
                                        ),
                                        // step を消す
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16.0),
                                          child: TextButton(
                                            onPressed: () {
                                              _addedSteps.removeAt(index);
                                              _indexOfEditedStep = null;
                                              _stepTitleInputController.clear();
                                              setState(() {});
                                            },
                                            style: TextButton.styleFrom(
                                              splashFactory:
                                                  NoSplash.splashFactory,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 9.0),
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.black
                                                    .withOpacity(0.35),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              onReorder: (oldIndex, newIndex) {
                                if (oldIndex != newIndex) {
                                  final reorderedToDo =
                                      _addedSteps.removeAt(oldIndex);
                                  _addedSteps.insert(newIndex, reorderedToDo);

                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ),

                        // steps入力のtextFormField
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TextField(
                                controller: _stepTitleInputController,
                                onChanged: (_) => setState(() {}),
                                onSubmitted: (_) => _addOrEditStepAction(),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.6)),
                                decoration: InputDecoration(
                                  labelText: "Step",
                                  labelStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.45)),
                                  icon: FaIcon(
                                    FontAwesomeIcons.square,
                                    color: Colors.black.withOpacity(0.35),
                                  ),
                                  suffixIcon: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: _stepTitleInputController.text
                                            .trim()
                                            .isNotEmpty
                                        ? 1
                                        : 0.25,
                                    child: TextButton(
                                      onPressed: _stepTitleInputController.text
                                              .trim()
                                              .isEmpty
                                          ? null
                                          : () {
                                              _addOrEditStepAction();
                                            },
                                      child: Icon(
                                        _indexOfEditedStep != null
                                            ? Icons.edit
                                            : Icons.add,
                                        color: _stepTitleInputController.text
                                                .trim()
                                                .isNotEmpty
                                            ? acThemeDataList[SettingData
                                                    .shared.selectedThemeIndex]
                                                .accentColor
                                            : Colors.black,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // 初期化, 保存、キープ、実行
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: OverflowBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              // 初期化
                              ControllIconButton(
                                  onPressed: () {
                                    // make chain pageを初期化する関数
                                    void initializeMakeChainPage() {
                                      _selectedChainCategoryId = null;
                                      _chainTitleInputController.clear();
                                      // action method
                                      ACWorkspace.runningActionChain = null;
                                      _actionTitleInputController.clear();
                                      _stepTitleInputController.clear();
                                      _addedActionMethods = [];
                                      _addedSteps = [];
                                      _indexOfEditedActionInActions = null;
                                      _indexOfEditedStep = null;
                                      ACWorkspace.saveCurrentChain();
                                    }

                                    // 実際の処理
                                    if (widget.oldCategoryId != null) {
                                      yesNoAlert(
                                          context: context,
                                          title: "編集モードを解除しますか？",
                                          message:
                                              "解除することで新たなSaved Chainを作成することができます",
                                          yesAction: () {
                                            Navigator.pop(context);
                                            widget.oldCategoryId = null;
                                            widget.indexOfChainInSavedChains =
                                                null;
                                            setState(() {});
                                            // 作成した内容の削除
                                            yesNoAlert(
                                                context: context,
                                                title:
                                                    "このAction Chainを\n削除しますか？",
                                                message: null,
                                                yesAction: () {
                                                  Navigator.pop(context);
                                                  initializeMakeChainPage();
                                                  simpleAlert(
                                                      context: context,
                                                      title:
                                                          "初期化することに\n成功しました！",
                                                      message: null,
                                                      buttonText: "thank you!");
                                                  setState(() {});
                                                });
                                          });
                                    } else {
                                      // 作成した内容の削除
                                      yesNoAlert(
                                          context: context,
                                          title: "このページを\n初期化しますか？",
                                          message: null,
                                          yesAction: () {
                                            Navigator.pop(context);
                                            initializeMakeChainPage();
                                            simpleAlert(
                                                context: context,
                                                title: "初期化することに\n成功しました！",
                                                message: null,
                                                buttonText: "thank you!");
                                            setState(() {});
                                          });
                                    }
                                  },
                                  iconData: Icons.clear,
                                  textContent: "初期化"),
                              // 保存
                              ControllIconButton(
                                  onPressed: (_chainTitleInputController.text
                                              .trim()
                                              .isEmpty ||
                                          _addedActionMethods.isEmpty)
                                      ? null
                                      : () {
                                          if (widget.oldCategoryId == null) {
                                            // 新しく作成する
                                            ActionChain.askToSaveChain(
                                                context: context,
                                                wantToKeep: false,
                                                categoryId:
                                                    _selectedChainCategoryId ??
                                                        noneId,
                                                selectedChain: ActionChain(
                                                  title:
                                                      _chainTitleInputController
                                                          .text,
                                                  actodos: _addedActionMethods,
                                                ),
                                                releaseEditModeAction: () {
                                                  widget.oldCategoryId = null;
                                                  widget.indexOfChainInSavedChains =
                                                      null;
                                                });
                                          } else {
                                            // 上書きする
                                            yesNoAlert(
                                                context: context,
                                                title: "上書きしますか？",
                                                message:
                                                    "既存のSaved Chainを\n上書きすることができます",
                                                yesAction: () {
                                                  Navigator.pop(context);
                                                  // 上書きする
                                                  final ActionChain
                                                      overwrittenChain =
                                                      ACWorkspace
                                                              .currentWorkspace
                                                              .savedChains[
                                                          widget
                                                              .oldCategoryId]![widget
                                                          .indexOfChainInSavedChains!];
                                                  overwrittenChain
                                                    ..title =
                                                        _chainTitleInputController
                                                            .text
                                                    ..actodos =
                                                        ACToDo.getNewMethods(
                                                            selectedMethods:
                                                                _addedActionMethods);

                                                  simpleAlert(
                                                      context: context,
                                                      title: "上書きすることに\n成功しました",
                                                      message: null,
                                                      buttonText: "OK");
                                                  ActionChain.saveActionChains(
                                                      isSavedChains: true);
                                                });
                                          }
                                        },
                                  iconData: widget.oldCategoryId != null
                                      ? Icons.edit
                                      : Icons.save,
                                  textContent: widget.oldCategoryId != null
                                      ? "上書き"
                                      : "保存"),
                              // キープ
                              ControllIconButton(
                                  onPressed: (_chainTitleInputController.text
                                              .trim()
                                              .isEmpty ||
                                          _addedActionMethods.isEmpty)
                                      ? null
                                      : () {
                                          ActionChain.askToSaveChain(
                                              context: context,
                                              wantToKeep: true,
                                              categoryId:
                                                  _selectedChainCategoryId ??
                                                      noneId,
                                              selectedChain: ActionChain(
                                                  title:
                                                      _chainTitleInputController
                                                          .text,
                                                  actodos: _addedActionMethods),
                                              releaseEditModeAction: () {
                                                widget.oldCategoryId = null;
                                                widget
                                                    .indexOfChainInSavedChains;
                                              });
                                        },
                                  iconData: Icons.label_important,
                                  textContent: "キープ"),
                              // 実行
                              ControllIconButton(
                                  onPressed: _addedActionMethods.isEmpty
                                      ? null
                                      : () {
                                          ACWorkspace.runningActionChain =
                                              ActionChain(
                                                  title:
                                                      _chainTitleInputController
                                                          .text,
                                                  actodos: _addedActionMethods);
                                          ACWorkspace.saveCurrentChain();
                                          Navigator.pop(context, {
                                            "selectedCategoryId":
                                                _selectedChainCategoryId,
                                            "oldCategoryId":
                                                widget.oldCategoryId,
                                            "indexOfChainInSavedChains":
                                                widget.indexOfChainInSavedChains
                                          });
                                        },
                                  iconData: Icons.near_me,
                                  textContent: "実行"),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 400),
              ])),
            ],
          ),
        ],
      ),
    );
  }
}
