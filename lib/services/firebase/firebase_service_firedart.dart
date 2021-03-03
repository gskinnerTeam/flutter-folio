import 'dart:convert';

import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/app_user.dart';
import 'package:flutter_folio/services/firebase/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DartFirebaseService extends FirebaseService {
  DartFirebaseService({this.apiKey, this.projectId});
  final String apiKey;
  final String projectId;
  bool _isSignedIn = false;

  Firestore get firestore => Firestore.instance;

  DocumentReference get userDoc => firestore.document(userPath.join("/"));

  Future<void> init() async {
    final prefsStore = await PreferencesStore.create();
    FirebaseAuth.initialize(apiKey, prefsStore);
    Firestore.initialize(projectId);
    _isSignedIn = FirebaseAuth.instance.isSignedIn;
  }

  /// //////////////////////////////
  /// Auth
  @override
  Future<AppUser> signIn({String email, String password, bool createAccount = false}) async {
    User user;
    if (createAccount) {
      user = await FirebaseAuth.instance.signUp(email, password);
    } else {
      user = await FirebaseAuth.instance.signIn(email, password);
    }
    _isSignedIn = true;
    return AppUser(email: user.email, fireId: user.id);
  }

  @override
  Future<void> signOut() async {
    super.signOut();
    _isSignedIn = false;
  }

  bool get isSignedIn => _isSignedIn;

  /// ///////////////////////////////
  /// CRUD
  Future<Map<String, dynamic>> getDoc(List<String> keys) async {
    //print("getDocData: ${keys.toString()}");
    try {
      Document d = (await _getDoc(keys).get());
      return d.map..['documentId'] = d.id;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getCollection(List<String> keys) async {
    //print("getDocStream: ${keys.toString()}");
    Page<Document> docs = (await _getCollection(keys).get());
    docs.forEach((d) {
      d.map..['documentId'] = d.id;
    });
    return docs.map((d) => d.map).toList();
  }

  // Streams
  Stream<Map<String, dynamic>> getDocStream(List<String> keys) {
    //print("getDocStream: ${keys.toString()}");
    return _getDoc(keys).stream.map((d) => d.map..['documentId'] = d.id);
  }

  Stream<List<Map<String, dynamic>>> getListStream(List<String> keys) {
    //print("getListStream: ${keys.toString()}");
    return _getCollection(keys).stream.map(
      (List<Document> docs) {
        return (docs ?? []).map((d) => d.map..['documentId'] = d.id).toList();
      },
    );
  }

  @override
  Future<String> addDoc(List<String> keys, Map<String, dynamic> json,
      {String documentId, bool addUserPath = true}) async {
    if (documentId != null) {
      keys.add(documentId);
      //safePrint("Add Doc ${getPathFromKeys(keys)}");
      await firestore.document(getPathFromKeys(keys, addUserPath: addUserPath)).update(json);
      //safePrint("Add Doc Complete");
      return documentId;
    }
    CollectionReference ref = firestore.collection(getPathFromKeys(keys, addUserPath: addUserPath));
    final doc = await ref.add(json);
    return (doc).id;
  }

  @override
  Future<void> deleteDoc(List<String> keys) async {
    await firestore.document(getPathFromKeys(keys)).delete().catchError((Object e) {
      print(e);
    });
  }

  @override
  Future<void> updateDoc(List<String> keys, Map<String, dynamic> json, [bool update = false]) async {
    await firestore.document(getPathFromKeys(keys)).update(json);
  }

  DocumentReference _getDoc(List<String> keys) {
    if (checkKeysForNull(keys) == false) return null;
    DocumentReference docRef = firestore.document(getPathFromKeys(keys));
    //print("getDoc: " + docRef.path);
    return docRef;
  }

  CollectionReference _getCollection(List<String> keys) {
    if (checkKeysForNull(keys) == false) return null;
    final colRef = firestore.collection(getPathFromKeys(keys));
    //print("Got path: " + colRef.path);
    return colRef;
  }
}

class PreferencesStore extends TokenStore {
  static const keyToken = "auth_token";

  static Future<PreferencesStore> create() async => PreferencesStore._internal(await SharedPreferences.getInstance());

  SharedPreferences _prefs;

  PreferencesStore._internal(this._prefs);

  @override
  Token read() => _prefs.containsKey(keyToken)
      ? Token.fromMap(json.decode(_prefs.get(keyToken) as String) as Map<String, dynamic>)
      : null;

  @override
  void write(Token token) {
    _prefs.setString(keyToken, json.encode(token.toMap()));
  }

  @override
  void delete() => _prefs.remove(keyToken);
}
