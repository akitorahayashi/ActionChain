import 'package:action_chain/constants/icons_for_checkbox.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/alerts/simple_alert.dart';
import 'package:action_chain/alerts/yes_no_alert.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/main.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Admob admob = Admob();

class Admob {
  bool foreverTicket = false;

  bool bannerAdsIsEnabled = false;
  bool ticketIsActive = true;

  // コイン
  int coinForIconGacha = 3;
  int coinShards = 0;
  String getCoinDate = DateFormat("yyyy-MM-dd")
      .format(DateTime.now().subtract(const Duration(days: 1)));

  static int numberOfAdsToGetOneDayTicket = isDevelopperMode ? 1 : 2;
  static int numberOfAdsToBeThreeDaysPremium = isDevelopperMode ? 1 : 3;

  BannerAd? bannerAd;
  RewardedAd? rewardAd;

  // oneDayPremiumAdsを見た回数
  int timesOfSeeOneDayTicketAds = 0;
  // threeDayPremiumAdsを見た回数
  int timesOfSeeThreeDaysTicketAds = 0;
  // premiumはこの日まで続く
  String? ticketLastsUntilThisDate;

  Admob();

  // 保存する際に使う
  Map<String, dynamic> toJson() {
    return {
      "foreverTicket": admob.foreverTicket,
      // 広告を見た回数
      "timesOfSeeOneDayTicketAds": timesOfSeeOneDayTicketAds,
      "timesOfSeeThreeDaysTicketAds": timesOfSeeThreeDaysTicketAds,
      // ticketの期限
      "ticketLastsUntilThisDate": ticketLastsUntilThisDate,
      // コイン
      "coinForIconGacha": admob.coinForIconGacha,
      "coinShards": admob.coinShards,
      "getCoinDate": admob.getCoinDate,
    };
  }

  Admob.fromJson(Map<String, dynamic> jsonData)
      // 広告を見た回数
      : foreverTicket = jsonData["foreverTicket"] ?? false,
        timesOfSeeOneDayTicketAds = jsonData["timesOfSeeOneDayTicketAds"] ?? 0,
        timesOfSeeThreeDaysTicketAds =
            jsonData["timesOfSeeThreeDaysTicketAds"] ?? 0,
        // ticketsの期限
        ticketLastsUntilThisDate = jsonData["ticketLastsUntilThisDate"],
        // コイン
        coinForIconGacha = jsonData["coinForIconGacha"] ?? 3,
        coinShards = jsonData["coinShards"] ?? 0,
        getCoinDate = jsonData["getCoinDate"] ??
            DateFormat("yyyy-MM-dd")
                .format(DateTime.now().subtract(const Duration(days: 1)));

  // --- save ---

  void readAdsData() {
    SharedPreferences.getInstance().then((pref) {
      if (pref.getString("admob") != null) {
        admob = Admob.fromJson(json.decode(pref.getString("admob")!));
      }
    });
  }

  void saveAdsData() {
    SharedPreferences.getInstance().then((pref) {
      pref.setString("admob", json.encode(admob.toJson()));
    });
  }

  // banner id
  String bannerID = Platform.isIOS
      ? "ca-app-pub-1034263542248179/3711183483"
      : "ca-app-pub-1034263542248179/7148683851";

  // 2回見たら1日無料になる
  String getOneDayTicketID = Platform.isIOS
      ? "ca-app-pub-1034263542248179/3360647933"
      : "ca-app-pub-1034263542248179/7371226890";
  // 3回見たら3日無料になる
  String getThreeDaysTicketID = Platform.isIOS
      ? "ca-app-pub-1034263542248179/6145775132"
      : "ca-app-pub-1034263542248179/5795239584";

  // アイコンガチャ
  String getCoinForIconGachaID = Platform.isIOS
      ? "ca-app-pub-1034263542248179/8216285145"
      : "ca-app-pub-1034263542248179/4745063553";

  // テスト広告
  String testID = Platform.isIOS
      ? "ca-app-pub-3940256099942544/1712485313"
      : "ca-app-pub-3940256099942544/5224354917";
  String bannerTestID = Platform.isIOS
      ? "ca-app-pub-3940256099942544/2934735716"
      : "ca-app-pub-3940256099942544/6300978111";

