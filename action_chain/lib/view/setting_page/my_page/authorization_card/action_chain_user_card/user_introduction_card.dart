import 'package:action_chain/view/setting_page/my_page/authorization_card/action_chain_user_card/backup_contents/backup_content_block.dart';
import 'package:action_chain/view/setting_page/my_page/authorization_card/action_chain_user_card/backup_contents/backup_content_button.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/alerts/yes_no_alert.dart';
import 'package:action_chain/functions/launch_my_url.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/user/ac_user.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class UserIntroductionCard extends StatelessWidget {
  const UserIntroductionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double buttonSpacing = 12;
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 20.0),
          child: Column(
            children: [
              if (actionChainUser.accontSignedInWithGoogle != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // さん、こんにちは
                    Text(
                      "${actionChainUser.accontSignedInWithGoogle!.displayName}さん、こんにちは!",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(0.4)),
                    ), // アイコン
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: 75,
                              height: 75,
                              child: Container(
                                  color: theme[settingData.selectedTheme]!
                                      .backupButtonTextColor),
                            ),
                          ),
                          CachedNetworkImage(
                            imageUrl: actionChainUser
                                .accontSignedInWithGoogle!.photoUrl!,
                            imageBuilder: (context, imageProvider) {
                              return Card(
                                color: Colors.white,
                                shape: const StadiumBorder(),
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: imageProvider)),
                                  ),
                                ),
                              );
                            },
                            placeholder: (context, url) => Container(),
                            errorWidget: (context, url, error) => Card(
                              color: Colors.white,
                              shape: const StadiumBorder(),
                              child: SizedBox(
                                height: 70,
                                width: 70,
                                child: Icon(
                                  Icons.account_circle_outlined,
                                  size: 70,
                                  color: Colors.black.withOpacity(0.32),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // welcome
                    Column(
                      children: [
                        // welcome to
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Text(
                            "Welcome to Action Chain!",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 22.5,
                                color: theme[settingData.selectedTheme]!
                                    .backupButtonTextColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              // importとexport
              BackupContentBlock(title: "バックアップ", buttons: [
                BackupContentButton(
                  iconData: Icons.file_download,
                  buttonName: "Import",
                  onPressed: () => yesNoAlert(
                      context: context,
                      title: "本当によろしいですか?",
                      message: "今の端末のデータが完全に事前に制作したバックアップに置き換わります",
                      yesAction: () {
                        Navigator.pop(context);
                        actionChainUser.importFromGoogleDrive(
                            context: context, justWantInformation: false);
                      }),
                ),
                const SizedBox(width: buttonSpacing),
                BackupContentButton(
                    iconData: Icons.file_upload,
                    onPressed: () => actionChainUser.askTobackUpToGoogleDrive(
                        superContext: context),
                    buttonName: "Export"),
              ]),
              // 削除とInfoボタン
              BackupContentBlock(title: "チェック", buttons: [
                BackupContentButton(
                  iconData: Icons.delete_outline,
                  buttonName: "Delete",
                  onPressed: () => yesNoAlert(
                      context: context,
                      title: "バックアップを\n削除しますか?",
                      message:
                          "Google Driveに保存されている\n今のアプリのバックアップを\n削除することができます",
                      yesAction: () {
                        Navigator.pop(context);
                        actionChainUser.deleteGoogleDriveFiles(
                            context: context);
                      }),
                ),
                const SizedBox(width: buttonSpacing),
                BackupContentButton(
                  iconData: Icons.info_outline,
                  buttonName: "Info",
                  onPressed: () => yesNoAlert(
                      context: context,
                      title: "バックアップの確認",
                      message: "現在保存されているバックアップの情報を確認しますか？",
                      yesAction: () {
                        Navigator.pop(context);
                        actionChainUser.importFromGoogleDrive(
                            context: context, justWantInformation: true);
                      }),
                ),
              ]),
              // googleアカウントとサインアウト
              BackupContentBlock(title: "アカウント", buttons: [
                BackupContentButton(
                  iconData: Icons.account_circle_outlined,
                  buttonName: "Google",
                  onPressed: () => launchMyUrl(
                      context: context,
                      url:
                          "https://accounts.google.com/ServiceLogin?service=accountsettings&continue=https://myaccount.google.com%3Futm_source%3Daccount-marketing-page%26utm_medium%3Dgo-to-account-button",
                      shouldUseExternalApplication: true),
                ),
                const SizedBox(width: buttonSpacing),
                BackupContentButton(
                  iconData: Icons.logout,
                  buttonName: "Sign out",
                  onPressed: () => actionChainUser.signOut(
                      superKey: settingPageKey, context: context, isWeb: false),
                ),
              ]),
            ],
          ),
        ));
  }
}
