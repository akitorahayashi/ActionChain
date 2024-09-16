// import 'package:action_chain/alerts/simple_alert.dart';
// import 'package:action_chain/constants/global_keys.dart';
// import 'package:action_chain/constants/theme.dart';
// import 'package:action_chain/model/ac_category.dart';
// import 'package:action_chain/model/ac_todo/ac_chain.dart';
// import 'package:action_chain/model/ac_workspace/ac_workspaces.dart';
// import 'package:action_chain/model/external/ac_vibration.dart';
// import 'package:action_chain/model/user/setting_data.dart';
// import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'dart:io';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_progress_hud/flutter_progress_hud.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:google_sign_in/google_sign_in.dart' as google_sign_in;
// import 'package:googleapis/drive/v3.dart' as google_drive;
// import 'package:path/path.dart';

// final ACUser actionChainUser = ACUser();
// const String fileName = "actionChain_backUp";

// class ACUser {
// // Google SignIn認証のためのインスタンス
//   google_sign_in.GoogleSignIn googleSignIn =
//       google_sign_in.GoogleSignIn(scopes: [
//     google_drive.DriveApi.driveAppdataScope,
//   ]);
// //  インポート済のため、本コード内でインポートしなくても動作する
//   late var httpClientO;
// // ユーザー情報
//   google_sign_in.GoogleSignInAccount? accontSignedInWithGoogle;
// // Google Drive APIのインスタンス
//   late google_drive.DriveApi googleDriveApiO;

//   Future<FirebaseApp> initializeFirebase() async {
//     FirebaseApp firebaseApp = await Firebase.initializeApp();

//     try {
//       // サインイン済か否か確認
//       final checkSignInResultO = await googleSignIn.isSignedIn();
//       print("サインインしているか否か $checkSignInResultO");
//       // サインイン済の場合は、サインインのポップアップを出さずにサインイン処理
//       // ※iOSの場合はsignInSilentlyにしないと、毎回サインインのポップアップが出てしまうため
//       if (checkSignInResultO) {
//         accontSignedInWithGoogle = await googleSignIn.signInSilently();
//         // サインイン済にもかかわらず返り値がnullの場合、
//         // ユーザーがGoogleアカウントの設定画面で接続解除をした可能性があるので、
//         // disconnectメソッドで完全サインアウトし、認証情報を初期化する
//         if (accontSignedInWithGoogle == null) {
//           print("認証情報を初期化する必要が生じたため、アプリを再起動してもう一度ボタンを押してください。");
//           await googleSignIn.disconnect();
//         }
//       }
//     } catch (e) {
//       print(e);
//     }
//     return firebaseApp;
//   }

//   Future<void> signInWithGoogle(
//       {required BuildContext context, required bool isWeb}) async {
//     final progress = ProgressHUD.of(context);
//     settingPageKey.currentState?.setState(() {
//       progress?.showWithText("Loading...");
//     });

//     FirebaseAuth auth = FirebaseAuth.instance;
//     // User? user;

//     // サインインの処理
//     try {
//       if (isWeb) {
//         // GoogleAuthProvider authProvider = GoogleAuthProvider();

//         // final UserCredential userCredential =
//         //     await auth.signInWithPopup(authProvider);

//         // user = userCredential.user;
//       } else {
//         actionChainUser.accontSignedInWithGoogle = await googleSignIn.signIn();
//         if (actionChainUser.accontSignedInWithGoogle != null) {
//           ACVibration.vibrate();
//         }
//       }
//     } catch (e) {
//       simpleAlert(
//           context: context,
//           title: "Error",
//           message: "サインインできませんでした...",
//           buttonText: "OK");
//     }

//     settingPageKey.currentState?.setState(() {
//       progress?.dismiss();
//     });
//     myPageKey.currentState?.setState(() {});
//   }

//   Future<void> signOut(
//       {required GlobalKey superKey,
//       required BuildContext context,
//       required bool isWeb}) async {
//     final GoogleSignIn googleSignIn = GoogleSignIn();
//     final progress = ProgressHUD.of(context);
//     superKey.currentState?.setState(() {
//       progress?.showWithText("Loading...");
//     });
//     try {
//       if (!isWeb) {
//         await googleSignIn.signOut();
//       }
//       await FirebaseAuth.instance.signOut();
//       actionChainUser.accontSignedInWithGoogle = null;
//     } catch (e) {
//       print(e);
//     }
//     superKey.currentState?.setState(() {
//       progress?.dismiss();
//     });
//     myPageKey.currentState?.setState(() {});
//   }