  void loadBanner() {
    admob.bannerAd = BannerAd(
      adUnitId: isAdDevelopperMode ? admob.bannerTestID : admob.bannerID,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print("Ad loaded"),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          bannerAdsIsEnabled = false;
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {
          bannerAdsIsEnabled = true;
          print('Ad impression.');
        },
      ),
    )..load();
  }

  // アイコンガチャを引くか確認する関数
  void askToGacha(
      {required BuildContext context,
      required int requiredCoin,
      required GachaPackage gachaPackage}) {
    yesNoAlert(
        context: context,
        title: "ガチャを引きますか？",
        message:
            "現在のコイン: ${admob.coinForIconGacha}枚\nこのガチャは$requiredCoin枚のコインを使います",
        yesAction: () {
          Navigator.pop(context);
          if (admob.coinForIconGacha >= requiredCoin || isDevelopperMode) {
            settingData.vibrate();
            // コインを減らす
            admob.coinForIconGacha -= (isDevelopperMode ? 0 : requiredCoin);
            // レアリティーを決める
            final String specifiedRarity = (() {
              final int randomNumber = Random().nextInt(100);
              if (randomNumber < gachaPackage.superRareRate) {
                return "Super Rare";
              } else if (randomNumber <
                  (gachaPackage.superRareRate + gachaPackage.rareRate)) {
                return "Rare";
              } else {
                return "Common";
              }
            }());
            // 獲得したアイコン名を決める
            final List<IconDataInPackage> specifiedIconDataList =
                gachaPackage.iconsInThisPackage[specifiedRarity]!;
            final IconDataInPackage earnedIconData = specifiedIconDataList[
                Random().nextInt(specifiedIconDataList.length)];
            // 被ってなかったら追加する
            final isSuffered = settingData.earnedIcons.keys
                    .contains(earnedIconData.iconCategoryName) &&
                settingData.earnedIcons[earnedIconData.iconCategoryName]!
                    .contains(earnedIconData.iconName);
            if (isSuffered) {
              // 被ってたらレアリティーに応じてコインをプレゼントする
              if (specifiedRarity == "Super Rare") {
                admob.coinForIconGacha += 2;
              } else if (specifiedRarity == "Rare") {
                admob.coinForIconGacha++;
              }
            } else {
              // 被ってなかったら追加する
              if (settingData.earnedIcons[earnedIconData.iconCategoryName] ==
                  null) {
                settingData.earnedIcons[earnedIconData.iconCategoryName] = [
                  earnedIconData.iconName
                ];
              } else {
                settingData.earnedIcons[earnedIconData.iconCategoryName]!
                    .add(earnedIconData.iconName);
              }
              settingData.saveSettings();
            }
            // 獲得したアイコンを表示する
            showResultOfIconGacha(
                context: context,
                isSuffered: isSuffered,
                rarity: specifiedRarity,
                earnedIconData:
                    iconsForCheckBox[earnedIconData.iconCategoryName]![
                            specifiedRarity]![earnedIconData.iconName]!
                        .checkedIcon,
                iconName: earnedIconData.iconName);
            getRewardPageKey.currentState?.setState(() {});
            admob.saveAdsData();
          } else {
            simpleAlert(
                context: context,
                title: "エラー",
                message: "Gacha Coinが\n足りないようです...",
                buttonText: "OK");
          }
        });
  }

  Widget getBannerAds({required BuildContext context}) {
    if (admob.ticketIsActive) {
      return Container();
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: admob.bannerAd?.size.height.toDouble() ?? 50,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: admob.bannerAd?.size.height.toDouble() ?? 0,
                  child: Container(color: const Color.fromRGBO(80, 80, 80, 1))),
            ),
            if (admob.bannerAd != null)
              // バナー広告
              Positioned(
                  bottom: 0,
                  child: StatefulBuilder(
                    builder: (context, setState) => SizedBox(
                      width: admob.bannerAd!.size.width.toDouble(),
                      height: admob.bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: admob.bannerAd!),
                    ),
                  )),
          ],
        ),
      );
    }
  }

  bool increaseTimesOfSeeOneDayTicketAds() {
    bool ifGetPremium = false;
    admob.timesOfSeeOneDayTicketAds++;
    if (admob.timesOfSeeOneDayTicketAds >= Admob.numberOfAdsToGetOneDayTicket) {
      admob.extendPremiumTerm(numberOfDays: 1);
      admob.timesOfSeeOneDayTicketAds = 0;
      ifGetPremium = true;
    }
    admob.saveAdsData();
    return ifGetPremium;
  }

  bool increaseTimesOfSeeThreeDaysPremiumAds() {
    bool ifGetPremium = false;
    admob.timesOfSeeThreeDaysTicketAds++;
    if (admob.timesOfSeeThreeDaysTicketAds >=
        Admob.numberOfAdsToBeThreeDaysPremium) {
      admob.extendPremiumTerm(numberOfDays: 3);
      admob.timesOfSeeThreeDaysTicketAds = 0;
      ifGetPremium = true;
    }
    admob.saveAdsData();
    return ifGetPremium;
  }

  // 無料Premiumの期間を増やす関数
  void extendPremiumTerm({required int numberOfDays}) {
    late DateTime newPremiumDate;
    final DateTime premiumLimitDate =
        DateTime.parse(admob.ticketLastsUntilThisDate!)
            .add(const Duration(days: 1));
    // 期間終了
    if (premiumLimitDate.isBefore(DateTime.now())) {
      // 今日に足す
      final DateTime now = DateTime.now();
      newPremiumDate =
          DateTime(now.year, now.month, now.day + (numberOfDays - 1));
    } else {
      // 期間がまだ続いてる
      newPremiumDate = DateTime.parse(admob.ticketLastsUntilThisDate!)
          .add(Duration(days: numberOfDays));
    }
    final String formattedNewPremiumDate =
        DateFormat("yyyy-MM-dd").format(newPremiumDate);
    admob.ticketLastsUntilThisDate = formattedNewPremiumDate;
    purchase.initPlatformState();
    admob.saveAdsData();
  }

  // 広告をロードする関数
  void loadRewardAd({required String adUnitID}) {
    RewardedAd.load(
        adUnitId: isAdDevelopperMode ? testID : adUnitID,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            admob.rewardAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: ${error.message}');
          },
        ));
  }

  // 広告を表示する関数
  void showAds(
      {required BuildContext context,
      required bool isFirstAd,
      required bool shouldLoad,
      required String rewardAdUnitID,
      required Function() getRewardAction}) {
    void showAdMethod() async {
      if (shouldLoad) {
        final progress = ProgressHUD.of(context);
        // 広告がセットされていなかった時の処理
        proPageKey.currentState?.setState(() {
          progress?.showWithText("Loading...");
        });
        await RewardedAd.load(
            adUnitId: isAdDevelopperMode ? testID : rewardAdUnitID,
            request: const AdRequest(),
            rewardedAdLoadCallback: RewardedAdLoadCallback(
              onAdLoaded: (RewardedAd ad) {
                admob.loadRewardAd(adUnitID: rewardAdUnitID);
                // 広告を表示
                ad.show(onUserEarnedReward: (rewardedAd, reward) {
                  getRewardAction();
                });
                proPageKey.currentState?.setState(() {
                  progress?.dismiss();
                });
              },
              onAdFailedToLoad: (LoadAdError error) {
                simpleAlert(
                    context: context,
                    title: "エラー",
                    message: "動画の読み込みに失敗しました\n\nメッセージ: ${error.message}",
                    buttonText: "OK");
                proPageKey.currentState?.setState(() {
                  progress?.dismiss();
                });
              },
            ));
      } else {
        // showメソッドの後にロードすることでもう一度見ることができる
        loadRewardAd(adUnitID: rewardAdUnitID);
        // 広告を表示
        admob.rewardAd?.show(onUserEarnedReward: (rewardedAd, reward) {
          getRewardAction();
        });
      }
    }

    if (isFirstAd) {
      yesNoAlert(
          context: context,
          title: "動画の視聴を開始しますか?",
          message: "この報酬を獲得するためには\n短い動画を視聴する必要があります",
          yesAction: () {
            Navigator.pop(context);
            showAdMethod();
          });
    } else {
      showAdMethod();
    }
  }

  // プロモーションコードを入力させる関数
  Future<void> letUserEnterSerialCode({required BuildContext context}) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // インターネットに接続できている場合

        // まずenteringSerialCodeIsEnabledになっている確認する
        final cloudFirestoreSettingsSnapshots = FirebaseFirestore.instance
            .collection("cloud_firestore_settings")
            .snapshots()
            .map((snapshot) => snapshot.docs.toList());

        bool enteringSerialCodeIsEnabled = false;

        await for (List<QueryDocumentSnapshot<Object?>> documents
            in cloudFirestoreSettingsSnapshots) {
          enteringSerialCodeIsEnabled =
              documents.first["enteringSerialCodeIsEnabled"];
          break;
        }

        if (enteringSerialCodeIsEnabled) {
          TextEditingController serialCodeInputController =
              TextEditingController();
          return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return Dialog(
                  backgroundColor: theme[settingData.selectedTheme]!.alertColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 16),
                            child: Text(
                              "Serial Code",
                              style: TextStyle(
                                  color: theme[settingData.selectedTheme]!
                                      .accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Card(
                              child: TextField(
                                maxLength: 5,
                                textAlign: TextAlign.center,
                                controller: serialCodeInputController,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.45)),
                                decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  counterText: "",
                                ),
                              ),
                            ),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("閉じる")),
                              TextButton(
                                  onPressed: () async {
                                    settingData.vibrate();
                                    // インターネットに接続している場合
                                    // リファレンス
                                    final promotionReference = FirebaseFirestore
                                        .instance
                                        .collection("followLots");
                                    // snapshotsをとる
                                    final Stream<List<QueryDocumentSnapshot>>
                                        promotionSnapshots = promotionReference
                                            .snapshots()
                                            .map((snapshot) =>
                                                snapshot.docs.toList());
                                    // 実際にチェックしていく
                                    // promotion snapshots
                                    await for (List<
                                            QueryDocumentSnapshot<
                                                Object?>> documents
                                        in promotionSnapshots) {
                                      for (QueryDocumentSnapshot<
                                          Object?> document in documents) {
                                        // ドキュメントごとにチェック
                                        if (document.id ==
                                            serialCodeInputController.text) {
                                          if (!document["isReceived"]) {
                                            settingData.vibrate();
                                            // 未取得の場合
                                            simpleAlert(
                                                context: context,
                                                title: "おめでとうございます！",
                                                message:
                                                    "- 内容 -\nGacha Coin: ${document["earnedGachaCoin"]}枚\n\nプロモーションコードが\n適用されました！！",
                                                buttonText: "thank you!");
                                            // 受け取りを記録
                                            promotionReference
                                                .doc(document.id)
                                                .update({"isReceived": true});
                                            // reward
                                            admob.coinForIconGacha += int.parse(
                                                document["earnedGachaCoin"]
                                                    .toString());
                                            // save
                                            admob.saveAdsData();
                                            return;
                                          } else {
                                            // 取得済みの場合
                                            simpleAlert(
                                                context: context,
                                                title: "エラー",
                                                message: "このコードは取得済みです",
                                                buttonText: "OK");
                                            return;
                                          }
                                        }
                                      }
                                      break;
                                    }
                                    simpleAlert(
                                        context: context,
                                        title: "エラー",
                                        message: "プロモーションコードを\n見つけることができませんでした",
                                        buttonText: "OK");
                                  },
                                  child: const Text("完了")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
      }
    } on SocketException catch (_) {
      // 接続していない場合
      print("notConnected");
    }
  }

  // ticketが切れた時の関数、アイコンの獲得も
  void confirmToGoToProPageToShowAd({
    required BuildContext context,
    required GlobalKey superKey,
    required bool isBannerService,
    String? title,
    String? message,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: theme[settingData.selectedTheme]!.alertColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                    child: Text(
                      title ??
                          (isBannerService
                              ? "Ticketを獲得するための\nページに移動しますか？"
                              : "チケットの有効期限が\n切れました"),
                      style: TextStyle(
                          color: theme[settingData.selectedTheme]!.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      message ??
                          (isBannerService
                              ? "Ticketを獲得すればバナー広告なしでも使えるようになります！"
                              : "チケットを無料で獲得するためのページに移動しますか?"),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("いいえ")),
                      TextButton(
                          onPressed: () async {
                            // アラートを消す
                            Navigator.pop(context);
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ProPage(key: proPageKey);
                            }));
                            superKey.currentState?.setState(() {});
                          },
                          child: const Text("はい")),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
