import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final List<String> fontawesomeCategories = ["Default"];

Widget getIcon({required bool isChecked, Color? iconColor, double? iconSize}) {
  // このカテゴリーで指定されたアイコンがない場合、デフォルトのものを使う
  IconForCheckBox thisIconData = (() {
    // 指定したアイコンがなければ、チェックボックスを使う
    if (iconsForCheckBox[settingData.defaultIconCategory] != null &&
        iconsForCheckBox[settingData.defaultIconCategory]![
                settingData.iconRarity] !=
            null &&
        iconsForCheckBox[settingData.defaultIconCategory]![
                settingData.iconRarity]![settingData.defaultIconName] !=
            null) {
      return iconsForCheckBox[settingData.defaultIconCategory]![
          settingData.iconRarity]![settingData.defaultIconName]!;
    } else {
      return iconsForCheckBox["Default"]!["Common"]!["box"]!;
    }
  }());
  return Icon(
    isChecked ? thisIconData.checkedIcon : thisIconData.notCheckedIcon,
    color: iconColor ??
        (isChecked
            ? acTheme[settingData.selectedThemeIndex].checkmarkColor
            : Colors.black.withOpacity(0.56)),
    size: iconSize ??
        (fontawesomeCategories.contains(settingData.defaultIconCategory)
            ? 17
            : 19),
  );
}

class IconForCheckBox {
  final IconData checkedIcon;
  final IconData notCheckedIcon;

  // コンストラクタ
  IconForCheckBox({
    required this.checkedIcon,
    required this.notCheckedIcon,
  });
}

// カテゴリー, レア度, 名前
Map<String, Map<String, Map<String, IconForCheckBox>>> iconsForCheckBox = {
  "Default": {
    "Super Rare": {},
    "Rare": {},
    "Common": {
      "box": IconForCheckBox(
          checkedIcon: FontAwesomeIcons.solidSquareCheck,
          notCheckedIcon: FontAwesomeIcons.square),
      "circle": IconForCheckBox(
          checkedIcon: FontAwesomeIcons.solidCircleCheck,
          notCheckedIcon: FontAwesomeIcons.circle)
    }
  },
  "Nature": {
    "Super Rare": {
      "water": IconForCheckBox(
          checkedIcon: Icons.water_drop,
          notCheckedIcon: Icons.water_drop_outlined),
      "sun": IconForCheckBox(
          checkedIcon: Icons.brightness_7, notCheckedIcon: Icons.brightness_5),
    },
    "Rare": {
      "star": IconForCheckBox(
          checkedIcon: Icons.star, notCheckedIcon: Icons.star_border),
      "fire": IconForCheckBox(
          checkedIcon: Icons.whatshot, notCheckedIcon: Icons.whatshot),
      "flower": IconForCheckBox(
          checkedIcon: Icons.local_florist,
          notCheckedIcon: Icons.local_florist_outlined),
    },
    "Common": {
      "tree": IconForCheckBox(
          checkedIcon: Icons.park, notCheckedIcon: Icons.park_outlined),
      "hill": IconForCheckBox(
          checkedIcon: Icons.terrain, notCheckedIcon: Icons.terrain_outlined),
      "moon": IconForCheckBox(
          checkedIcon: Icons.dark_mode,
          notCheckedIcon: Icons.dark_mode_outlined),
      "earth": IconForCheckBox(
          checkedIcon: Icons.public, notCheckedIcon: Icons.public_outlined),
      "insects": IconForCheckBox(
          checkedIcon: Icons.emoji_nature,
          notCheckedIcon: Icons.emoji_nature_outlined),
    }
  },
  "Building": {
    "Super Rare": {
      "mosque": IconForCheckBox(
          checkedIcon: Icons.mosque, notCheckedIcon: Icons.handyman),
      "city": IconForCheckBox(
          checkedIcon: Icons.location_city, notCheckedIcon: Icons.handyman),
    },
    "Rare": {
      "temple": IconForCheckBox(
          checkedIcon: Icons.temple_buddhist, notCheckedIcon: Icons.handyman),
      "tower": IconForCheckBox(
          checkedIcon: Icons.temple_hindu, notCheckedIcon: Icons.handyman),
      "church": IconForCheckBox(
          checkedIcon: Icons.synagogue, notCheckedIcon: Icons.handyman),
    },
    "Common": {
      "castle": IconForCheckBox(
          checkedIcon: Icons.castle, notCheckedIcon: Icons.handyman),
      "fort": IconForCheckBox(
          checkedIcon: Icons.fort, notCheckedIcon: Icons.handyman),
      "festival": IconForCheckBox(
          checkedIcon: Icons.festival, notCheckedIcon: Icons.handyman),
      "factory": IconForCheckBox(
          checkedIcon: Icons.factory, notCheckedIcon: Icons.handyman),
      "store": IconForCheckBox(
          checkedIcon: Icons.apartment, notCheckedIcon: Icons.handyman),
    }
  },
  "Game": {
    "Super Rare": {
      "rocket": IconForCheckBox(
          checkedIcon: Icons.rocket_launch,
          notCheckedIcon: Icons.rocket_outlined),
      "core": IconForCheckBox(
          checkedIcon: Icons.token, notCheckedIcon: Icons.token_outlined),
    },
    "Rare": {
      "bell": IconForCheckBox(
          checkedIcon: Icons.notifications_active,
          notCheckedIcon: Icons.notifications_outlined),
      "ar": IconForCheckBox(
          checkedIcon: Icons.view_in_ar,
          notCheckedIcon: Icons.view_in_ar_outlined),
      "flare": IconForCheckBox(
          checkedIcon: Icons.flare, notCheckedIcon: Icons.lens_blur_sharp),
    },
    "Common": {
      "qr code": IconForCheckBox(
          checkedIcon: Icons.qr_code_scanner, notCheckedIcon: Icons.qr_code),
      "limit": IconForCheckBox(
          checkedIcon: Icons.hourglass_full,
          notCheckedIcon: Icons.hourglass_empty),
      "robot": IconForCheckBox(
          checkedIcon: Icons.smart_toy,
          notCheckedIcon: Icons.smart_toy_outlined),
      "game": IconForCheckBox(
          checkedIcon: Icons.sports_esports,
          notCheckedIcon: Icons.sports_esports_outlined),
      "music": IconForCheckBox(
          checkedIcon: Icons.music_note,
          notCheckedIcon: Icons.music_note_outlined),
    }
  },
};