//   /// GoogleSignIn処理をするメソッド
//   Future<bool> _checkIfSigningInWithGoogle() async {
//     try {
//       // サインイン済か否か確認
//       final checkSignInResultO = await googleSignIn.isSignedIn();
//       print("サインインしているか否か $checkSignInResultO");
//       // サインイン済の場合はサインイン処理
//       if (checkSignInResultO) {
//         accontSignedInWithGoogle = await googleSignIn.signInSilently();
//         // サインイン済にもかかわらず返り値がnullの場合、
//         // ユーザーがGoogleアカウントの設定画面で接続解除をした可能性があるので、
//         // disconnectメソッドで完全サインアウトし、認証情報を初期化する
//         if (accontSignedInWithGoogle == null) {
//           print("認証情報を初期化する必要が生じたため、アプリを再起動してもう一度ボタンを押してください。");
//           await googleSignIn.disconnect();
//           // 例外処理を投げて、下方のcatchに飛ばす
//           throw Exception();
//         }
//       } else {
//         print("キャンセル");
//         throw Exception();
//       }

//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   // バックアップする関数
//   Future<void> askTobackUpToGoogleDrive(
//       {required BuildContext superContext}) async {
//     // バックアップの処理
//     final TextEditingController _noteInputController = TextEditingController();
//     // バックアップするか聞くついでにメモをいれる
//     showDialog(
//         context: superContext,
//         barrierDismissible: false,
//         builder: (context) {
//           return GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: Dialog(
//               backgroundColor: theme[settingData.selectedTheme]!.alertColor,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 16.0, bottom: 16),
//                       child: Text(
//                         "バックアップを\n作成しますか?",
//                         style: TextStyle(
//                             color:
//                                 theme[settingData.selectedTheme]!.accentColor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20),
//                       ),
//                     ),
//                     Text(
//                       "メモ",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black.withOpacity(0.45)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 5.0),
//                       child: SizedBox(
//                           width: 180,
//                           child: Card(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10.0),
//                               child: TextField(
//                                   controller: _noteInputController,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black.withOpacity(0.6)),
//                                   decoration: const InputDecoration(
//                                       contentPadding: EdgeInsets.only(
//                                           top: 10, bottom: 12.0),
//                                       isDense: true,
//                                       isCollapsed: true)),
//                             ),
//                           )),
//                     ),
//                     ButtonBar(
//                       alignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Text("いいえ")),
//                         TextButton(
//                             onPressed: () async {
//                               Navigator.pop(context);
//                               final progress = ProgressHUD.of(superContext);
//                               settingPageKey.currentState?.setState(() {
//                                 progress?.showWithText("Checking...");
//                               });
//                               // 削除ついでにサインインのチェック
//                               // Google SignInの処理
//                               if (!await _checkIfSigningInWithGoogle()) {
//                                 simpleAlert(
//                                     context: context,
//                                     title: "Error",
//                                     message:
//                                         "証情報を初期化する必要が生じたため、サインアウトしてもう一度サインインしてください",
//                                     buttonText: "OK");
//                                 settingPageKey.currentState?.setState(() {
//                                   progress?.dismiss();
//                                 });
//                                 return;
//                               }
//                               settingPageKey.currentState?.setState(() {
//                                 progress?.dismiss();
//                               });
//                               settingPageKey.currentState?.setState(() {
//                                 progress?.showWithText("Replacing...");
//                               });
//                               httpClientO =
//                                   (await googleSignIn.authenticatedClient())!;
//                               googleDriveApiO =
//                                   google_drive.DriveApi(httpClientO);
//                               await googleDriveApiO.files
//                                   .list(
//                                       spaces: 'appDataFolder',
//                                       $fields: 'files(id, name, createdTime)')
//                                   .then((savedFiles) async {
//                                 // ドライブ内にデータがある場合のみ、削除処理を実行
//                                 if (savedFiles.files!.isNotEmpty) {
//                                   for (var iO = 0;
//                                       iO < savedFiles.files!.length;
//                                       iO++) {
//                                     await googleDriveApiO.files
//                                         .delete(savedFiles.files![iO].id!);
//                                   }
//                                   print("データ削除完了");
//                                 } else {
//                                   print("Google Drive内にデータなし");
//                                 }
//                               });
//                               settingPageKey.currentState?.setState(() {
//                                 progress?.dismiss();
//                               });
//                               settingPageKey.currentState?.setState(() {
//                                 progress?.showWithText("Converting...");
//                               });

//                               // --- will be saved content ---

