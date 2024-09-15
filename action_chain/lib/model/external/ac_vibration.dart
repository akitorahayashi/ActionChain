import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ACVibration {
  static int vibrationStrength = 2;
  static bool canVibrate = false;

  static Future<void> initVibrate() async {
    bool canVibrateOrNot = await Vibrate.canVibrate;
    canVibrate = canVibrateOrNot;
    if (canVibrate) {
      await SharedPreferences.getInstance().then((pref) {
        ACVibration.vibrationStrength = pref.getInt("vibrationStrength") ?? 2;
      });
    }
  }

  static Future<void> saveVibrationStrength() async {
    await SharedPreferences.getInstance().then((pref) =>
        pref.setInt("vibrationStrength", ACVibration.vibrationStrength));
  }

  static void vibrate() {
    if (canVibrate) {
      switch (ACVibration.vibrationStrength) {
        case 0:
          break;
        case 1:
          Vibrate.feedback(FeedbackType.light);
          break;
        case 2:
          Vibrate.feedback(FeedbackType.medium);
          break;
        case 3:
          Vibrate.feedback(FeedbackType.heavy);
          break;
        case 4:
          Vibrate.feedback(FeedbackType.success);
          break;
      }
    }
  }
}
