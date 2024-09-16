import 'package:action_chain/components/ui/action_chain_bottom_navbar/action_chain_floating_action_button.dart';
import 'package:action_chain/components/ui/action_chain_bottom_navbar/action_chain_bottom_navbar.dart';
import 'package:action_chain/components/ui/action_chain_sliver_appbar.dart';
import 'package:action_chain/components/ui/controll_icon_button.dart';
import 'package:action_chain/components/action_method_card.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/view/drawer_for_workspace/drawer_for_workspace.dart';
// import 'package:action_chain/view/home_page/effort_card_of_workspace.dart';
import 'package:action_chain/view/make_chain_page/make_chain_page.dart';
import 'package:action_chain/view/chain_wall/select_chain_wall.dart';
import 'package:action_chain/view/setting_page/setting_page.dart';
import 'package:action_chain/view/show_tutorial_page.dart';
import 'package:action_chain/model/ac_todo/ac_step.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/model/ac_todo/ac_todo.dart';
import 'package:action_chain/model/external/ac_ads.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:action_chain/model/ac_todo/ac_chain.dart';
import 'package:action_chain/alerts/yes_no_alert.dart';
import 'package:action_chain/alerts/simple_alert.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/main.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:reorderables/reorderables.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({required Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool accetColorIsChanged = false;
  bool enterSerialCodeMode = false;

  bool isLoopMode = false;

  String? _selectedCategoryId;
  String? _oldCategoryId;

  int? _indexOfChain;

  // 内容自体を初期化する関数
  void _initializeHomePageContent() {
    ACWorkspace.currentChain = null;
    _selectedCategoryId = null;
    _oldCategoryId = null;
    _indexOfChain = null;
    ACWorkspace.saveCurrentChain();
  }

  // このページの内容を初期化する関数(チェックマークを含む)
  void _askToInitializeHomePageContent() {
    // チェックを全て外す
    yesNoAlert(
        context: context,
        title: "チェックマークを\nすべて外しますか？",
        message: null,
        yesAction: () {
          Navigator.pop(context);
          for (ACToDo actionMethod in ACWorkspace.currentChain!.actodos) {
            actionMethod.isChecked = false;
            if (actionMethod.steps.isNotEmpty) {
              for (ACStep step in actionMethod.steps) {
                step.isChecked = false;
              }
            }
          }
          homePageKey.currentState?.setState(() {});
          ACVibration.vibrate();
          ACWorkspace.saveCurrentChain();
          yesNoAlert(
              context: context,
              title: "このページの内容を\n初期化しますか",
              message: null,
              yesAction: () {
                Navigator.pop(context);
                ACVibration.vibrate();
                _initializeHomePageContent();
                homePageKey.currentState?.setState(() {});
                simpleAlert(
                    context: context,
                    title: "初期化することに\n成功しました",
                    message: null,
                    buttonText: "OK");
              });
        });
  }

  // circular indicator系のメンバー
  // チェック済みのmethodの数を数える関数
  int countCheckedMethods() {
    int counter = 0;
    for (ACToDo methodInSelectedChain in ACWorkspace.currentChain!.actodos) {
      if (methodInSelectedChain.steps.isEmpty) {
        if (methodInSelectedChain.isChecked) {
          counter++;
        }
      } else {
        for (ACStep step in methodInSelectedChain.steps) {
          if (step.isChecked) {
            counter++;
          }
        }
      }
    }
    return counter;
  }

  int totalNumberOfUncheckedMethods() {
    int counter = 0;
    for (ACToDo methodInSelectedChain in ACWorkspace.currentChain!.actodos) {
      if (methodInSelectedChain.steps.isNotEmpty) {
        counter += methodInSelectedChain.steps.length;
      } else {
        counter++;
      }
    }
    return counter;
  }

  bool get isCompleted =>
      totalNumberOfUncheckedMethods() == countCheckedMethods();

  void goToMakeChainPage() async {
    final Map<String, dynamic>? _chainData =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MakeChainPage(
        key: makeActionChainPageKey,
        selectedCategoryId: _selectedCategoryId,
        oldCategoryId: _oldCategoryId,
        indexOfChainInSavedChains: _indexOfChain,
      );
    }));
    if (_chainData != null) {
      _selectedCategoryId = _chainData["selectedCategoryId"];
      _oldCategoryId = _chainData["oldCategoryId"];
      _indexOfChain = _chainData["indexOfChainInSavedChains"];
    } else {
      _initializeHomePageContent();
    }
    ACWorkspace.saveCurrentChain();
    homePageKey.currentState?.setState(() {});
  }

  Future<void> askToCompliteChain() {
    return yesNoAlert(
        context: context,
        title: "このAction Chainを\n完了しますか？",
        message: null,
        yesAction: () {
          Navigator.pop(context);
          // カウントする
          final int nummberOfActionMethods = (() {
            int counter = 0;
            for (ACToDo method in ACWorkspace.currentChain!.actodos) {
              if (method.steps.isEmpty) {
                counter++;
              } else {
                counter += method.steps.length;
              }
            }
            return counter;
          }());
          // 初期化
          if (isLoopMode) {
            // チェックマークを外す
            for (ACToDo method in ACWorkspace.currentChain!.actodos) {
              method.isChecked = false;
              for (ACStep step in method.steps) {
                step.isChecked = false;
              }
            }
            ACWorkspace.saveCurrentChain();
          } else {
            _initializeHomePageContent();
          }
          homePageKey.currentState?.setState(() {});
          ACVibration.vibrate();
          // 保存
          ACWorkspace.saveCurrentWorkspace(
              selectedWorkspaceCategoryId:
                  ACWorkspace.currentWorkspaceCategoryId,
              selectedWorkspaceIndex: ACWorkspace.currentWorkspaceIndex,
              selectedWorkspace: currentWorkspace);
          ActionChain.saveActionChains(isSavedChains: true);
        });
  }

  @override
  void initState() {
    super.initState();
    // 画面の描画が終わったタイミングで処理
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!accetColorIsChanged) {
        accetColorIsChanged = true;
        actionChainAppKey.currentState?.setState(() {});
      }
      // スプラッシュ画面を閉じる
      FlutterNativeSplash.remove();
      if (settingData.isFirstEntry) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const ShowTutorialPage();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homePageScaffoldKey,
      drawer:
          DrawerForWorkspace(key: drawerForWorkspaceKey, isContentMode: false),
      body: Stack(
        children: [
          // 背景色
          Container(color: theme[settingData.selectedTheme]!.backgroundColor),
          CustomScrollView(
            slivers: [
              ActionChainSliverAppBar(
                pageTitle: "Action Chain",
                // drawerを表示するボタン
                leadingButtonOnPressed: () {
                  if (ACWorkspace.currentChain != null) {
                    // 現在のAction Chainが
                    yesNoAlert(
                        context: context,
                        title: "本当によろしいですか？",
                        message: "実行中にWorkspaceの一覧を開くと実行中のAction Chainが削除されます",
                        yesAction: () {
                          Navigator.pop(context);
                          _initializeHomePageContent();
                          setState(() {});
                          homePageScaffoldKey.currentState!.openDrawer();
                        });
                  } else {
                    homePageScaffoldKey.currentState!.openDrawer();
                  }
                },
                leadingIcon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                // pro pageへ遷移する、setting pageへ移動するボタン
                trailingButtonOnPressed: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return SettingPage(key: settingPageKey);
                  }));
                  homePageKey.currentState?.setState(() {});
                },
                trailingIcon: const Icon(Icons.settings, color: Colors.white),
                actions: [
                  // setting pageへ遷移する
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, right: 16.5),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SettingPage(key: settingPageKey);
                            }));
                            homePageKey.currentState?.setState(() {});
                          },
                          child:
                              const Icon(Icons.settings, color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        // ignore: prefer_const_constructors
                        // EffortCardOfWorkspace(),

                        // chainの内容を表示する
                        if (ACWorkspace.currentChain != null)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 22.0),
                              child: Column(
                                children: [
                                  if (ACWorkspace.currentChain!.title
                                      .trim()
                                      .isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12.0, left: 12, right: 12),
                                      child: Text(
                                        ACWorkspace.currentChain!.title,
                                        style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                120, 120, 120, 1)),
                                      ),
                                    ),
                                  ReorderableColumn(
                                      children: [
                                        for (int indexOfActionMethod = 0;
                                            indexOfActionMethod <
                                                ACWorkspace.currentChain!
                                                    .actodos.length;
                                            indexOfActionMethod++)
                                          ActionMethodCard(
                                              key: Key(UniqueKey().toString()),
                                              superKey: homePageKey,
                                              isCurrentChain: true,
                                              isInKeepedChain: false,
                                              disableSliderable: true,
                                              disableTapGesture: false,
                                              // action method
                                              actionMethods: ACWorkspace
                                                  .currentChain!.actodos,
                                              indexOfThisActionMethod:
                                                  indexOfActionMethod,
                                              actionMethodData: ACWorkspace
                                                  .currentChain!
                                                  .actodos[indexOfActionMethod],
                                              editAction: () =>
                                                  goToMakeChainPage()),
                                      ],
                                      onReorder: (oldIndex, newIndex) {
                                        final ACToDo reorderedMethod =
                                            ACWorkspace.currentChain!.actodos
                                                .removeAt(oldIndex);
                                        ACWorkspace.currentChain!.actodos
                                            .insert(newIndex, reorderedMethod);
                                        setState(() {});
                                        ACWorkspace.saveCurrentChain();
                                      }),
                                ],
                              ),
                            ),
                          ),
                        if (ACWorkspace.currentChain == null)
                          const SizedBox(height: 120),
                        // ボタン集
                        // ループ、完了
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              // ループ
                              ControllIconButton(
                                  onPressed: () {
                                    isLoopMode = !isLoopMode;
                                    setState(() {});
                                    ACVibration.vibrate();
                                  },
                                  iconData: Icons.autorenew,
                                  buttonIsColored: isLoopMode,
                                  textContent: "ループ"),
                              // 作成、完了
                              ControllIconButton(
                                  onPressed: ACWorkspace.currentChain == null
                                      ? () => goToMakeChainPage()
                                      : (!isCompleted
                                          ? null
                                          : () => askToCompliteChain()),
                                  iconData: ACWorkspace.currentChain == null
                                      ? Icons.add
                                      : Icons.done,
                                  textContent: ACWorkspace.currentChain == null
                                      ? "作成"
                                      : "完了"),
                            ],
                          ),
                        ),
                        // 初期化、キープ、編集
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            // 初期化
                            ControllIconButton(
                                onPressed: ACWorkspace.currentChain == null
                                    ? null
                                    : () => _askToInitializeHomePageContent(),
                                iconData: Icons.clear,
                                textContent: "初期化"),
                            // キープ
                            ControllIconButton(
                                onPressed: !(ACWorkspace.currentChain != null &&
                                        ACWorkspace.currentChain!.title
                                            .trim()
                                            .isNotEmpty)
                                    ? null
                                    : () => yesNoAlert(
                                        context: context,
                                        title: "キープしますか？",
                                        message:
                                            "Action Chainをキープすることで簡単に呼び出して使えるようになります",
                                        yesAction: () {
                                          Navigator.pop(context);
                                          ACVibration.vibrate();
                                          currentWorkspace.keepedChains[
                                                  _selectedCategoryId ??
                                                      noneId]!
                                              .add(ACWorkspace.currentChain!);
                                          // 初期化
                                          _initializeHomePageContent();
                                          homePageKey.currentState
                                              ?.setState(() {});
                                          // アラート
                                          simpleAlert(
                                              context: context,
                                              title: "キープすることに\n成功しました",
                                              message: null,
                                              buttonText: "OK");
                                          ActionChain.saveActionChains(
                                              isSavedChains: false);
                                        }),
                                iconData: Icons.label_important,
                                textContent: "キープ"),
                            // 編集
                            ControllIconButton(
                                onPressed: ACWorkspace.currentChain == null
                                    ? null
                                    : () => goToMakeChainPage(),
                                iconData: Icons.edit,
                                iconSize:
                                    ACWorkspace.currentChain == null ? 28 : 26,
                                textContent: "編集"),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 250),
              ]))
            ],
          ),
          // ignore: prefer_const_constructors
          ActionChainBottomNavBar(),
          // buttons
          Positioned(
            bottom: 75 * MediaQuery.of(context).size.height / 896 - 65 / 2 + 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // saved
                  ActionChainFloatingActionButton(
                    onPressed: () async {
                      _oldCategoryId = null;
                      _indexOfChain = null;
                      final Map<String, dynamic>? _retrievedData =
                          await showCupertinoModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.white,
                              enableDrag: false,
                              builder: (context) {
                                return SelectChainWall(
                                  key: selectChainWallKey,
                                  isSavedChains: true,
                                );
                              });
                      if (_retrievedData != null) {
                        _selectedCategoryId =
                            _retrievedData["selectedCategoryId"];
                        _oldCategoryId = _retrievedData["oldCategoryId"];
                        _indexOfChain = _retrievedData["indexOfChain"];
                        homePageKey.currentState?.setState(() {});
                        if (!_retrievedData["wantToConduct"]) {
                          goToMakeChainPage();
                        }
                        ACWorkspace.saveCurrentChain();
                      }
                    },
                    child: null,
                  ),
                  // keep
                  ActionChainFloatingActionButton(
                    onPressed: () async {
                      final Map<String, dynamic>? _retrievedData =
                          await showCupertinoModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.white,
                              enableDrag: false,
                              builder: (context) {
                                return SelectChainWall(
                                  key: selectChainWallKey,
                                  isSavedChains: false,
                                );
                              });
                      if (_retrievedData != null) {
                        _selectedCategoryId =
                            _retrievedData["selectedCategoryId"];
                        homePageKey.currentState?.setState(() {});
                        if (!_retrievedData["wantToConduct"]) {
                          goToMakeChainPage();
                        }
                        ACWorkspace.saveCurrentChain();
                      }
                    },
                    child: Stack(
                      children: [
                        Icon(
                          Icons.label_important,
                          color: theme[settingData.selectedTheme]!
                              .categoryPanelColorInCollection,
                          size: 30,
                        ),
                        Icon(
                          Icons.label_important_outline,
                          color: theme[settingData.selectedTheme]!
                              .panelBorderColor,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
