import 'package:action_chain/model/ac_theme.dart';
import 'package:flutter/material.dart';

class ACSingleOptionDialog extends StatelessWidget {
  final String title;
  final String? message;
  ACSingleOptionDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final ACThemeData acThemeData = ACTheme.of(context);
    return Dialog(
      backgroundColor: acThemeData.alertColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          ),
        ),
      ),
    );
  }
}
