import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  static String kDefaultImageUrl =
      "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=50&q=80";
  const AppUser._();
  factory AppUser({
    @Default("") String documentId,
    required String email,
    required String fireId,
    String? firstName,
    String? lastName,
    String? imageUrl,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  String? getDisplayName() {
    String? result = firstName;
    if (StringUtils.isNotEmpty(lastName)) result = (result ?? "") + " $lastName";
    return result;
  }
}
