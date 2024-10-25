import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static final PrefService _instance = PrefService._internal();
  static SharedPreferences? _pref;

  PrefService._internal();

  factory PrefService() {
    return _instance;
  }

  Future<SharedPreferences> get getPref async {
    _pref ??= await SharedPreferences.getInstance();
    return _pref!;
  }
}
