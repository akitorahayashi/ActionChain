import 'dart:convert';

import 'package:action_chain/model/ac_todo/ac_step.dart';

class ACToDo {
  String title;
  bool isChecked = false;
  List<ACStep> steps;
  ACToDo({required this.title, required this.steps});

  static List<ACToDo> getNewMethods({required List<ACToDo> selectedMethods}) {
    final List<ACToDo> willReturnedMethods = [];
    for (ACToDo method in selectedMethods) {
      if (method.steps.isEmpty) {
        willReturnedMethods.add(ACToDo(title: method.title, steps: []));
      } else {
        final List<ACStep> steps = (() {
          final List<ACStep> willReturnedSteps = [];
          for (ACStep step in method.steps) {
            willReturnedSteps.add(ACStep(title: step.title));
          }
          return willReturnedSteps;
        }());
        willReturnedMethods.add(ACToDo(title: method.title, steps: steps));
      }
    }
    return willReturnedMethods;
  }

// --- json convert ---

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "isChecked": isChecked,
      "steps": ACStep.stepsToString(steps: steps),
    };
  }

  ACToDo.fromJson(Map<String, dynamic> jsonData)
      : title = jsonData["title"],
        isChecked = jsonData["isChecked"] ?? false,
        steps = ACStep.stringToSteps(jsonStepsData: jsonData["steps"]);

  // カスタムクラスの配列をStringにする関数
  // [instance] → [String] → String
  static String methodsToString({required List<ACToDo> methods}) {
    final stringArrayOfMethods = methods.map((method) {
      return json.encode(method.toMap());
    }).toList();

    final String shouldSavedData = json.encode(stringArrayOfMethods);

    return shouldSavedData;
  }

  // Stringからカスタムクラスに変換する関数
  // String → [String] → [instance]
  static List<ACToDo> stringToMethods({required String jsonMethodsData}) {
    final stringInstanceList = json.decode(jsonMethodsData);

    var instanceList = stringInstanceList.map((methodData) {
      final decodedMethodData = json.decode(methodData);
      return ACToDo.fromJson(decodedMethodData);
    }).toList();

    return instanceList.cast<ACToDo>() as List<ACToDo>;
  }

  // --- json convert ---
}
