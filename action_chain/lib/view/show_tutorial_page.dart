import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';

class TutorialContent {
  final Widget visualImage;
  final String title;
  final String subTitle;
  TutorialContent(
      {required this.visualImage, required this.title, required this.subTitle});
}

class ShowTutorialPage extends StatefulWidget {
  const ShowTutorialPage({Key? key}) : super(key: key);

  @override
  State<ShowTutorialPage> createState() => _ShowTutorialPageState();
}

class _ShowTutorialPageState extends State<ShowTutorialPage> {
  int currentPageIndex = 0;
  final ValueNotifier<double> pageNnotifier = ValueNotifier(0);
  final tutorialPageController = PageController();

  void turnPageAction() {
    if (currentPageIndex == _tutorialContents.length - 1) {
      Navigator.pop(context);
      settingData.isFirstEntry = false;
      settingData.saveSettings();
    } else {
      tutorialPageController.animateToPage(
        currentPageIndex + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.decelerate,
      );
    }
  }

  final List<TutorialContent> _tutorialContents = [
    TutorialContent(
        visualImage: Image.asset("assets/cracker.png"),
        title: "Welcome to Action Chain!",
        subTitle: "Action Chainは一連の作業をを\nミスなくやり切るためのアプリです！！"),
    TutorialContent(
        visualImage: SizedBox(
          width: 200,
          height: 60,
          child: Card(
            // 色
            color: acTheme["Sun Orange"]!.panelColor,
            // 浮き具合
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        title: "事前知識はこれだけでOK！",
        subTitle:
            "この色のカードは左右にスライドして\n便利な機能を使うことができます！\n\n他の簡単なTipsは\n   Settings -> My Page\nから見ることができます！"),
    TutorialContent(
        visualImage: Container(),
        title: "さあ、始めよう！",
        subTitle: "Action Chainで高い生産性を！！"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // 背景色
          Container(color: Colors.white),

          /// [StatefulWidget] with [PageView] and [AnimatedBackgroundColor].
          // SlidingTutorial(
          //   controller: _pageCtrl,
          //   pageCount: pageCount,
          //   notifier: notifier,
          // ),
          GestureDetector(
            onTap: () => turnPageAction(),
            child: PageView.builder(
              onPageChanged: (newPageIndex) => setState(() {
                currentPageIndex = newPageIndex;
                pageNnotifier.value = newPageIndex.toDouble();
              }),
              itemBuilder: (context, index) {
                final TutorialContent content = _tutorialContents[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 64.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 80.0),
                              child: Container(
                                width: 200,
                                height: 200,
                                color: Colors.transparent,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: content.visualImage),
                              ),
                            ),
                            SizedBox(
                              height: 180,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: Text(
                                      content.title,
                                      style: TextStyle(
                                          color: acTheme["Sun Orange"]!
                                              .accentColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 24.0),
                                      child: Text(
                                        content.subTitle,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              itemCount: _tutorialContents.length,
              controller: tutorialPageController,
            ),
          ),

          Positioned(
            bottom: 80,
            child: SlidingIndicator(
              indicatorCount: _tutorialContents.length,
              notifier: pageNnotifier,
              activeIndicator: Icon(
                Icons.circle,
                color: Colors.black.withOpacity(0.3),
              ),
              inActiveIndicator: Icon(
                Icons.circle,
                color: Colors.black.withOpacity(0.3),
              ),
              margin: 8,
              inactiveIndicatorSize: 12,
              activeIndicatorSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
