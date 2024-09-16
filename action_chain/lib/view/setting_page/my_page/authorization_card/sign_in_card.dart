import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/functions/launch_my_url.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/user/ac_user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInCard extends StatefulWidget {
  const SignInCard({Key? key}) : super(key: key);

  @override
  State<SignInCard> createState() => _SignInCardState();
}

class _SignInCardState extends State<SignInCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // back up
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
              child: Align(
                child: Text(
                  "Back Up",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: theme[settingData.selectedTheme]!
                          .accentColor
                          .withOpacity(0.8)),
                ),
              ),
            ),
            // サインインするメリット
            Padding(
              padding: const EdgeInsets.only(left: 24.0, bottom: 8.0),
              child: Text(
                "さらに安全に",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1,
                    color: theme[settingData.selectedTheme]!.accentColor),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                  "・バックアップを取ることで機種変更時にデータを移し替えることが可能になります!\n\n・また、不具合などでクラッシュしてもデータを復旧することができる可能性があります"),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 24.0, top: 16.0, bottom: 8.0),
              child: Text(
                "  さらに柔軟に",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: theme[settingData.selectedTheme]!.accentColor),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                  "・同じGoogleアカウントでサインインした他のデバイスでも閲覧、編集できるようになります!\n\n※AkiのアプリではGoogle Driveを使用してバックアップを行います"),
            ),
            // サインインのボタン
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 3.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    // await actionChainUser.signInWithGoogle(
                    //     context: context, isWeb: false);
                    // setState(() {});
                  },
                  child: Card(
                    shape: const StadiumBorder(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Icon(
                              FontAwesomeIcons.square,
                              color: theme[settingData.selectedTheme]!
                                  .accentColor
                                  .withOpacity(0.84),
                            ),
                          ),
                          Text(
                            "Sign in with Google",
                            style: TextStyle(
                                color: theme[settingData.selectedTheme]!
                                    .accentColor
                                    .withOpacity(0.84),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // googleアカウントを新しく作る
            Align(
              alignment: Alignment.center,
              child: DefaultTextStyle(
                style: TextStyle(
                    fontSize: 13, color: Colors.black.withOpacity(0.8)),
                child: Text.rich(
                  TextSpan(children: [
                    const TextSpan(text: "Googleアカウントをお持ちでないですか?  "),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchMyUrl(
                              context: context,
                              url:
                                  "https://accounts.google.com/signup/v2/webcreateaccount?flowName=GlifWebSignIn&flowEntry=SignUp",
                              shouldUseExternalApplication: true),
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        text: "新しく作る")
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
