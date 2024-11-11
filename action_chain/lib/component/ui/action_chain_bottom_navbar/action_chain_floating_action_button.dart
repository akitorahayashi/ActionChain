import 'package:flutter/material.dart';
import 'package:action_chain/model/ac_theme.dart';

class ActionChainFloatingActionButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget? child;
  const ActionChainFloatingActionButton(
      {Key? key, required this.onPressed, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ACThemeData _acThemeData = ACTheme.of(context);
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
                      color: _acThemeData.categoryPanelColorInCollection,
                      elevation: 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: _acThemeData.panelBorderColor,
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
                      color: _acThemeData.categoryPanelColorInCollection,
                      elevation: 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: _acThemeData.panelBorderColor,
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
            overlayColor: WidgetStateProperty.resolveWith(
                (states) => _acThemeData.accentColor.withOpacity(0.05)),
          ),
        ),
      ),
    );
  }
}
