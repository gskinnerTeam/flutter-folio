import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_folio/_utils/safe_print.dart';
import 'package:flutter_folio/data/app_user.dart';
import 'package:flutter_folio/services/firebase/firebase_service.dart';

class NativeFirebaseService extends FirebaseService {
  String userId;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;

  DocumentReference get userDoc => firestore.doc(userPath.join("/"));

  @override
  Future<void> init() async {
    await auth.setPersistence(Persistence.LOCAL);
    FirebaseAuth.instance.userChanges().listen((User user) {
      return _isSignedIn = user != null;
    });
    await Firebase.initializeApp().catchError((Object e) {
      print("$e");
    }).then((value) {
      print("InitComplete");
    });
  }

  // Auth
  @override
  Future<AppUser> signIn({String email, String password, bool createAccount = false}) async {
    UserCredential userCreds;
    if (createAccount) {
      userCreds = await auth.createUserWithEmailAndPassword(email: email, password: password);
    } else {
      userCreds = await auth.signInWithEmailAndPassword(email: email, password: password);
    }
    return userCreds == null ? null : AppUser(email: userCreds.user.email, fireId: userCreds.user.uid);
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
    super.signOut();
  }

  @override
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  // Streams
  Stream<Map<String, dynamic>> getDocStream(List<String> keys) {
    return _getDoc(keys).snapshots().map((doc) => doc.data()..['documentId'] = doc.id);
  }

  Stream<List<Map<String, dynamic>>> getListStream(List<String> keys) {
    return _getCollection(keys).snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.docs.map((d) => d.data()..['documentId'] = d.id).toList();
      },
    );
  }

  // CRUD
  @override
  Future<String> addDoc(List<String> keys, Map<String, dynamic> json,
      {String documentId, bool addUserPath = true}) async {
    if (documentId != null) {
      keys.add(documentId);
      safePrint("Add Doc ${getPathFromKeys(keys)}");
      await firestore.doc(getPathFromKeys(keys, addUserPath: addUserPath)).set(json);
      safePrint("Add Doc Complete");
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

  Future<Map<String, dynamic>> getDoc(List<String> keys) async {
    try {
      DocumentSnapshot d = (await _getDoc(keys).get());
      return d.data()..['documentId'] = d.id;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getCollection(List<String> keys) async {
    //print("getDocStream: ${keys.toString()}");
    QuerySnapshot snapshot = (await _getCollection(keys).get());
    snapshot.docs.forEach((d) {
      d.data()..['documentId'] = d.id;
    });
    return snapshot.docs.map((d) => d.data()).toList();
  }

  DocumentReference _getDoc(List<String> keys) {
    if (checkKeysForNull(keys) == false) return null;
    return firestore.doc(getPathFromKeys(keys));
  }

  CollectionReference _getCollection(List<String> keys) {
    if (checkKeysForNull(keys) == false) return null;
    return firestore.collection(getPathFromKeys(keys));
  }
}
