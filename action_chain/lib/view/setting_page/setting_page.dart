import 'package:action_chain/components/ui/action_chain_sliver_appbar.dart';
import 'package:action_chain/model/user/ac_user.dart';
import 'package:action_chain/view/setting_page/set_appearance/set_appearance_page.dart';
import 'package:action_chain/view/setting_page/my_page/my_page.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({required Key key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
// ページ遷移系のメンバー
  int _selectedPageIndex = 1;
  final PageController _pageControllerInSettingPage =
      PageController(initialPage: 1);
  final List<Widget> _contentsInSettingPage = [
    MyPage(key: myPageKey),
    SetAppearancePage(key: setAppearancePageKey),
    // const AkiPage(),
  ];
  final List<dynamic> _iconDataOfSettingPageContents = [
    [Icons.account_circle_outlined, "My Page"],
    [Icons.phone_android, "Appearance"],
    // [Icons.construction, "Aki Page"],
  ];
// --- ページ遷移系のメンバー

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      barrierEnabled: true,
      indicatorColor: Colors.white,
      textStyle: const TextStyle(
          color: Colors.white, fontSize: 16, decoration: TextDecoration.none),
      child: Scaffold(
        // コンテンツの表示
        body: Stack(
          children: [
            // 背景色
            Container(
                decoration: BoxDecoration(
                    color: theme[settingData.selectedTheme]!.backgroundColor),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height),
            NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  ActionChainSliverAppBar(
                      pageTitle: "Settings",
                      leadingButtonOnPressed: () {
                        Navigator.pop(context);
                      },
                      leadingIcon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      trailingButtonOnPressed: null,
                      trailingIcon: null),
                ];
              },
              body: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageControllerInSettingPage,
                itemBuilder: (context, index) {
                  return _contentsInSettingPage[index];
                },
                itemCount: _contentsInSettingPage.length,
              ),
            ),
            // bottom navbar
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: (100 * MediaQuery.of(context).size.height / 896),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black45, blurRadius: 8)
                    ]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int index = 0;
                          index < _contentsInSettingPage.length;
                          index++)
                        GestureDetector(
                          onTap: () {
                            if (_selectedPageIndex != index) {
                              _selectedPageIndex = index;
                              _pageControllerInSettingPage.animateToPage(
                                _selectedPageIndex,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.decelerate,
                              );
                              setState(() {});
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // アイコンを表示
                              (() {
                                switch (index) {
                                  case 0:
                                    if (actionChainUser
                                            .accontSignedInWithGoogle ==
                                        null) {
                                      return Icon(
                                        _iconDataOfSettingPageContents[index]
                                            [0],
                                        color: index == _selectedPageIndex
                                            ? theme[settingData.selectedTheme]!
                                                .accentColor
                                            : Colors.black45,
                                      );
                                    } else {
                                      return CachedNetworkImage(
                                        imageUrl: actionChainUser
                                            .accontSignedInWithGoogle!
                                            .photoUrl!,
                                        imageBuilder: (context, imageProvider) {
                                          return SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    width: 1.5,
                                                    color: _selectedPageIndex ==
                                                            0
                                                        ? theme[settingData
                                                                .selectedTheme]!
                                                            .accentColor
                                                            .withOpacity(1)
                                                        : Colors.white
                                                            .withOpacity(.8),
                                                  ),
                                                  image: DecorationImage(
                                                      fit: BoxFit.contain,
                                                      image: imageProvider)),
                                            ),
                                          );
                                        },
                                        placeholder: (context, url) =>
                                            Container(),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.account_circle_outlined,
                                          color: index == _selectedPageIndex
                                              ? theme[settingData
                                                      .selectedTheme]!
                                                  .accentColor
                                              : Colors.black45,
                                        ),
                                      );
                                    }
                                  case 2:
                                    return SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 1.5,
                                              color: _selectedPageIndex == 2
                                                  ? theme[settingData
                                                          .selectedTheme]!
                                                      .accentColor
                                                      .withOpacity(1)
                                                  : Colors.white
                                                      .withOpacity(.8),
                                            ),
                                            image: const DecorationImage(
                                                fit: BoxFit.contain,
                                                image: AssetImage(
                                                    "assets/aki_icon.png"))),
                                      ),
                                    );
                                  default:
                                    return Icon(
                                      _iconDataOfSettingPageContents[index][0],
                                      color: index == _selectedPageIndex
                                          ? theme[settingData.selectedTheme]!
                                              .accentColor
                                          : Colors.black45,
                                    );
                                }
                              }()),
                              Padding(
                                padding: const EdgeInsets.only(top: 11.0),
                                child: Text(
                                  _iconDataOfSettingPageContents[index][1],
                                  style: TextStyle(
                                    color: index == _selectedPageIndex
                                        ? theme[settingData.selectedTheme]!
                                            .accentColor
                                        : Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
