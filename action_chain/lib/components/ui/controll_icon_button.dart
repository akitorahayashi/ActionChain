import 'package:flutter/material.dart';
import 'package:action_chain/model/ac_theme.dart';

class ControllIconButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData iconData;
  final double? iconSize;
  final bool? buttonIsColored;
  final String textContent;
  const ControllIconButton(
      {Key? key,
      required this.onPressed,
      required this.iconData,
      this.iconSize,
      this.buttonIsColored,
      required this.textContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ACThemeData _acThemeData = ACTheme.of(context);
    return SizedBox(
      width: 80,
      height: 90,
      child: Card(
        color: onPressed == null
            ? const Color.fromRGBO(200, 200, 200, 1)
            : _acThemeData.borderColorOfControllIconButton,
        child: Card(
          // ループのため
          color: buttonIsColored == null
              ? null
              : (buttonIsColored!
                  ? _acThemeData.coloredControllButtonColor
                  : null),
          child: InkWell(
            onTap: onPressed,
            splashColor: buttonIsColored != null
                ? Colors.transparent
                : _acThemeData.textColorOfControllIconButton.withOpacity(0.12),
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Icon(
                    iconData,
                    color: onPressed == null
                        ? const Color.fromRGBO(200, 200, 200, 1)
                        : _acThemeData.backupButtonTextColor,
                    size: iconSize ?? 28,
                  ),
                ),
                Text(
                  textContent,
                  style: TextStyle(
                      color: onPressed == null
                          ? const Color.fromRGBO(200, 200, 200, 1)
                          : _acThemeData.textColorOfControllIconButton,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
