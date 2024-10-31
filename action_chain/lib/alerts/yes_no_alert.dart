import 'package:flutter/material.dart';
import 'package:action_chain/model/ac_theme.dart';

Future<void> yesNoAlert(
    {required BuildContext context,
    required String title,
    required String? message,
    required Function()? yesAction}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final ACThemeData _acThemeData = ACTheme.of(context);
        return Dialog(
          backgroundColor: _acThemeData.alertColor,
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
                        color: _acThemeData.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                if (message != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      message,
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
      });
}
