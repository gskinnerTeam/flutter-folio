import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_folio/_utils/logger.dart';
import 'package:flutter_folio/data/app_user.dart';
import 'package:flutter_folio/services/firebase/firebase_service.dart';

class NativeFirebaseService extends FirebaseService {
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;

  DocumentReference get userDoc => firestore.doc(userPath.join("/"));

  @override
  Future<void> init() async {
    await Firebase.initializeApp().catchError((Object e) {
      print("$e");
    });
    if (kIsWeb) {
      await auth.setPersistence(Persistence.LOCAL);
    }
    print("InitComplete");
    FirebaseAuth.instance.userChanges().listen((User? user) {
      _isSignedIn = user != null;
    });
  }

  // Auth
  @override
  Future<AppUser?> signIn({required String email, required String password, bool createAccount = false}) async {
    UserCredential userCreds;
    if (createAccount) {
      userCreds = await auth.createUserWithEmailAndPassword(email: email, password: password);
    } else {
      userCreds = await auth.signInWithEmailAndPassword(email: email, password: password);
    }
    User? user = userCreds.user;
    return user == null ? null : AppUser(email: user.email ?? "", fireId: user.uid);
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
    super.signOut();
  }

  bool _isSignedIn = false;
  @override
  bool get isSignedIn => _isSignedIn;

  // Streams
  @override
  Stream<Map<String, dynamic>>? getDocStream(List<String> keys) {
    return _getDoc(keys)?.snapshots().map((doc) {
      final data = doc.data() ?? {};
      return data..['documentId'] = doc.id;
    });
  }

  @override
  Stream<List<Map<String, dynamic>>>? getListStream(List<String> keys) {
    return _getCollection(keys)?.snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((d) {
          final data = d.data();
          return data..['documentId'] = d.id;
        }).toList();
      },
    );
  }

  // CRUD
  @override
  Future<String> addDoc(List<String> keys, Map<String, dynamic> json,
      {String? documentId, bool addUserPath = true}) async {
    if (documentId != null) {
      keys.add(documentId);
      log("Add Doc ${getPathFromKeys(keys)}");
      await firestore.doc(getPathFromKeys(keys, addUserPath: addUserPath)).set(json);
      log("Add Doc Complete");
      return documentId;
    }
    CollectionReference ref = firestore.collection(getPathFromKeys(keys, addUserPath: addUserPath));
    final doc = await ref.add(json);
    return (doc).id;
  }

  @override
  Future<void> deleteDoc(List<String> keys) async => await firestore.doc(getPathFromKeys(keys)).delete();

  @override
  Future<void> updateDoc(List<String> keys, Map<String, dynamic> json, [bool update = false]) async {
    await firestore.doc(getPathFromKeys(keys)).update(json);
  }

  @override
  Future<Map<String, dynamic>?> getDoc(List<String> keys) async {
    try {
      DocumentSnapshot? d = (await _getDoc(keys)?.get());
      if (d != null) {
        return (d.data() ?? {})..['documentId'] = d.id;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>?> getCollection(List<String> keys) async {
    //print("getDocStream: ${keys.toString()}");
    QuerySnapshot? snapshot = (await _getCollection(keys)?.get());
    if (snapshot != null) {
      for (final d in snapshot.docs) {
        (d.data())['documentId'] = d.id;
      }
    }
    return snapshot?.docs.map((d) => (d.data())).toList();
  }

  DocumentReference? _getDoc(List<String> keys) {
    if (checkKeysForNull(keys) == false) return null;
    return firestore.doc(getPathFromKeys(keys));
  }

  CollectionReference? _getCollection(List<String> keys) {
    if (checkKeysForNull(keys) == false) return null;
    return firestore.collection(getPathFromKeys(keys));
  }
}
