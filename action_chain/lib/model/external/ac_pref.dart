import 'package:shared_preferences/shared_preferences.dart';

class ACPref {
  static final ACPref _instance = ACPref._internal();
  static SharedPreferences? _pref;

  ACPref._internal();

  factory ACPref() {
    return _instance;
  }

  Future<SharedPreferences> get getPref async {
    _pref ??= await SharedPreferences.getInstance();
    return _pref!;
  }
}
