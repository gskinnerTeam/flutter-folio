import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/time_utils.dart';

class NativeFirebaseAuthSpike extends StatefulWidget {
  @override
  _NativeFirebaseAuthSpikeState createState() => _NativeFirebaseAuthSpikeState();
}

class _NativeFirebaseAuthSpikeState extends State<NativeFirebaseAuthSpike> {
  @override
  void initState() {
    super.initState();
    testFirebase();
  }

  Future<void> testFirebase() async {
    print("START TEST ${TimeUtils.nowMillis}");
    FirebaseAuth.instance.userChanges().listen((User user) {
      if (user == null) {
        print('NO USER @ ${TimeUtils.nowMillis}');
      } else {
        print('YES USER! ${TimeUtils.nowMillis}');
      }
    });

    // try {
    //   UserCredential userCredential =
    //       await FirebaseAuth.instance.signInWithEmailAndPassword(email: "shawn@test.com", password: "password");
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     print('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     print('Wrong password provided for that user.');
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [],
      ),
    );
  }
}
