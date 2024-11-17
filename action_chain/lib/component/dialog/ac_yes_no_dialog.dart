import 'package:action_chain/model/ac_theme.dart';
import 'package:flutter/material.dart';

class ACYesNoDialog extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback yesAction;
  const ACYesNoDialog({
    super.key,
    required this.title,
    this.message,
    required this.yesAction,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String? message,
    required VoidCallback yesAction,
  }) async {
    return showDialog(
        context: context,
        builder: (context) {
          return ACYesNoDialog(
              title: title, message: message, yesAction: yesAction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final ACThemeData acThemeData = ACTheme.of(context);
    return Dialog(
      backgroundColor: acThemeData.alertColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16),
              child: Text(
                title,
                style: TextStyle(
                    color: acThemeData.accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  message!,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (message == null)
              const SizedBox(
                height: 30,
              ),
            OverflowBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("いいえ")),
                TextButton(onPressed: yesAction, child: const Text("はい")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
