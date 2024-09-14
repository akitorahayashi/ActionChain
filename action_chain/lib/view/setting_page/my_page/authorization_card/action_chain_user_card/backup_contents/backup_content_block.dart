import 'package:flutter/material.dart';

class BackupContentBlock extends StatelessWidget {
  final String title;
  final List<Widget> buttons;
  const BackupContentBlock(
      {Key? key, required this.title, required this.buttons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttons,
          )
        ],
      ),
    );
  }
}
