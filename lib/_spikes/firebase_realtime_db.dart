// import 'dart:async';
// import 'dart:io';
//
// import 'package:firebase_auth_rest/firebase_auth_rest.dart';
// import 'package:firebase_database_rest/firebase_database_rest.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_folio/commands/commands.dart';
// import 'package:flutter_folio/core_packages.dart';
// import 'package:flutter_folio/data/app_user.dart';
// import 'package:http/http.dart';
//
// class FirebaseRealtimeDbSpike extends StatefulWidget {
//   @override
//   _FirebaseRealtimeDbSpikeState createState() => _FirebaseRealtimeDbSpikeState();
// }
//
// class _FirebaseRealtimeDbSpikeState extends State<FirebaseRealtimeDbSpike> with SingleTickerProviderStateMixin {
//   FirebaseAuth? _auth;
//   FirebaseDatabase? _db;
//   FirebaseAccount? _acct;
//   Client? _client;
//   String _errorMsg = "";
//   StreamSubscription<StoreEvent<AppUser>>? _rootStoreStream;
//   FirebaseStore<AppUser>? _rootStore;
//
//   void signIn() async {
//     setState(() => _errorMsg = "");
//     _client = Client();
//     _auth = FirebaseAuth(_client!, "AIzaSyDIMnzUz9TshIyRSSl7iUpp5QxPhAcL1ZQ");
//     try {
//       FirebaseAccount account = await _auth!.signInWithPassword("shawn1@test.com", "password");
//       _db = FirebaseDatabase(
//         account: account,
//         database: 'flutter-folio-demo-default-rtdb',
//         basePath: 'demo-app/',
//       );
//       _rootStore = _db!.createRootStore<AppUser>(
//           onDataFromJson: (dynamic json) => AppUser.fromJson(json as Map<String, dynamic>),
//           onDataToJson: (AppUser data) => data.toJson(),
//           onPatchData: (AppUser data, updatedFields) {
//             print(updatedFields);
//             return data;
//           });
//       _acct = account;
//       // Listen to root store
//       _rootStoreStream = (await _rootStore!.streamAll()).listen((e) => print('Stream update: $e'));
//       print('All data: ${await _rootStore!.all()}');
//     } on Exception catch (e) {
//       if (e is AuthException) {
//         if (e.error.message == "EMAIL_NOT_FOUND") _errorMsg = "Email not found.";
//         if (e.error.message == "INVALID_PASSWORD") _errorMsg = "Password is incorrect.";
//         print(e.error.message);
//       }
//     }
//     setState(() {});
//   }
//
//   void signOut() {
//     _acct = null;
//     _client?.close();
//     _rootStoreStream?.cancel();
//     _db?.dispose();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Column(
//       children: [
//         PrimaryBtn(label: "Sign In", onPressed: signIn),
//         PrimaryBtn(label: "Sign Out", onPressed: signOut),
//         Text("Current User = ${_acct}"),
//         Text(_errorMsg),
//         if (_acct != null) ...[
//           PrimaryBtn(
//               label: "Create User",
//               onPressed: () async {
//                 AppUser user = AppUser(fireId: _acct!.localId, email: "shawn@test.com");
//                 await _rootStore!.update(_acct!.localId, user.toJson());
//               }),
//         ]
//       ],
//     ));
//   }
// }
