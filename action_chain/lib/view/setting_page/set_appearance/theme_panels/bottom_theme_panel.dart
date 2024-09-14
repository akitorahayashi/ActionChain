import 'package:flutter/material.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/user/setting_data.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class BottomThemePanel extends StatelessWidget {
  final String themeName;
  const BottomThemePanel({Key? key, required this.themeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: GestureDetector(
        onTap: () {
          settingData.confirmToChangeTheme(
              context: context, themeName: themeName);
        },
        child: SizedBox(
          width: deviceWidth - 50,
          height: 90,
          // グラデーションと丸角
          child: DecoratedBox(
            decoration: BoxDecoration(
                gradient: theme[themeName]!.gradientOfNavBar,
                borderRadius: BorderRadius.circular(10)),
            // ガラス
            child: GlassContainer(
              // カードを中央に配置
              child: Align(
                alignment: Alignment.center,
                // toDoカードを表示
                child: SizedBox(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      // 色
                      color: theme[themeName]!.panelColor,
                      // 浮き具合
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18, right: 8.0),
                            child: Icon(
                              FontAwesomeIcons.square,
                              color: theme[themeName]!.checkmarkColor,
                            ),
                          ),
                          Text(
                            themeName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: theme[themeName]!.checkmarkColor,
                                fontSize: 20,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w800),
                          ),
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
