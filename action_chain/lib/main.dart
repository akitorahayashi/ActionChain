import 'package:action_chain/constants/global_keys.dart';
import 'package:flutter/material.dart';
import 'app.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

bool isDevelopperMode = false;
bool isAdDevelopperMode = false;
bool adIsClosed = true;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await MobileAds.instance.initialize();
  runApp(ActionChainApp(key: actionChainAppKey));
}
