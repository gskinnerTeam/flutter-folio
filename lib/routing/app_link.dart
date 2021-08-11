// A data object that represents a link inside our app
// Can serialize itself to and from a location string like /book/23/ or ?book=23
import 'dart:convert';

import 'package:flutter_folio/core_packages.dart';

class AppLink {
  static const String kBookParam = "bk";
  static const String kPageParam = "pg";
  static const String kUserParam = "u";
  static final Codec<String, String> _stringToBase64 = utf8.fuse(base64);

  AppLink({this.pageId, this.bookId, this.user});
  String? pageId;
  String? bookId;
  String? user;

  static String? encode(String? s) {
    if (s == null) return null;
    return _stringToBase64.encode(s);
    //return s;
  }

  static String? decode(String? s) {
    if (s == null) return null;
    return _stringToBase64.decode(s);
    //return s;
  }

  static AppLink fromLocation(String? location) {
    location = Uri.decodeFull(location ?? "");
    Map<String, String> params = Uri.parse(location).queryParameters;
    // Shared function to inject keys if they are not null
    void trySet(String key, void Function(String) setter) {
      if (params.containsKey(key)) setter.call(params[key]!);
    }

    log("parse-fromLocation: $location");
    // Create the applink, inject any params we've found
    AppLink link = AppLink();
    trySet(AppLink.kBookParam, (s) => link.bookId = s);
    trySet(AppLink.kPageParam, (s) => link.pageId = s);
    trySet(AppLink.kUserParam, (s) => link.user = decode(s));
    return link;
  }

  String toLocation() {
    String addKeyValPair({required String key, String? value}) => value == null ? "" : "$key=$value&";
    String loc = "/?";
    loc += addKeyValPair(key: kBookParam, value: bookId);
    loc += addKeyValPair(key: kPageParam, value: pageId);
    // Encode the userId just to avoid passing around plaintext user id's
    loc += addKeyValPair(key: kUserParam, value: encode(user));
    return Uri.encodeFull(loc);
  }
}
