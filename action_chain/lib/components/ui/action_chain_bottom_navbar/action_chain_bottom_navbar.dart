import 'package:flutter/material.dart';
import 'package:action_chain/model/ac_theme.dart';

class ActionChainBottomNavBar extends StatefulWidget {
  const ActionChainBottomNavBar({Key? key}) : super(key: key);

  @override
  State<ActionChainBottomNavBar> createState() =>
      _ActionChainBottomNavBarState();
}

class _ActionChainBottomNavBarState extends State<ActionChainBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final ACThemeData _acThemeData = ACTheme.of(context);
    return Positioned(
      bottom: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.6))
          ],
          gradient: _acThemeData.gradientOfNavBar,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 75 * MediaQuery.of(context).size.height / 896,
          child: const BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            shape: CircularNotchedRectangle(),
          ),
        ),
      ),
    );
  }
}
