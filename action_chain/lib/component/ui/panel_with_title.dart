import 'package:flutter/material.dart';
import 'package:action_chain/model/ac_theme.dart';

class PanelWithTitle extends StatelessWidget {
  final String title;
  final Widget content;
  const PanelWithTitle({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ACThemeData _acThemeData = ACTheme.of(context);
    return Card(
      color: _acThemeData.myPagePanelColor,
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
                        color: _acThemeData.titleColorOfSettingPage)),
              ),
            ),
            content,
          ],
        ),
      ),
    );
  }
}
