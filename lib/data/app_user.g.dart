// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppUser _$_$_AppUserFromJson(Map<String, dynamic> json) {
  return _$_AppUser(
    documentId: json['documentId'] as String? ?? '',
    email: json['email'] as String,
    fireId: json['fireId'] as String,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    imageUrl: json['imageUrl'] as String?,
  );
}

Map<String, dynamic> _$_$_AppUserToJson(_$_AppUser instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'email': instance.email,
      'fireId': instance.fireId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'imageUrl': instance.imageUrl,
    };
