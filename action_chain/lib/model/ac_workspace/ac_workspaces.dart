import 'package:action_chain/model/ac_todo/ac_todo.dart';
import 'package:action_chain/model/ac_todo/ac_step.dart';
import 'package:action_chain/model/ac_todo/ac_category.dart';
import 'package:action_chain/model/ac_todo/ac_chain.dart';
import 'package:action_chain/model/ac_workspace/ac_workspace.dart';

List<ACWorkspace> acWorkspaces = [
  ACWorkspace(name: "デフォルト", chainCategories: [
    ACCategory(id: noneId, title: "なし")
  ], savedChains: {
    noneId: [
      ACChain(title: "帰ってからやること", actodos: [
        ACToDo(title: "ご飯を炊く", steps: []),
        ACToDo(title: "運動する", steps: [
          ACStep(title: "水筒"),
          ACStep(title: "スマホ"),
          ACStep(title: "カギ"),
        ]),
        ACToDo(title: "お風呂に入る", steps: [
          ACStep(title: "タオルを忘れるな！"),
        ]),
        ACToDo(title: "夕食", steps: []),
        ACToDo(title: "~について勉強する", steps: []),
        ACToDo(title: "明日の計画を立てる", steps: []),
      ]),
    ]
  }, keepedChains: {
    noneId: [
      ACChain(title: "明日の持ち物", actodos: [
        ACToDo(
            title: "筆記用具", steps: [ACStep(title: "メモ帳"), ACStep(title: "ペン")]),
        ACToDo(title: "水筒", steps: []),
        ACToDo(title: "お弁当", steps: []),
      ]),
    ]
  })
];
