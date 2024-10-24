import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
// import 'package:action_chain/model/external/ac_ads.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:flutter/material.dart';
import 'app.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

bool kAdTestMode = true;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await ACAds.initializeACAds();
  await SettingData.shared.readSettings();
  await ACVibration.initVibrate();
  await ACWorkspace.readWorkspaces();
  // await actionChainUser.initializeFirebase();
  runApp(ActionChainApp(key: actionChainAppKey));
}
