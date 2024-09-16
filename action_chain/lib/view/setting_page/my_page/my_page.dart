import 'package:action_chain/view/setting_page/my_page/authorization_card/sign_in_card.dart';
import 'package:action_chain/view/setting_page/my_page/authorization_card/action_chain_user_card/user_introduction_card.dart';
import 'package:action_chain/view/setting_page/my_page/tips_page/select_tips_panel.dart';
import 'package:action_chain/model/user/ac_user.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({required Key key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 10),
        // ignore: prefer_const_constructors
        Card(
          color: theme[settingData.selectedTheme]!.myPagePanelColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 600),
              crossFadeState: actionChainUser.accontSignedInWithGoogle == null
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              // ignore: prefer_const_constructors
              firstChild: SignInCard(),
              // ignore: prefer_const_constructors
              secondChild: UserIntroductionCard()),
        ),
        // ignore: prefer_const_constructors
        SelectTipsPanel(),
        const SizedBox(height: 250)
      ],
    );
  }
}
