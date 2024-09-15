import 'package:flutter/material.dart';
import 'dart:convert';

class ACStep {
  String title;
  bool isChecked;

  ACStep({
    required this.title,
    this.isChecked = false,
  });

  // --- json convert ---

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "isChecked": isChecked,
    };
  }

  ACStep.fromJson(Map<String, dynamic> jsonData)
      : title = jsonData["title"],
        isChecked = jsonData["isChecked"];

// --- json convert

  static List<dynamic> stepsToJson({required List<ACStep> acsteps}) {
    return acsteps.map((acstepData) {
      return acstepData.toJson();
    }).toList();
  }

  static List<ACStep> jsonToACStep({required List<dynamic> jsonStepsData}) {
    return jsonStepsData.map((jsonACStepData) {
      return ACStep.fromJson(jsonACStepData);
    }).toList();
  }
}
