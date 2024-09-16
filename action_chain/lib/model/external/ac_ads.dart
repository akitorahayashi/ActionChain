// import 'package:flutter/material.dart';
// import 'package:action_chain/alerts/simple_alert.dart';
// import '../../main.dart';
// import 'dart:io';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// class ACAds {
//   static RewardedAd? rewardedAd;
//   static DateFormat dateFormater = DateFormat('yyyy/MM/dd');

//   // Passの期限
//   static String limitOfPass =
//       dateFormater.format(DateTime.now().add(const Duration(days: -1)));
//   // 最後に動画広告を見た日付
//   static String lastWatchedAdDate = '2020/01/01';

//   // passがactiveか確認する
//   static bool get isPassActive => (() {
//         final DateTime inputDate =
//             dateFormater.parse(ACAds.limitOfPass); // 文字列を日付に変換
//         final DateTime today = DateTime.now(); // 現在の日付

//         return !inputDate.isBefore(today); // 今日より前でないならtrue
//       }());

//   // 今日初めて見たか確認して初めてだったら多めに数字を返す
//   // static int daysIfFirstWatchAdsToday({
//   //   required int notFirstAmount,
//   //   required int firstAmount,
//   // }) {
//   //   final String today = dateFormater.format(DateTime.now());
//   //   if (TLAds.lastWatchedAdDate == today) {
//   //     return notFirstAmount;
//   //   } else {
//   //     TLAds.lastWatchedAdDate = today;
//   //     SharedPreferences.getInstance().then((pref) {
//   //       pref.setString("lastWatchedAdDate", today);
//   //     });
//   //     return firstAmount;
//   //   }
//   // }

//   static Future<void> initializeACAds() async {
//     await MobileAds.instance.initialize();
//     // Passの起源を読み込む
//     await SharedPreferences.getInstance().then((pref) async {
//       final roadedLimit = pref.getString("limitOfPass");
//       // passLimitが存在するか
//       if (roadedLimit != null) {
//         ACAds.limitOfPass = roadedLimit;
//       } else {
//         await ACAds.saveLimitOfPass();
//       }
//       // lastShowedDateが存在するか
//       final loadedLastWatchedAdDate = pref.getString("lastWatchedAdDate");
//       if (loadedLastWatchedAdDate != null) {
//         lastWatchedAdDate = loadedLastWatchedAdDate;
//       }
//     });
//     // passをわざと切らす
//     // TLAds.limitOfPass = "2020/01/01";
//   }

//   static Future<void> saveLimitOfPass() async {
//     await SharedPreferences.getInstance().then((pref) {
//       pref.setString("limitOfPass", ACAds.limitOfPass);
//     });
//   }

//   static void extendLimitOfPassReward({required int howManyDays}) {
//     DateTime today = DateTime.now();
//     DateTime limitDate = dateFormater.parse(ACAds.limitOfPass);
//     if (limitDate.isBefore(today)) {
//       // 今日より前なら2日後の日付
//       ACAds.limitOfPass =
//           dateFormater.format(today.add(Duration(days: howManyDays - 1)));
//     } else {
//       // 今日かそれ以降なら3日後の日付
//       ACAds.limitOfPass =
//           dateFormater.format(limitDate.add(Duration(days: howManyDays)));
//     }
//     ACAds.saveLimitOfPass();
//   }

//   static Future<void> showRewardedAd(
//       {required BuildContext context, required Function rewardAction}) async {
//     if (ACAds.rewardedAd != null) {
//       await ACAds.rewardedAd!.show(onUserEarnedReward: (_, reward) {
//         rewardAction();
//       });
//     } else {
//       // ロードできてなかった時再ロード
//       loadRewardedAd().then((_) async {
//         if (ACAds.rewardedAd != null) {
//           await ACAds.rewardedAd!.show(onUserEarnedReward: (_, reward) {
//             rewardAction(_, reward);
//           });
//         } else {
//           // それでも無理だったら
//           simpleAlert(
//               context: context,
//               title: "エラー",
//               message: "インターネット環境の調子が悪いようです...",
//               buttonText: "OK");
//         }
//       });
//     }
//   }

//   static Future<void> loadRewardedAd() async {
//     return RewardedAd.load(
//       adUnitId: ACAds.rewardedAdUnitId(isTestMode: adTestMode),
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (ad) {
//           ad.fullScreenContentCallback = FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (ad) {
//               ad.dispose();
//               ACAds.rewardedAd = null;
//               loadRewardedAd();
//             },
//           );

//           ACAds.rewardedAd = ad;
//         },
//         onAdFailedToLoad: (err) {
//           print('Failed to load a rewarded ad: ${err.message}');
//         },
//       ),
//     );
//   }

//   // ad unit id
//   static String editPageBannerAdUnitId({required bool isTestMode}) {
//     if (Platform.isAndroid) {
//       return isTestMode
//           ? "ca-app-pub-3940256099942544/6300978111"
//           : "ca-app-pub-1452400640613361/8048676444";
//     } else if (Platform.isIOS) {
//       return isTestMode
//           ? "ca-app-pub-3940256099942544/2934735716"
//           : "ca-app-pub-1452400640613361/3235333467";
//     } else {
//       throw UnsupportedError('Unsupported platform');
//     }
//   }

//   static String setFeaturesBannerAdUnitId({required bool isTestMode}) {
//     if (Platform.isAndroid) {
//       return isTestMode
//           ? "ca-app-pub-3940256099942544/6300978111"
//           : "ca-app-pub-1452400640613361/7912945074";
//     } else if (Platform.isIOS) {
//       return isTestMode
//           ? "ca-app-pub-3940256099942544/2934735716"
//           : "ca-app-pub-1452400640613361/1539108413";
//     } else {
//       throw UnsupportedError("Unsupported platform");
//     }
//   }

//   static String rewardedAdUnitId({required bool isTestMode}) {
//     if (Platform.isAndroid) {
//       return isTestMode
//           ? "ca-app-pub-3940256099942544/5224354917"
//           : "ca-app-pub-1452400640613361/1483268097";
//     } else if (Platform.isIOS) {
//       return isTestMode
//           ? "ca-app-pub-3940256099942544/1712485313"
//           : "ca-app-pub-1452400640613361/4835108172";
//     } else {
//       throw UnsupportedError("Unsupported platform");
//     }
//   }
// }
