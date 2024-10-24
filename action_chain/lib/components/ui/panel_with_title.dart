import 'package:flutter/material.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/user/setting_data.dart';

class PanelWithTitle extends StatelessWidget {
  final String title;
  final Widget content;
  const PanelWithTitle({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: acTheme[SettingData.shared.selectedThemeIndex].myPagePanelColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 12, 5, 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 3, 0, 3),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                        color: acTheme[SettingData.shared.selectedThemeIndex]
                            .titleColorOfSettingPage)),
              ),
            ),
            content,
          ],
        ),
      ),
    );
  }
}
