import 'package:action_chain/model/ac_theme.dart';
import 'package:flutter/material.dart';

class ActionChainElevatedButton extends StatelessWidget {
  final Function()? onPressed;
  final String textContent;
  const ActionChainElevatedButton(
      {Key? key, required this.onPressed, required this.textContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ACThemeData _acThemeData = ACTheme.of(context);
    return SizedBox(
      width: 120,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor:
              WidgetStateProperty.all(_acThemeData.pressedElevatedButtonColor),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return const Color.fromRGBO(220, 220, 220, 1);
              }
              return _acThemeData.elevatedButtonColor;
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
          elevation: WidgetStateProperty.resolveWith<double>(
            (Set<WidgetState> states) {
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
