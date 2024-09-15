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

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "isChecked": isChecked,
      "steps": ACStep.stepsToJson(acsteps: steps),
    };
  }

  ACToDo.fromJson(Map<String, dynamic> jsonData)
      : title = jsonData["title"],
        isChecked = jsonData["isChecked"] ?? false,
        steps = ACStep.jsonToACStep(jsonStepsData: jsonData["steps"]);
}
