import 'package:flutter/material.dart';

class ActionChainTheme {
  final String themeName;
  // 基本色
  final MaterialColor accentColor;
  final Gradient gradientOfNavBar;
  final Color backgroundColor;
  final Color alertColor;
  final Color panelBorderColor;
  // ボタン
  final Color elevatedButtonColor;
  final Color pressedElevatedButtonColor;
  final Color borderColorOfControllIconButton;
  final Color textColorOfControllIconButton;
  final Color coloredControllButtonColor;
  // home
  final Color notifyLogInBonusBadgeColor;
  // take action
  final Color circleColor;
  final Color circleBackgroundColor;
  final Color checkmarkColor;
  final Color panelColor;
  // // keep
  // final Gradient chainWallBorderGradient;
  // collection
  final Color categoryPanelColorInCollection;
  // pro page
  final Color panelColorOfGetCoinWall;
  // settings
  final Color myPagePanelColor;
  final Color titleColorOfSettingPage;
  // nice apps
  final Color niceAppsCardColor;
  final Color niceAppsElevatedButtonColor;
  final Color niceAppsPressedElevatedButtonColor;
  // tips
  final Color tipsCardBorderColor;
  // my page
  final Color backupButtonBorderColor;
  final Color backupButtonTextColor;
  // reward
  final Color rewardButtonTitleColor;
  ActionChainTheme({
    required this.themeName,
    // 基本色
    required this.accentColor,
    required this.gradientOfNavBar,
    required this.backgroundColor,
    required this.alertColor,
    required this.panelBorderColor,
    // ボタン
    required this.elevatedButtonColor,
    required this.pressedElevatedButtonColor,
    required this.borderColorOfControllIconButton,
    required this.textColorOfControllIconButton,
    required this.coloredControllButtonColor,
    // home
    required this.notifyLogInBonusBadgeColor,
    // take action
    required this.circleColor,
    required this.circleBackgroundColor,
    required this.checkmarkColor,
    required this.panelColor,
    // collection
    required this.categoryPanelColorInCollection,
    // // keep
    // required this.chainWallBorderGradient,
    // pro page
    required this.panelColorOfGetCoinWall,
    // settings
    required this.myPagePanelColor,
    required this.titleColorOfSettingPage,
    // nice apps
    required this.niceAppsCardColor,
    required this.niceAppsElevatedButtonColor,
    required this.niceAppsPressedElevatedButtonColor,
    // tips
    required this.tipsCardBorderColor,
    // my page
    required this.backupButtonBorderColor,
    required this.backupButtonTextColor,
    // reward
    required this.rewardButtonTitleColor,
  });
}

