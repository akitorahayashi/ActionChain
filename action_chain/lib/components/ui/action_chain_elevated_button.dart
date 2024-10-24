import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';

class ActionChainElevatedButton extends StatelessWidget {
  final Function()? onPressed;
  final String textContent;
  const ActionChainElevatedButton(
      {Key? key, required this.onPressed, required this.textContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(
              acTheme[settingData.selectedTheme]!.pressedElevatedButtonColor),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return const Color.fromRGBO(220, 220, 220, 1);
              }
              return acTheme[settingData.selectedTheme]!.elevatedButtonColor;
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              return 2;
            },
          ),
        ),
        child: Text(
          textContent,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 20,
              letterSpacing: 2),
        ),
      ),
    );
  }
}
