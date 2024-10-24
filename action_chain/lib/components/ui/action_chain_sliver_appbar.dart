import 'package:flutter/material.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/user/setting_data.dart';

class ActionChainSliverAppBar extends StatelessWidget {
  final double? titleFontSize;
  final double? titleSpacing;
  final String pageTitle;
  final Function()? leadingButtonOnPressed;
  final Widget leadingIcon;
  final Function()? trailingButtonOnPressed;
  final Widget? trailingIcon;
  final List<Widget>? actions;
  const ActionChainSliverAppBar({
    Key? key,
    this.titleFontSize,
    this.titleSpacing,
    required this.pageTitle,
    required this.leadingButtonOnPressed,
    required this.leadingIcon,
    required this.trailingButtonOnPressed,
    required this.trailingIcon,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 5,
      expandedHeight: 110,
      pinned: true,
      centerTitle: true,
      forceElevated: true,

      // pro機能の画面に移動するボタン
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: GestureDetector(
            onTap: leadingButtonOnPressed,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: leadingIcon,
            )),
      ),
      // 設定画面に移動するボタン
      actions: actions ??
          [
            trailingIcon == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, right: 20),
                    child: GestureDetector(
                        onTap: trailingButtonOnPressed,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: trailingIcon!,
                        )),
                  ),
          ],

      // AppBarのデザイン
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: acTheme[settingData.selectedTheme]!.gradientOfNavBar,
        ),
        child: FlexibleSpaceBar(
          centerTitle: true,
          title: SizedBox(
            width: 250,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  pageTitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize ?? 20,
                      letterSpacing: titleSpacing ?? 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
