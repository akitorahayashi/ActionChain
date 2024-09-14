import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/functions/launch_my_url.dart';
import 'package:flutter/material.dart';

class ButtonToDocs extends StatelessWidget {
  final String title;
  final String url;
  const ButtonToDocs({Key? key, required this.title, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 3, 10, 5),
      child: GestureDetector(
        onTap: () {
          launchMyUrl(
              context: context, url: url, shouldUseExternalApplication: false);
        },
        child: SizedBox(
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color:
                        theme[settingData.selectedTheme]!.tipsCardBorderColor),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: theme[settingData.selectedTheme]!
                                  .titleColorOfSettingPage,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