//                               final String savedContentO = json.encode({
//                                 // バックアップに関する情報
//                                 "lastUploadedDateAndTime":
//                                     DateFormat('yyyy-MM-dd - kk:mm')
//                                         .format(DateTime.now()),
//                                 "note": _noteInputController.text.trim().isEmpty
//                                     ? null
//                                     : _noteInputController.text,
//                                 "settingData": settingData.toJson(),
//                                 // workspace
//                                 "currentWorkspaceCategoryId":
//                                     ACWorkspace.currentWorkspaceCategoryId,
//                                 "currentWorkspaceIndex":
//                                     ACWorkspace.currentWorkspaceIndex,
//                                 "currentChain":
//                                     ACWorkspace.currentChain?.toJson(),
//                                 "workspaceCategories":
//                                     ACCategory.categoriesToJson(
//                                         categoryArray: workspaceCategories),
//                                 "stringWorkspaces": json.encode(acWorkspaces),
//                               });

//                               // --- will be saved content ---
//                               settingPageKey.currentState?.setState(() {
//                                 progress?.dismiss();
//                               });
//                               settingPageKey.currentState?.setState(() {
//                                 progress?.showWithText("Creating");
//                               });
//                               // まず端末内に保存する
//                               final savedDocumentDirectoryO =
//                                   await getApplicationDocumentsDirectory();
//                               const savedFileNameO = "$fileName.txt";
//                               String savedFullPathO = join(
//                                   savedDocumentDirectoryO.path, savedFileNameO);
//                               try {
//                                 File savedFileO = File(savedFullPathO);
//                                 // ファイル内容を書き込む（テストファイルの端末内保存を完了）
//                                 await savedFileO.writeAsString(savedContentO);
//                               } catch (e) {
//                                 simpleAlert(
//                                     context: context,
//                                     title: "Error",
//                                     message: "message: ${e.toString()}",
//                                     buttonText: "OK");
//                                 settingPageKey.currentState?.setState(() {
//                                   progress?.dismiss();
//                                 });
//                                 return;
//                               }

//                               // 端末内のバックアップするためのファイルを取得
//                               List<FileSystemEntity> fileEntityO =
//                                   Directory(savedDocumentDirectoryO.path)
//                                       .listSync();
//                               // バックアップ対象であるテキストファイル以外をリストから削除
//                               fileEntityO.removeWhere((elementO) =>
//                                   !elementO.path.endsWith(".txt"));
//                               // 確認用にパスをログに表示
//                               fileEntityO.forEach((elementO) {
//                                 print(elementO.path);
//                               });
//                               // バックアップ対象のファイルが存在しない場合は、何もせず早期リターン
//                               if (fileEntityO.isEmpty) {
//                                 simpleAlert(
//                                     context: context,
//                                     title: "Error",
//                                     message:
//                                         "Something went wrong.\nPlease try again.",
//                                     buttonText: "OK");
//                                 settingPageKey.currentState?.setState(() {
//                                   progress?.dismiss();
//                                 });
//                                 return;
//                               }

//                               settingPageKey.currentState?.setState(() {
//                                 progress?.dismiss();
//                               });
//                               settingPageKey.currentState?.setState(() {
//                                 progress?.showWithText("Uploading...");
//                               });

//                               // Google Driveへのアップロード
//                               httpClientO =
//                                   (await googleSignIn.authenticatedClient())!;
//                               googleDriveApiO =
//                                   google_drive.DriveApi(httpClientO);
//                               // ファイルを作る
//                               final uploadedFileO = google_drive.File();
//                               // Google Drive内のアプリ専用領域に保存する事を指定
//                               uploadedFileO.parents = ["appDataFolder"];
//                               // ※スコープを「driveO.DriveApi.driveScope」に設定し、ユーザーが見える場所に
//                               //  ファイルを保存する場合は、上記1文を削除する
//                               // 端末のアプリ専用フォルダ内のファイルを、forループで順次Google Driveに保存
//                               for (int iO = 0; iO < fileEntityO.length; iO++) {
//                                 // 端末のアプリ専用フォルダ内のiO番目のファイルをFile型で取得
//                                 final File fileO = File(fileEntityO[iO].path);
//                                 // Google Driveに保存する際のファイル名を設定
//                                 uploadedFileO.name = fileName;
//                                 // Media型に変換した上で、createメソッドでGoogle Driveに保存
//                                 await googleDriveApiO.files.create(
//                                   uploadedFileO,
//                                   uploadMedia: google_drive.Media(
//                                       fileO.openRead(), fileO.lengthSync()),
//                                 );
//                                 print("${iO + 1}番目のファイルを保存");
//                               }
//                               print("Google Driveに全ファイルのバックアップ完了");
//                               ACVibration.vibrate();
//                               simpleAlert(
//                                   context: superContext,
//                                   title: "バックアップ成功",
//                                   message:
//                                       "現在サインインされているGoogleアカウントにバックアップを作成することに成功しました",
//                                   buttonText: "OK");
//                               settingPageKey.currentState?.setState(() {
//                                 progress?.dismiss();
//                               });
//                             },
//                             child: const Text("はい")),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   // 最後にアップロードしたファイルの情報を取得する関数

