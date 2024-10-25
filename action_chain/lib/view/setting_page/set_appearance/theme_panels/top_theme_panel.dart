import 'package:action_chain/constants/icons_for_checkbox.dart';
import 'package:action_chain/view/home_page/method_completion_indicator/background_of_circularindicator_painter.dart';
import 'package:flutter/material.dart';
import 'package:action_chain/model/ac_theme.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class TopThemePanel extends StatelessWidget {
  const TopThemePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: deviceWidth - 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: acThemeDataList[SettingData.shared.selectedThemeIndex]
                  .gradientOfNavBar,
              borderRadius: BorderRadius.circular(10)),
          // ガラス
          child: GlassContainer(
            // カードを中央に配置
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Align(
                alignment: Alignment.center,
                // カードを表示
                child: Card(
                  // 色
                  color: acThemeDataList[SettingData.shared.selectedThemeIndex]
                      .panelColor,
                  // 浮き具合
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: deviceWidth - 78,
                            height: deviceWidth - 78,
                            child: CustomPaint(
                              painter: BackgroundOfCircularIndicatorPainter(),
                            ),
                          ),
                          // 中央の円
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1),
                            duration: const Duration(milliseconds: 300),
                            builder: (context, value, _) => SizedBox(
                              width: deviceWidth - 145,
                              height: deviceWidth - 145,
                              child: CircularProgressIndicator(
                                  color: acThemeDataList[
                                          SettingData.shared.selectedThemeIndex]
                                      .circleColor,
                                  strokeWidth: 10,
                                  value: value),
                            ),
                          ),
                          // 文字
                          SizedBox(
                            width: 170,
                            height: 80,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      FontAwesomeIcons.solidSquareCheck,
                                      color: acThemeDataList[SettingData
                                              .shared.selectedThemeIndex]
                                          .checkmarkColor,
                                      size: 22,
                                    ),
                                  ),
                                  Text(
                                    acThemeDataList[SettingData
                                            .shared.selectedThemeIndex]
                                        .themeName,
                                    style: TextStyle(
                                        color: acThemeDataList[SettingData
                                                .shared.selectedThemeIndex]
                                            .checkmarkColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 22),
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
