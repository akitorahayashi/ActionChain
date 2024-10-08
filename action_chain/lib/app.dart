import 'package:action_chain/model/external/ac_ads.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
// import 'package:action_chain/model/user/ac_user.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/loading_page.dart';
import 'package:action_chain/view/home_page/home_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

class ActionChainApp extends StatefulWidget {
  const ActionChainApp({Key? key}) : super(key: key);

  @override
  State<ActionChainApp> createState() => _ActionChainAppState();
}

class _ActionChainAppState extends State<ActionChainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Action Chain",
        theme: ThemeData(
            primarySwatch: theme[settingData.selectedTheme]!.accentColor),
        home: HomePage(key: homePageKey)
        // FutureBuilder(
        //   future: actionChainUser.initializeFirebase(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasError) {
        //       // スプラッシュ画面を閉じる
        //       FlutterNativeSplash.remove();
        //       return const LoadingPage(
        //         errorIsOccurred: true,
        //       );
        //     } else if (snapshot.hasData) {
        //       return HomePage(key: homePageKey);
        //     } else {
        //       return const LoadingPage(
        //         errorIsOccurred: false,
        //       );
        //     }
        //   },
        // ),
        );
  }
}