//   // importして復元する関数
//   Future<void> importFromGoogleDrive(
//       {required BuildContext context,
//       required bool justWantInformation}) async {
//     final progress = ProgressHUD.of(context);
//     settingPageKey.currentState?.setState(() {
//       progress?.showWithText("Checking...");
//     });

//     /// Google SignInの処理
//     if (!await _checkIfSigningInWithGoogle()) {
//       simpleAlert(
//           context: context,
//           title: "Error",
//           message: "証情報を初期化する必要が生じたため、サインアウトしてもう一度サインインしてください",
//           buttonText: "OK");
//       settingPageKey.currentState?.setState(() {
//         progress?.dismiss();
//       });
//       return;
//     }

//     // 取得した文字列からuserdataを取り出し、アプリに反映する関数
//     void readUserData({required String stringUserData}) {
//       final mapUserData = json.decode(stringUserData);

//       settingData =
//           SettingData.fromJson(json.decode(mapUserData["settingData"]!));
//       // workspace
//       ACWorkspace.currentWorkspaceCategoryId =
//           mapUserData["currentWorkspaceCategoryId"] ?? noneId;
//       ACWorkspace.currentWorkspaceIndex =
//           mapUserData["currentWorkspaceIndex"] ?? 0;
//       ACWorkspace.currentChain = mapUserData["currentChain"] == null
//           ? null
//           : ActionChain.fromJson(json.decode(mapUserData["currentChain"]));
//       // migrate
//       if (json.decode(mapUserData["stringWorkspaces"]).runtimeType ==
//           List<dynamic>) {
//         // migrate
//         acWorkspaces = {
//           noneId: json.decode(mapUserData["stringWorkspaces"]).cast<String>(),
//         };
//         workspaceCategories = [ACCategory(id: noneId, title: "なし")];
//       } else {
//         acWorkspaces = json.decode(mapUserData["stringWorkspaces"]);
//         workspaceCategories = ACCategory.jsonToCategories(
//             jsonCategoriesData: mapUserData["workspaceCategories"]);
//       }
//       // current workspace
//       currentWorkspace = ACWorkspace.fromJson(json.decode(
//           acWorkspaces[ACWorkspace.currentWorkspaceCategoryId]![
//               ACWorkspace.currentWorkspaceIndex]));
//       ACVibration.initVibrate();
//       // 保存
//       settingData.saveSettings();
//       ACCategory.saveWorkspaceCategories();
//       ACWorkspace.saveStringWorkspaces();
//       SharedPreferences.getInstance().then((pref) {
//         pref.setString("currentWorkspaceCategoryId",
//             ACWorkspace.currentWorkspaceCategoryId);
//         pref.setInt("currentWorkspaceIndex", ACWorkspace.currentWorkspaceIndex);
//         ;
//       });
//     }

//     settingPageKey.currentState?.setState(() {
//       progress?.dismiss();
//     });
//     settingPageKey.currentState?.setState(() {
//       progress?.showWithText("Importing...");
//     });

