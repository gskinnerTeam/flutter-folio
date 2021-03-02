// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return _AppUser.fromJson(json);
}

/// @nodoc
class _$AppUserTearOff {
  const _$AppUserTearOff();

// ignore: unused_element
  _AppUser call(
      {@nullable String documentId,
      @required String email,
      @required String fireId,
      String firstName,
      String lastName,
      String imageUrl}) {
    return _AppUser(
      documentId: documentId,
      email: email,
      fireId: fireId,
      firstName: firstName,
      lastName: lastName,
      imageUrl: imageUrl,
    );
  }

// ignore: unused_element
  AppUser fromJson(Map<String, Object> json) {
    return AppUser.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $AppUser = _$AppUserTearOff();

/// @nodoc
mixin _$AppUser {
  @nullable
  String get documentId;
  String get email;
  String get fireId;
  String get firstName;
  String get lastName;
  String get imageUrl;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $AppUserCopyWith<AppUser> get copyWith;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) =
      _$AppUserCopyWithImpl<$Res>;
  $Res call(
      {@nullable String documentId,
      String email,
      String fireId,
      String firstName,
      String lastName,
      String imageUrl});
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res> implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  final AppUser _value;
  // ignore: unused_field
  final $Res Function(AppUser) _then;

  @override
  $Res call({
    Object documentId = freezed,
    Object email = freezed,
    Object fireId = freezed,
    Object firstName = freezed,
    Object lastName = freezed,
    Object imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      documentId:
          documentId == freezed ? _value.documentId : documentId as String,
      email: email == freezed ? _value.email : email as String,
      fireId: fireId == freezed ? _value.fireId : fireId as String,
      firstName: firstName == freezed ? _value.firstName : firstName as String,
      lastName: lastName == freezed ? _value.lastName : lastName as String,
      imageUrl: imageUrl == freezed ? _value.imageUrl : imageUrl as String,
    ));
  }
}

/// @nodoc
abstract class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) then) =
      __$AppUserCopyWithImpl<$Res>;
  @override
  $Res call(
      {@nullable String documentId,
      String email,
      String fireId,
      String firstName,
      String lastName,
      String imageUrl});
}

/// @nodoc
class __$AppUserCopyWithImpl<$Res> extends _$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(_AppUser _value, $Res Function(_AppUser) _then)
      : super(_value, (v) => _then(v as _AppUser));

  @override
  _AppUser get _value => super._value as _AppUser;

  @override
  $Res call({
    Object documentId = freezed,
    Object email = freezed,
    Object fireId = freezed,
    Object firstName = freezed,
    Object lastName = freezed,
    Object imageUrl = freezed,
  }) {
    return _then(_AppUser(
      documentId:
          documentId == freezed ? _value.documentId : documentId as String,
      email: email == freezed ? _value.email : email as String,
      fireId: fireId == freezed ? _value.fireId : fireId as String,
      firstName: firstName == freezed ? _value.firstName : firstName as String,
      lastName: lastName == freezed ? _value.lastName : lastName as String,
      imageUrl: imageUrl == freezed ? _value.imageUrl : imageUrl as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_AppUser extends _AppUser {
  _$_AppUser(
      {@nullable this.documentId,
      @required this.email,
      @required this.fireId,
      this.firstName,
      this.lastName,
      this.imageUrl})
      : assert(email != null),
        assert(fireId != null),
        super._();

  factory _$_AppUser.fromJson(Map<String, dynamic> json) =>
      _$_$_AppUserFromJson(json);

  @override
  @nullable
  final String documentId;
  @override
  final String email;
  @override
  final String fireId;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String imageUrl;

  @override
  String toString() {
    return 'AppUser(documentId: $documentId, email: $email, fireId: $fireId, firstName: $firstName, lastName: $lastName, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AppUser &&
            (identical(other.documentId, documentId) ||
                const DeepCollectionEquality()
                    .equals(other.documentId, documentId)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.fireId, fireId) ||
                const DeepCollectionEquality().equals(other.fireId, fireId)) &&
            (identical(other.firstName, firstName) ||
                const DeepCollectionEquality()
                    .equals(other.firstName, firstName)) &&
            (identical(other.lastName, lastName) ||
                const DeepCollectionEquality()
                    .equals(other.lastName, lastName)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(documentId) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(fireId) ^
      const DeepCollectionEquality().hash(firstName) ^
      const DeepCollectionEquality().hash(lastName) ^
      const DeepCollectionEquality().hash(imageUrl);

  @JsonKey(ignore: true)
  @override
  _$AppUserCopyWith<_AppUser> get copyWith =>
      __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AppUserToJson(this);
  }
}

abstract class _AppUser extends AppUser {
  _AppUser._() : super._();
  factory _AppUser(
      {@nullable String documentId,
      @required String email,
      @required String fireId,
      String firstName,
      String lastName,
      String imageUrl}) = _$_AppUser;

  factory _AppUser.fromJson(Map<String, dynamic> json) = _$_AppUser.fromJson;

  @override
  @nullable
  String get documentId;
  @override
  String get email;
  @override
  String get fireId;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$AppUserCopyWith<_AppUser> get copyWith;
}
