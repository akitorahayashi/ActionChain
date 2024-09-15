import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:flutter/material.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/user/setting_data.dart';

class EffortCardOfWorkspace extends StatelessWidget {
  const EffortCardOfWorkspace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        width: deviceWidth - 31.5,
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
            child: Column(
              children: [
                // タイトル
                Text(currentWorkspace.name,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )),
                // effortの表示
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "${currentWorkspace.numberOfCompletedTasksInThisWorkspace}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: theme[settingData.selectedTheme]!.accentColor,
                        fontSize: 20,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