//     // 端末にファイルを保存する
//     final importDirectoryO = await getApplicationDocumentsDirectory();
//     httpClientO = (await googleSignIn.authenticatedClient())!;
//     googleDriveApiO = google_drive.DriveApi(httpClientO);
//     await googleDriveApiO.files
//         .list(spaces: 'appDataFolder', $fields: 'files(id, name, createdTime)')
//         .then((listO) async {
//       // ドライブ内にファイルが存在する場合にインポート処理を実行する
//       if (listO.files!.isNotEmpty) {
//         // ドライブ内のファイルを1つずつ処理
//         for (var iO = 0; iO < listO.files!.length; iO++) {
//           // pathを作る
//           final importFilePathO =
//               join(importDirectoryO.path, listO.files![iO].name);
//           print("インポート先のフルパス: $importFilePathO");
//           final importFileO = File(importFilePathO);
//           // Google Drive内のファイルを、idをキーにして取得（ダウンロード）する
//           google_drive.Media? fileO = await googleDriveApiO.files.get(
//                   listO.files![iO].id!,
//                   downloadOptions: google_drive.DownloadOptions.fullMedia)
//               as google_drive.Media?;
//           // 取得したデータを保管するためのリスト
//           List<int> downLoadedDataO = [];
//           // データをダウンロードしながら（Stream処理）、順次、整数の羅列として上記プロパティに保管
//           fileO!.stream.listen(
//             (dataO) {
//               print("DataReceived: ${dataO.length}");
//               downLoadedDataO.insertAll(downLoadedDataO.length, dataO);
//             },
//             // Stream処理の完了後に行う処理をonDone:に書く
//             onDone: () async {
//               // 実際にアプリのデータにする
//               final loadedFile =
//                   await importFileO.writeAsBytes(downLoadedDataO);
//               final retrievedStringUserData = await loadedFile.readAsString();
//               if (justWantInformation) {
//                 final decodedStringUserData =
//                     json.decode(retrievedStringUserData);
//                 simpleAlert(
//                     context: context,
//                     title: "最後にアップロードした\nバックアップの情報",
//                     message:
//                         "日時: ${decodedStringUserData["lastUploadedDateAndTime"] ?? "なし"}\nメモ: ${decodedStringUserData["note"] ?? "なし"}",
//                     buttonText: "OK");
//               } else {
//                 readUserData(stringUserData: retrievedStringUserData);
//                 actionChainAppKey.currentState?.setState(() {});
//                 myPageKey.currentState?.setState(() {});
//                 ACVibration.vibrate();
//                 simpleAlert(
//                     context: context,
//                     title: "復元が完了しました！",
//                     message: "保存されているバックアップからデータを復元することに成功しました!!",
//                     buttonText: "thank you!");
//               }
//               settingPageKey.currentState?.setState(() {
//                 progress?.dismiss();
//               });
//             },
//             onError: (e) {
//               simpleAlert(
//                   context: context,
//                   title: "Error",
//                   message: "message: ${e.toString()}",
//                   buttonText: "OK");
//               settingPageKey.currentState?.setState(() {
//                 progress?.dismiss();
//               });
//             },
//           );
//         }
//       } else {
//         simpleAlert(
//             context: context,
//             title: "Error",
//             message: "現在サインインされているGoogleアカウントにバックアップは保存されていませんでした",
//             buttonText: "OK");
//         settingPageKey.currentState?.setState(() {
//           progress?.dismiss();
//         });
//       }
//     });
//   }

//   // GoogleDriveに保存されているバックアップを削除する
//   // アラートはdeleteボタンに用意してある
//   Future<void> deleteGoogleDriveFiles({required BuildContext context}) async {
//     final progress = ProgressHUD.of(context);
//     settingPageKey.currentState?.setState(() {
//       progress?.showWithText("Checking...");
//     });
//     // Google SignInの処理
//     if (!await _checkIfSigningInWithGoogle()) {
//       simpleAlert(
//           context: context,
//           title: "Error",
//           message: "証情報を初期化する必要が生じたため、サインアウトしてもう一度サインインしてください",
//           buttonText: "OK");
//       settingPageKey.currentState?.setState(() {
//         progress?.dismiss();
//       });
//       return;
//     }
//     settingPageKey.currentState?.setState(() {
//       progress?.dismiss();
//     });
//     settingPageKey.currentState?.setState(() {
//       progress?.showWithText("Deleting...");
//     });
//     httpClientO = (await googleSignIn.authenticatedClient())!;
//     googleDriveApiO = google_drive.DriveApi(httpClientO);
//     await googleDriveApiO.files
//         .list(spaces: 'appDataFolder', $fields: 'files(id, name, createdTime)')
//         .then((savedFiles) async {
//       // ドライブ内にデータがある場合のみ、削除処理を実行
//       if (savedFiles.files!.isNotEmpty) {
//         for (var iO = 0; iO < savedFiles.files!.length; iO++) {
//           await googleDriveApiO.files.delete(savedFiles.files![iO].id!);
//         }
//         ACVibration.vibrate();
//         simpleAlert(
//             context: context,
//             title: "削除することに\n成功しました!",
//             message: "アカウントに保存されているバックアップを削除することに成功しました!!",
//             buttonText: "OK");
//         settingPageKey.currentState?.setState(() {
//           progress?.dismiss();
//         });
//       } else {
//         simpleAlert(
//             context: context,
//             title: "Error",
//             message: "現在サインインされているGoogleアカウントにバックアップは保存されていませんでした",
//             buttonText: "OK");
//         settingPageKey.currentState?.setState(() {
//           progress?.dismiss();
//         });
//       }
//     });
//   }
// }