List<ActionChainTheme> acTheme = [
  ActionChainTheme(
    themeName: "Sun Orange",
    // 基本色
    accentColor: Colors.orange,
    gradientOfNavBar: const LinearGradient(colors: [
      Color.fromRGBO(255, 163, 163, 1),
      Color.fromRGBO(255, 230, 87, 1),
    ]),
    backgroundColor: const Color.fromRGBO(255, 229, 214, 1),
    alertColor: const Color.fromRGBO(255, 251, 224, 1),
    panelBorderColor: const Color.fromRGBO(255, 192, 97, 1),
    // ボタン
    elevatedButtonColor: const Color.fromRGBO(255, 206, 92, 1),
    pressedElevatedButtonColor: const Color.fromRGBO(255, 224, 153, 1),
    borderColorOfControllIconButton: const Color.fromRGBO(255, 170, 117, 1),
    textColorOfControllIconButton: const Color.fromRGBO(255, 189, 102, 1),
    coloredControllButtonColor: const Color.fromRGBO(255, 247, 236, 1),
    // home
    notifyLogInBonusBadgeColor: const Color.fromRGBO(255, 154, 70, 1),
    // take action
    circleColor: Colors.orange,
    circleBackgroundColor: const Color.fromRGBO(255, 240, 204, 1),
    checkmarkColor: const Color.fromRGBO(255, 190, 86, 1),
    panelColor: const Color.fromRGBO(236, 255, 184, 1),
    // collection
    categoryPanelColorInCollection: const Color.fromRGBO(255, 246, 204, 1),
    // // keep
    // chainWallBorderGradient: const LinearGradient(
    //     begin: Alignment.topLeft,
    //     end: Alignment.bottomRight,
    //     colors: [
    //       Color.fromRGBO(255, 179, 107, 1),
    //       Color.fromRGBO(255, 161, 107, 1),
    //     ]),
    // pro page
    panelColorOfGetCoinWall: const Color.fromRGBO(235, 255, 179, 1),
    // settings
    myPagePanelColor: const Color.fromRGBO(255, 243, 184, 1),
    titleColorOfSettingPage: const Color.fromRGBO(170, 119, 80, 1),
    // nice apps
    niceAppsCardColor: const Color.fromRGBO(255, 192, 97, 1),
    niceAppsElevatedButtonColor: const Color.fromRGBO(255, 192, 97, 1),
    niceAppsPressedElevatedButtonColor: const Color.fromRGBO(255, 222, 173, 1),
    // tips
    tipsCardBorderColor: const Color.fromRGBO(255, 170, 117, 1),
    // my page
    backupButtonBorderColor: const Color.fromRGBO(255, 170, 117, 1),
    backupButtonTextColor: const Color.fromRGBO(255, 189, 102, 1),
    // reward
    rewardButtonTitleColor: const Color.fromRGBO(255, 190, 86, 1),
  ),
  ActionChainTheme(
    themeName: "Lime Green",
    // 基本色
    accentColor: Colors.lightGreen,
    gradientOfNavBar: const LinearGradient(colors: [
      Color.fromRGBO(73, 194, 70, 1),
      Color.fromRGBO(143, 250, 56, 1),
    ]),
    backgroundColor: const Color.fromRGBO(239, 255, 214, 1),
    alertColor: const Color.fromRGBO(255, 255, 209, 1),
    panelBorderColor: const Color.fromRGBO(225, 163, 102, 1),
    // ボタン
    elevatedButtonColor: const Color.fromRGBO(138, 231, 101, 1),
    pressedElevatedButtonColor: const Color.fromRGBO(195, 243, 176, 1),
    borderColorOfControllIconButton: const Color.fromRGBO(225, 163, 102, 1),
    textColorOfControllIconButton: Colors.lightGreen.withOpacity(0.8),
    coloredControllButtonColor: const Color.fromRGBO(241, 248, 233, 1),
    // home
    notifyLogInBonusBadgeColor: const Color.fromRGBO(255, 243, 10, 1),
    // take action
    circleColor: const Color.fromRGBO(111, 226, 80, 1),
    circleBackgroundColor: const Color.fromRGBO(255, 253, 184, 1),
    checkmarkColor: const Color.fromRGBO(123, 212, 28, 1),
    panelColor: const Color.fromRGBO(255, 253, 184, 1),
    // // keep
    // chainWallBorderGradient: const LinearGradient(
    //     begin: Alignment.topLeft,
    //     end: Alignment.bottomRight,
    //     colors: [
    //       Color.fromRGBO(220, 161, 127, 1),
    //       Color.fromRGBO(204, 146, 112, 1),
    //     ]),
    // collection
    categoryPanelColorInCollection: const Color.fromRGBO(255, 246, 204, 1),
    // pro page
    panelColorOfGetCoinWall: const Color.fromRGBO(255, 253, 184, 1),
    // settings
    myPagePanelColor: const Color.fromRGBO(223, 168, 139, 1),
    titleColorOfSettingPage: const Color.fromRGBO(130, 81, 43, 1),
    // nice apps
    niceAppsCardColor: const Color.fromRGBO(225, 163, 102, 1),
    niceAppsElevatedButtonColor: const Color.fromRGBO(138, 231, 101, 1),
    niceAppsPressedElevatedButtonColor: const Color.fromRGBO(195, 243, 176, 1),
    // tips
    tipsCardBorderColor: const Color.fromRGBO(166, 238, 114, 1),
    // my page
    backupButtonBorderColor: const Color.fromRGBO(225, 163, 102, 1),
    backupButtonTextColor: Colors.lightGreen.withOpacity(0.8),
    // reward
    rewardButtonTitleColor: const Color.fromRGBO(123, 205, 60, 1),
  ),
  ActionChainTheme(
    themeName: "Marine Blue",
    // 基本色
    accentColor: Colors.cyan,
    gradientOfNavBar: const LinearGradient(colors: [
      Color.fromRGBO(131, 169, 252, 1),
      Color.fromRGBO(144, 242, 249, 1),
    ]),
    backgroundColor: const Color.fromRGBO(241, 251, 253, 1),
    alertColor: const Color.fromRGBO(240, 248, 255, 1),
    panelBorderColor: const Color.fromRGBO(163, 218, 255, 1),
    // ボタン
    elevatedButtonColor: const Color.fromRGBO(106, 218, 246, 1),
    pressedElevatedButtonColor: const Color.fromRGBO(163, 232, 250, 1),
    borderColorOfControllIconButton: const Color.fromRGBO(113, 199, 249, 1),
    textColorOfControllIconButton: const Color.fromRGBO(90, 209, 242, 1),
    coloredControllButtonColor: const Color.fromRGBO(235, 249, 252, 1),
    // home
    notifyLogInBonusBadgeColor: const Color.fromRGBO(122, 167, 245, 1),
    // take action
    circleColor: const Color.fromRGBO(93, 218, 249, 1),
    circleBackgroundColor: const Color.fromRGBO(209, 250, 255, 1),
    checkmarkColor: const Color.fromRGBO(66, 183, 255, 1),
    panelColor: const Color.fromRGBO(214, 252, 255, 1),
    // collection
    categoryPanelColorInCollection: const Color.fromRGBO(214, 254, 255, 1),
    // // keep
    // chainWallBorderGradient: const LinearGradient(
    //     begin: Alignment.topLeft,
    //     end: Alignment.bottomRight,
    //     colors: [
    //       Color.fromRGBO(133, 216, 255, 1),
    //       Color.fromRGBO(107, 166, 255, 1),
    //     ]),
    // pro page
    panelColorOfGetCoinWall: const Color.fromRGBO(219, 248, 255, 1),
    // settings
    myPagePanelColor: const Color.fromRGBO(219, 248, 255, 1),
    titleColorOfSettingPage: Colors.cyan,
    // nice apps
    niceAppsCardColor: const Color.fromRGBO(129, 221, 234, 1),
    niceAppsElevatedButtonColor: const Color.fromRGBO(89, 211, 227, 1),
    niceAppsPressedElevatedButtonColor: const Color.fromRGBO(163, 231, 239, 1),
    // tips
    tipsCardBorderColor: const Color.fromRGBO(163, 218, 255, 1),
    // my page
    backupButtonBorderColor: const Color.fromRGBO(113, 199, 249, 1),
    backupButtonTextColor: const Color.fromRGBO(90, 209, 242, 1),
    // reward
    rewardButtonTitleColor: Colors.cyan,
  )
];
