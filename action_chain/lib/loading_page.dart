import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final bool errorIsOccurred;
  const LoadingPage({Key? key, required this.errorIsOccurred})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: errorIsOccurred ? 4 : null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: errorIsOccurred ? Colors.white : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DefaultTextStyle(
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.7)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: errorIsOccurred
                    // エラーが起こった!
                    ? const [
                        SizedBox(
                            width: 60,
                            height: 60,
                            child: Icon(
                              Icons.error_outline,
                              size: 26,
                              color: Colors.redAccent,
                            )),
                        Text("Something went wrong."),
                        Text("Try restarting the app."),
                      ]
                    // ロード中
                    : const [
                        SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Text(
                            "Loading...",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                                fontSize: 17,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
