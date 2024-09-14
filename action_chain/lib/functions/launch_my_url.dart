import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

const String termsOfUseUrl =
    "https://akinoki.blogspot.com/2022/03/terms-of-service.html";
const String privacyPolicyUrl =
    "https://akinoki.blogspot.com/2022/03/privacy-policy.html";

void launchMyUrl(
    {required BuildContext context,
    required String url,
    required bool shouldUseExternalApplication}) async {
  final Uri selectedUrl = Uri.parse(url);
  try {
    if (await canLaunchUrl(selectedUrl)) {
      launchUrl(
        selectedUrl,
        mode: shouldUseExternalApplication
            ? LaunchMode.externalApplication
            : LaunchMode.inAppWebView,
      );
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Align(
                  alignment: Alignment.center, child: Text("すみません")),
              content: const Align(
                  heightFactor: 0.8,
                  alignment: Alignment.center,
                  child: Text("urlの問題により\n現在は使用できません")),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("いいってことよ"))
              ],
            );
          });
    }
  } catch (e) {
    print(e);
  }
}
