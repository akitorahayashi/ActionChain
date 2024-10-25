import 'package:flutter/material.dart';
import 'package:action_chain/model/ac_theme.dart';
import 'package:action_chain/model/user/setting_data.dart';

class BackupContentButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData iconData;
  final String buttonName;
  const BackupContentButton(
      {Key? key,
      required this.onPressed,
      required this.iconData,
      required this.buttonName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: acThemeDataList[SettingData.shared.selectedThemeIndex]
          .backupButtonBorderColor,
      child: SizedBox(
        width: 156,
        height: 70,
        child: Card(
          child: InkWell(
            highlightColor:
                acThemeDataList[SettingData.shared.selectedThemeIndex]
                    .backupButtonTextColor
                    .withOpacity(0.05),
            splashColor: acThemeDataList[SettingData.shared.selectedThemeIndex]
                .backupButtonTextColor
                .withOpacity(0.1),
            onTap: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.5),
                  child: Icon(
                    iconData,
                    color:
                        acThemeDataList[SettingData.shared.selectedThemeIndex]
                            .backupButtonTextColor,
                  ),
                ),
                Text(
                  buttonName,
                  style: TextStyle(
                      color:
                          acThemeDataList[SettingData.shared.selectedThemeIndex]
                              .backupButtonTextColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
