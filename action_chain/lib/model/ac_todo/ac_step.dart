import 'dart:convert';

class ACStep {
  String title;
  bool isChecked;

  ACStep({
    required this.title,
    this.isChecked = false,
  });

  // --- json convert ---

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "isChecked": isChecked,
    };
  }

  ACStep.fromJson(Map<String, dynamic> jsonData)
      : title = jsonData["title"],
        isChecked = jsonData["isChecked"];

  // カスタムクラスの配列をStringにする関数
  // [instance] → [String] → String
  static String stepsToString({required List<ACStep> steps}) {
    final List<String> jsonStepsData = steps.map((step) {
      final Map<String, dynamic> willEncodedData = step.toMap();
      return json.encode(willEncodedData);
    }).toList();

    final String shouldSavedData = json.encode(jsonStepsData);

    return shouldSavedData;
  }

  // Stringからカスタムクラスに変換する関数
  // String → [String] → [instance]
  static List<ACStep> stringToSteps({required String jsonStepsData}) {
    final stringInstanceList = json.decode(jsonStepsData);

    var instanceList = stringInstanceList.map((stepData) {
      final decodedStepData = json.decode(stepData);
      return ACStep.fromJson(decodedStepData);
    }).toList();

    return instanceList.cast<ACStep>() as List<ACStep>;
  }

  // --- json convert ---
}
