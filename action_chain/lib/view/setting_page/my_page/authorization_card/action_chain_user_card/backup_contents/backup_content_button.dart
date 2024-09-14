import 'package:flutter/material.dart';
import 'package:action_chain/constants/theme.dart';
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
      color: theme[settingData.selectedTheme]!.backupButtonBorderColor,
      child: SizedBox(
        width: 156,
        height: 70,
        child: Card(
          child: InkWell(
            highlightColor: theme[settingData.selectedTheme]!
                .backupButtonTextColor
                .withOpacity(0.05),
            splashColor: theme[settingData.selectedTheme]!
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
                        theme[settingData.selectedTheme]!.backupButtonTextColor,
                  ),
                ),
                Text(
                  buttonName,
                  style: TextStyle(
                      color: theme[settingData.selectedTheme]!
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
