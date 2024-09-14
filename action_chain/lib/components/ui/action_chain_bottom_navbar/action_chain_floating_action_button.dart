import 'package:flutter/material.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/user/setting_data.dart';

class ActionChainFloatingActionButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget? child;
  const ActionChainFloatingActionButton(
      {Key? key, required this.onPressed, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black26, width: 2),
          shape: BoxShape.circle),
      child: ClipOval(
        child: TextButton(
          onPressed: onPressed,
          child: child ??
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, top: 4),
                    child: Card(
                      color: theme[settingData.selectedTheme]!
                          .categoryPanelColorInCollection,
                      elevation: 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: theme[settingData.selectedTheme]!
                                    .panelBorderColor,
                                width: 2)),
                        child: const SizedBox(
                          width: 25,
                          height: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0, bottom: 4),
                    child: Card(
                      color: theme[settingData.selectedTheme]!
                          .categoryPanelColorInCollection,
                      elevation: 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: theme[settingData.selectedTheme]!
                                    .panelBorderColor,
                                width: 2)),
                        child: const SizedBox(
                          width: 25,
                          height: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith((states) =>
                theme[settingData.selectedTheme]!
                    .accentColor
                    .withOpacity(0.05)),
          ),
        ),
      ),
    );
  }
}
