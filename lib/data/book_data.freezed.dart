// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'book_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ScrapBookData _$ScrapBookDataFromJson(Map<String, dynamic> json) {
  return _ScrapBookData.fromJson(json);
}

/// @nodoc
class _$ScrapBookDataTearOff {
  const _$ScrapBookDataTearOff();

// ignore: unused_element
  _ScrapBookData call(
      {@nullable String documentId,
      @nullable String key,
      String title = "",
      String desc = "",
      int creationTime = -1,
      int lastModifiedTime = -1,
      int pageCount = 0,
      @nullable String imageUrl = "",
      List<String> pageOrder}) {
    return _ScrapBookData(
      documentId: documentId,
      key: key,
      title: title,
      desc: desc,
      creationTime: creationTime,
      lastModifiedTime: lastModifiedTime,
      pageCount: pageCount,
      imageUrl: imageUrl,
      pageOrder: pageOrder,
    );
  }

// ignore: unused_element
  ScrapBookData fromJson(Map<String, Object> json) {
    return ScrapBookData.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $ScrapBookData = _$ScrapBookDataTearOff();

/// @nodoc
mixin _$ScrapBookData {
  @nullable
  String get documentId;
  @nullable
  String get key;
  String get title;
  String get desc;
  int get creationTime;
  int get lastModifiedTime;
  int get pageCount;
  @nullable
  String get imageUrl;
  List<String> get pageOrder;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $ScrapBookDataCopyWith<ScrapBookData> get copyWith;
}

/// @nodoc
abstract class $ScrapBookDataCopyWith<$Res> {
  factory $ScrapBookDataCopyWith(
          ScrapBookData value, $Res Function(ScrapBookData) then) =
      _$ScrapBookDataCopyWithImpl<$Res>;
  $Res call(
      {@nullable String documentId,
      @nullable String key,
      String title,
      String desc,
      int creationTime,
      int lastModifiedTime,
      int pageCount,
      @nullable String imageUrl,
      List<String> pageOrder});
}

/// @nodoc
class _$ScrapBookDataCopyWithImpl<$Res>
    implements $ScrapBookDataCopyWith<$Res> {
  _$ScrapBookDataCopyWithImpl(this._value, this._then);

  final ScrapBookData _value;
  // ignore: unused_field
  final $Res Function(ScrapBookData) _then;

  @override
  $Res call({
    Object documentId = freezed,
    Object key = freezed,
    Object title = freezed,
    Object desc = freezed,
    Object creationTime = freezed,
    Object lastModifiedTime = freezed,
    Object pageCount = freezed,
    Object imageUrl = freezed,
    Object pageOrder = freezed,
  }) {
    return _then(_value.copyWith(
      documentId:
          documentId == freezed ? _value.documentId : documentId as String,
      key: key == freezed ? _value.key : key as String,
      title: title == freezed ? _value.title : title as String,
      desc: desc == freezed ? _value.desc : desc as String,
      creationTime:
          creationTime == freezed ? _value.creationTime : creationTime as int,
      lastModifiedTime: lastModifiedTime == freezed
          ? _value.lastModifiedTime
          : lastModifiedTime as int,
      pageCount: pageCount == freezed ? _value.pageCount : pageCount as int,
      imageUrl: imageUrl == freezed ? _value.imageUrl : imageUrl as String,
      pageOrder:
          pageOrder == freezed ? _value.pageOrder : pageOrder as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$ScrapBookDataCopyWith<$Res>
    implements $ScrapBookDataCopyWith<$Res> {
  factory _$ScrapBookDataCopyWith(
          _ScrapBookData value, $Res Function(_ScrapBookData) then) =
      __$ScrapBookDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {@nullable String documentId,
      @nullable String key,
      String title,
      String desc,
      int creationTime,
      int lastModifiedTime,
      int pageCount,
      @nullable String imageUrl,
      List<String> pageOrder});
}

/// @nodoc
class __$ScrapBookDataCopyWithImpl<$Res>
    extends _$ScrapBookDataCopyWithImpl<$Res>
    implements _$ScrapBookDataCopyWith<$Res> {
  __$ScrapBookDataCopyWithImpl(
      _ScrapBookData _value, $Res Function(_ScrapBookData) _then)
      : super(_value, (v) => _then(v as _ScrapBookData));

  @override
  _ScrapBookData get _value => super._value as _ScrapBookData;

  @override
  $Res call({
    Object documentId = freezed,
    Object key = freezed,
    Object title = freezed,
    Object desc = freezed,
    Object creationTime = freezed,
    Object lastModifiedTime = freezed,
    Object pageCount = freezed,
    Object imageUrl = freezed,
    Object pageOrder = freezed,
  }) {
    return _then(_ScrapBookData(
      documentId:
          documentId == freezed ? _value.documentId : documentId as String,
      key: key == freezed ? _value.key : key as String,
      title: title == freezed ? _value.title : title as String,
      desc: desc == freezed ? _value.desc : desc as String,
      creationTime:
          creationTime == freezed ? _value.creationTime : creationTime as int,
      lastModifiedTime: lastModifiedTime == freezed
          ? _value.lastModifiedTime
          : lastModifiedTime as int,
      pageCount: pageCount == freezed ? _value.pageCount : pageCount as int,
      imageUrl: imageUrl == freezed ? _value.imageUrl : imageUrl as String,
      pageOrder:
          pageOrder == freezed ? _value.pageOrder : pageOrder as List<String>,
    ));
  }
}

@JsonSerializable(explicitToJson: true)

/// @nodoc
class _$_ScrapBookData extends _ScrapBookData with DiagnosticableTreeMixin {
  _$_ScrapBookData(
      {@nullable this.documentId,
      @nullable this.key,
      this.title = "",
      this.desc = "",
      this.creationTime = -1,
      this.lastModifiedTime = -1,
      this.pageCount = 0,
      @nullable this.imageUrl = "",
      this.pageOrder})
      : assert(title != null),
        assert(desc != null),
        assert(creationTime != null),
        assert(lastModifiedTime != null),
        assert(pageCount != null),
        super._();

  factory _$_ScrapBookData.fromJson(Map<String, dynamic> json) =>
      _$_$_ScrapBookDataFromJson(json);

  @override
  @nullable
  final String documentId;
  @override
  @nullable
  final String key;
  @JsonKey(defaultValue: "")
  @override
  final String title;
  @JsonKey(defaultValue: "")
  @override
  final String desc;
  @JsonKey(defaultValue: -1)
  @override
  final int creationTime;
  @JsonKey(defaultValue: -1)
  @override
  final int lastModifiedTime;
  @JsonKey(defaultValue: 0)
  @override
  final int pageCount;
  @JsonKey(defaultValue: "")
  @override
  @nullable
  final String imageUrl;
  @override
  final List<String> pageOrder;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScrapBookData(documentId: $documentId, key: $key, title: $title, desc: $desc, creationTime: $creationTime, lastModifiedTime: $lastModifiedTime, pageCount: $pageCount, imageUrl: $imageUrl, pageOrder: $pageOrder)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScrapBookData'))
      ..add(DiagnosticsProperty('documentId', documentId))
      ..add(DiagnosticsProperty('key', key))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('desc', desc))
      ..add(DiagnosticsProperty('creationTime', creationTime))
      ..add(DiagnosticsProperty('lastModifiedTime', lastModifiedTime))
      ..add(DiagnosticsProperty('pageCount', pageCount))
      ..add(DiagnosticsProperty('imageUrl', imageUrl))
      ..add(DiagnosticsProperty('pageOrder', pageOrder));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ScrapBookData &&
            (identical(other.documentId, documentId) ||
                const DeepCollectionEquality()
                    .equals(other.documentId, documentId)) &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.desc, desc) ||
                const DeepCollectionEquality().equals(other.desc, desc)) &&
            (identical(other.creationTime, creationTime) ||
                const DeepCollectionEquality()
                    .equals(other.creationTime, creationTime)) &&
            (identical(other.lastModifiedTime, lastModifiedTime) ||
                const DeepCollectionEquality()
                    .equals(other.lastModifiedTime, lastModifiedTime)) &&
            (identical(other.pageCount, pageCount) ||
                const DeepCollectionEquality()
                    .equals(other.pageCount, pageCount)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.pageOrder, pageOrder) ||
                const DeepCollectionEquality()
                    .equals(other.pageOrder, pageOrder)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(documentId) ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(desc) ^
      const DeepCollectionEquality().hash(creationTime) ^
      const DeepCollectionEquality().hash(lastModifiedTime) ^
      const DeepCollectionEquality().hash(pageCount) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(pageOrder);

  @JsonKey(ignore: true)
  @override
  _$ScrapBookDataCopyWith<_ScrapBookData> get copyWith =>
      __$ScrapBookDataCopyWithImpl<_ScrapBookData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ScrapBookDataToJson(this);
  }
}

abstract class _ScrapBookData extends ScrapBookData {
  _ScrapBookData._() : super._();
  factory _ScrapBookData(
      {@nullable String documentId,
      @nullable String key,
      String title,
      String desc,
      int creationTime,
      int lastModifiedTime,
      int pageCount,
      @nullable String imageUrl,
      List<String> pageOrder}) = _$_ScrapBookData;

  factory _ScrapBookData.fromJson(Map<String, dynamic> json) =
      _$_ScrapBookData.fromJson;

  @override
  @nullable
  String get documentId;
  @override
  @nullable
  String get key;
  @override
  String get title;
  @override
  String get desc;
  @override
  int get creationTime;
  @override
  int get lastModifiedTime;
  @override
  int get pageCount;
  @override
  @nullable
  String get imageUrl;
  @override
  List<String> get pageOrder;
  @override
  @JsonKey(ignore: true)
  _$ScrapBookDataCopyWith<_ScrapBookData> get copyWith;
}

ScrapPageData _$ScrapPageDataFromJson(Map<String, dynamic> json) {
  return _ScrapPageData.fromJson(json);
}

/// @nodoc
class _$ScrapPageDataTearOff {
  const _$ScrapPageDataTearOff();

// ignore: unused_element
  _ScrapPageData call(
      {@nullable String documentId,
      @nullable String key,
      String bookId,
      String title = "",
      String desc = "",
      List<String> boxOrder}) {
    return _ScrapPageData(
      documentId: documentId,
      key: key,
      bookId: bookId,
      title: title,
      desc: desc,
      boxOrder: boxOrder,
    );
  }

// ignore: unused_element
  ScrapPageData fromJson(Map<String, Object> json) {
    return ScrapPageData.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $ScrapPageData = _$ScrapPageDataTearOff();

/// @nodoc
mixin _$ScrapPageData {
  @nullable
  String get documentId;
  @nullable
  String get key;
  String get bookId;
  String get title;
  String get desc;
  List<String> get boxOrder;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $ScrapPageDataCopyWith<ScrapPageData> get copyWith;
}

/// @nodoc
abstract class $ScrapPageDataCopyWith<$Res> {
  factory $ScrapPageDataCopyWith(
          ScrapPageData value, $Res Function(ScrapPageData) then) =
      _$ScrapPageDataCopyWithImpl<$Res>;
  $Res call(
      {@nullable String documentId,
      @nullable String key,
      String bookId,
      String title,
      String desc,
      List<String> boxOrder});
}

/// @nodoc
class _$ScrapPageDataCopyWithImpl<$Res>
    implements $ScrapPageDataCopyWith<$Res> {
  _$ScrapPageDataCopyWithImpl(this._value, this._then);

  final ScrapPageData _value;
  // ignore: unused_field
  final $Res Function(ScrapPageData) _then;

  @override
  $Res call({
    Object documentId = freezed,
    Object key = freezed,
    Object bookId = freezed,
    Object title = freezed,
    Object desc = freezed,
    Object boxOrder = freezed,
  }) {
    return _then(_value.copyWith(
      documentId:
          documentId == freezed ? _value.documentId : documentId as String,
      key: key == freezed ? _value.key : key as String,
      bookId: bookId == freezed ? _value.bookId : bookId as String,
      title: title == freezed ? _value.title : title as String,
      desc: desc == freezed ? _value.desc : desc as String,
      boxOrder:
          boxOrder == freezed ? _value.boxOrder : boxOrder as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$ScrapPageDataCopyWith<$Res>
    implements $ScrapPageDataCopyWith<$Res> {
  factory _$ScrapPageDataCopyWith(
          _ScrapPageData value, $Res Function(_ScrapPageData) then) =
      __$ScrapPageDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {@nullable String documentId,
      @nullable String key,
      String bookId,
      String title,
      String desc,
      List<String> boxOrder});
}

/// @nodoc
class __$ScrapPageDataCopyWithImpl<$Res>
    extends _$ScrapPageDataCopyWithImpl<$Res>
    implements _$ScrapPageDataCopyWith<$Res> {
  __$ScrapPageDataCopyWithImpl(
      _ScrapPageData _value, $Res Function(_ScrapPageData) _then)
      : super(_value, (v) => _then(v as _ScrapPageData));

  @override
  _ScrapPageData get _value => super._value as _ScrapPageData;

  @override
  $Res call({
    Object documentId = freezed,
    Object key = freezed,
    Object bookId = freezed,
    Object title = freezed,
    Object desc = freezed,
    Object boxOrder = freezed,
  }) {
    return _then(_ScrapPageData(
      documentId:
          documentId == freezed ? _value.documentId : documentId as String,
      key: key == freezed ? _value.key : key as String,
      bookId: bookId == freezed ? _value.bookId : bookId as String,
      title: title == freezed ? _value.title : title as String,
      desc: desc == freezed ? _value.desc : desc as String,
      boxOrder:
          boxOrder == freezed ? _value.boxOrder : boxOrder as List<String>,
    ));
  }
}

@JsonSerializable(explicitToJson: true)

/// @nodoc
class _$_ScrapPageData extends _ScrapPageData with DiagnosticableTreeMixin {
  _$_ScrapPageData(
      {@nullable this.documentId,
      @nullable this.key,
      this.bookId,
      this.title = "",
      this.desc = "",
      this.boxOrder})
      : assert(title != null),
        assert(desc != null),
        super._();

  factory _$_ScrapPageData.fromJson(Map<String, dynamic> json) =>
      _$_$_ScrapPageDataFromJson(json);

  @override
  @nullable
  final String documentId;
  @override
  @nullable
  final String key;
  @override
  final String bookId;
  @JsonKey(defaultValue: "")
  @override
  final String title;
  @JsonKey(defaultValue: "")
  @override
  final String desc;
  @override
  final List<String> boxOrder;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScrapPageData(documentId: $documentId, key: $key, bookId: $bookId, title: $title, desc: $desc, boxOrder: $boxOrder)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScrapPageData'))
      ..add(DiagnosticsProperty('documentId', documentId))
      ..add(DiagnosticsProperty('key', key))
      ..add(DiagnosticsProperty('bookId', bookId))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('desc', desc))
      ..add(DiagnosticsProperty('boxOrder', boxOrder));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ScrapPageData &&
            (identical(other.documentId, documentId) ||
                const DeepCollectionEquality()
                    .equals(other.documentId, documentId)) &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.bookId, bookId) ||
                const DeepCollectionEquality().equals(other.bookId, bookId)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.desc, desc) ||
                const DeepCollectionEquality().equals(other.desc, desc)) &&
            (identical(other.boxOrder, boxOrder) ||
                const DeepCollectionEquality()
                    .equals(other.boxOrder, boxOrder)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(documentId) ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(bookId) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(desc) ^
      const DeepCollectionEquality().hash(boxOrder);

  @JsonKey(ignore: true)
  @override
  _$ScrapPageDataCopyWith<_ScrapPageData> get copyWith =>
      __$ScrapPageDataCopyWithImpl<_ScrapPageData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ScrapPageDataToJson(this);
  }
}

abstract class _ScrapPageData extends ScrapPageData {
  _ScrapPageData._() : super._();
  factory _ScrapPageData(
      {@nullable String documentId,
      @nullable String key,
      String bookId,
      String title,
      String desc,
      List<String> boxOrder}) = _$_ScrapPageData;

  factory _ScrapPageData.fromJson(Map<String, dynamic> json) =
      _$_ScrapPageData.fromJson;

  @override
  @nullable
  String get documentId;
  @override
  @nullable
  String get key;
  @override
  String get bookId;
  @override
  String get title;
  @override
  String get desc;
  @override
  List<String> get boxOrder;
  @override
  @JsonKey(ignore: true)
  _$ScrapPageDataCopyWith<_ScrapPageData> get copyWith;
}

ScrapItem _$ScrapItemFromJson(Map<String, dynamic> json) {
  return _ScrapItem.fromJson(json);
}

/// @nodoc
class _$ScrapItemTearOff {
  const _$ScrapItemTearOff();

// ignore: unused_element
  _ScrapItem call(
      {@nullable String documentId,
      @nullable String key,
      String bookId,
      @nullable String data,
      @nullable String config,
      List<String> photos = const [],
      int creationTime = -1,
      double aspect = 1,
      @nullable ContentType contentType}) {
    return _ScrapItem(
      documentId: documentId,
      key: key,
      bookId: bookId,
      data: data,
      config: config,
      photos: photos,
      creationTime: creationTime,
      aspect: aspect,
      contentType: contentType,
    );
  }

// ignore: unused_element
  ScrapItem fromJson(Map<String, Object> json) {
    return ScrapItem.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $ScrapItem = _$ScrapItemTearOff();

/// @nodoc
mixin _$ScrapItem {
  @nullable
  String get documentId;
  @nullable
  String get key;
  String get bookId;
  @nullable
  String get data;
  @nullable
  String get config;
  List<String> get photos;
  int get creationTime;
  double get aspect;
  @nullable
  ContentType get contentType;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $ScrapItemCopyWith<ScrapItem> get copyWith;
}

/// @nodoc
abstract class $ScrapItemCopyWith<$Res> {
  factory $ScrapItemCopyWith(ScrapItem value, $Res Function(ScrapItem) then) =
      _$ScrapItemCopyWithImpl<$Res>;
  $Res call(
      {@nullable String documentId,
      @nullable String key,
      String bookId,
      @nullable String data,
      @nullable String config,
      List<String> photos,
      int creationTime,
      double aspect,
      @nullable ContentType contentType});
}

/// @nodoc
class _$ScrapItemCopyWithImpl<$Res> implements $ScrapItemCopyWith<$Res> {
  _$ScrapItemCopyWithImpl(this._value, this._then);

  final ScrapItem _value;
  // ignore: unused_field
  final $Res Function(ScrapItem) _then;

  @override
  $Res call({
    Object documentId = freezed,
    Object key = freezed,
    Object bookId = freezed,
    Object data = freezed,
    Object config = freezed,
    Object photos = freezed,
    Object creationTime = freezed,
    Object aspect = freezed,
    Object contentType = freezed,
  }) {
    return _then(_value.copyWith(
      documentId:
          documentId == freezed ? _value.documentId : documentId as String,
      key: key == freezed ? _value.key : key as String,
      bookId: bookId == freezed ? _value.bookId : bookId as String,
      data: data == freezed ? _value.data : data as String,
      config: config == freezed ? _value.config : config as String,
      photos: photos == freezed ? _value.photos : photos as List<String>,
      creationTime:
          creationTime == freezed ? _value.creationTime : creationTime as int,
      aspect: aspect == freezed ? _value.aspect : aspect as double,
      contentType: contentType == freezed
          ? _value.contentType
          : contentType as ContentType,
    ));
  }
}

/// @nodoc
abstract class _$ScrapItemCopyWith<$Res> implements $ScrapItemCopyWith<$Res> {
  factory _$ScrapItemCopyWith(
          _ScrapItem value, $Res Function(_ScrapItem) then) =
      __$ScrapItemCopyWithImpl<$Res>;
  @override
  $Res call(
      {@nullable String documentId,
      @nullable String key,
      String bookId,
      @nullable String data,
      @nullable String config,
      List<String> photos,
      int creationTime,
      double aspect,
      @nullable ContentType contentType});
}

/// @nodoc
class __$ScrapItemCopyWithImpl<$Res> extends _$ScrapItemCopyWithImpl<$Res>
    implements _$ScrapItemCopyWith<$Res> {
  __$ScrapItemCopyWithImpl(_ScrapItem _value, $Res Function(_ScrapItem) _then)
      : super(_value, (v) => _then(v as _ScrapItem));

  @override
  _ScrapItem get _value => super._value as _ScrapItem;

  @override
  $Res call({
    Object documentId = freezed,
    Object key = freezed,
    Object bookId = freezed,
    Object data = freezed,
    Object config = freezed,
    Object photos = freezed,
    Object creationTime = freezed,
    Object aspect = freezed,
    Object contentType = freezed,
  }) {
    return _then(_ScrapItem(
      documentId:
          documentId == freezed ? _value.documentId : documentId as String,
      key: key == freezed ? _value.key : key as String,
      bookId: bookId == freezed ? _value.bookId : bookId as String,
      data: data == freezed ? _value.data : data as String,
      config: config == freezed ? _value.config : config as String,
      photos: photos == freezed ? _value.photos : photos as List<String>,
      creationTime:
          creationTime == freezed ? _value.creationTime : creationTime as int,
      aspect: aspect == freezed ? _value.aspect : aspect as double,
      contentType: contentType == freezed
          ? _value.contentType
          : contentType as ContentType,
    ));
  }
}

@JsonSerializable(explicitToJson: true)

/// @nodoc
class _$_ScrapItem extends _ScrapItem with DiagnosticableTreeMixin {
  _$_ScrapItem(
      {@nullable this.documentId,
      @nullable this.key,
      this.bookId,
      @nullable this.data,
      @nullable this.config,
      this.photos = const [],
      this.creationTime = -1,
      this.aspect = 1,
      @nullable this.contentType})
      : assert(photos != null),
        assert(creationTime != null),
        assert(aspect != null),
        super._();

  factory _$_ScrapItem.fromJson(Map<String, dynamic> json) =>
      _$_$_ScrapItemFromJson(json);

  @override
  @nullable
  final String documentId;
  @override
  @nullable
  final String key;
  @override
  final String bookId;
  @override
  @nullable
  final String data;
  @override
  @nullable
  final String config;
  @JsonKey(defaultValue: const [])
  @override
  final List<String> photos;
  @JsonKey(defaultValue: -1)
  @override
  final int creationTime;
  @JsonKey(defaultValue: 1)
  @override
  final double aspect;
  @override
  @nullable
  final ContentType contentType;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScrapItem(documentId: $documentId, key: $key, bookId: $bookId, data: $data, config: $config, photos: $photos, creationTime: $creationTime, aspect: $aspect, contentType: $contentType)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScrapItem'))
      ..add(DiagnosticsProperty('documentId', documentId))
      ..add(DiagnosticsProperty('key', key))
      ..add(DiagnosticsProperty('bookId', bookId))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('config', config))
      ..add(DiagnosticsProperty('photos', photos))
      ..add(DiagnosticsProperty('creationTime', creationTime))
      ..add(DiagnosticsProperty('aspect', aspect))
      ..add(DiagnosticsProperty('contentType', contentType));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ScrapItem &&
            (identical(other.documentId, documentId) ||
                const DeepCollectionEquality()
                    .equals(other.documentId, documentId)) &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.bookId, bookId) ||
                const DeepCollectionEquality().equals(other.bookId, bookId)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.config, config) ||
                const DeepCollectionEquality().equals(other.config, config)) &&
            (identical(other.photos, photos) ||
                const DeepCollectionEquality().equals(other.photos, photos)) &&
            (identical(other.creationTime, creationTime) ||
                const DeepCollectionEquality()
                    .equals(other.creationTime, creationTime)) &&
            (identical(other.aspect, aspect) ||
                const DeepCollectionEquality().equals(other.aspect, aspect)) &&
            (identical(other.contentType, contentType) ||
                const DeepCollectionEquality()
                    .equals(other.contentType, contentType)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(documentId) ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(bookId) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(config) ^
      const DeepCollectionEquality().hash(photos) ^
      const DeepCollectionEquality().hash(creationTime) ^
      const DeepCollectionEquality().hash(aspect) ^
      const DeepCollectionEquality().hash(contentType);

  @JsonKey(ignore: true)
  @override
  _$ScrapItemCopyWith<_ScrapItem> get copyWith =>
      __$ScrapItemCopyWithImpl<_ScrapItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ScrapItemToJson(this);
  }
}

abstract class _ScrapItem extends ScrapItem {
  _ScrapItem._() : super._();
  factory _ScrapItem(
      {@nullable String documentId,
      @nullable String key,
      String bookId,
      @nullable String data,
      @nullable String config,
      List<String> photos,
      int creationTime,
      double aspect,
      @nullable ContentType contentType}) = _$_ScrapItem;

  factory _ScrapItem.fromJson(Map<String, dynamic> json) =
      _$_ScrapItem.fromJson;

  @override
  @nullable
  String get documentId;
  @override
  @nullable
  String get key;
  @override
  String get bookId;
  @override
  @nullable
  String get data;
  @override
  @nullable
  String get config;
  @override
  List<String> get photos;
  @override
  int get creationTime;
  @override
  double get aspect;
  @override
  @nullable
  ContentType get contentType;
  @override
  @JsonKey(ignore: true)
  _$ScrapItemCopyWith<_ScrapItem> get copyWith;
}

PlacedScrapItem _$PlacedScrapItemFromJson(Map<String, dynamic> json) {
  return _PlacedScrapItem.fromJson(json);
}

/// @nodoc
class _$PlacedScrapItemTearOff {
  const _$PlacedScrapItemTearOff();

// ignore: unused_element
  _PlacedScrapItem call(
      {@nullable String documentId,
      @nullable String key,
      String bookId,
      String pageId,
      String scrapId,
      double dx = 0,
      double dy = 0,
      double width = 0,
      double height = 0,
      double rot = 0,
      double scale = 1,
      double aspect = 1,
      @nullable ContentType contentType,
      @nullable String data,
      @nullable String config,
      @nullable BoxStyle boxStyle,
      int creationTime = -1,
      int lastModifiedTime = -1}) {
    return _PlacedScrapItem(
      documentId: documentId,
      key: key,
      bookId: bookId,
      pageId: pageId,
      scrapId: scrapId,
      dx: dx,
      dy: dy,
      width: width,
      height: height,
      rot: rot,
      scale: scale,
      aspect: aspect,
      contentType: contentType,
      data: data,
      config: config,
      boxStyle: boxStyle,
      creationTime: creationTime,
      lastModifiedTime: lastModifiedTime,
    );
  }

// ignore: unused_element
  PlacedScrapItem fromJson(Map<String, Object> json) {
    return PlacedScrapItem.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $PlacedScrapItem = _$PlacedScrapItemTearOff();

/// @nodoc
mixin _$PlacedScrapItem {
  @nullable
  String get documentId;
  @nullable
  String get key;
  String get bookId;
  String get pageId;
  String get scrapId;
  double get dx;
  double get dy;
  double get width;
  double get height;
  double get rot;
  double get scale;
  double get aspect;
  @nullable
  ContentType get contentType;
  @nullable
  String get data;
  @nullable
  String get config;
  @nullable
  BoxStyle get boxStyle;
  int get creationTime;
  int get lastModifiedTime;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $PlacedScrapItemCopyWith<PlacedScrapItem> get copyWith;
}

/// @nodoc
abstract class $PlacedScrapItemCopyWith<$Res> {
  factory $PlacedScrapItemCopyWith(
          PlacedScrapItem value, $Res Function(PlacedScrapItem) then) =
      _$PlacedScrapItemCopyWithImpl<$Res>;
  $Res call(
      {@nullable String documentId,
      @nullable String key,
      String bookId,
      String pageId,
      String scrapId,
      double dx,
      double dy,
      double width,
      double height,
      double rot,
      double scale,
      double aspect,
      @nullable ContentType contentType,
      @nullable String data,
      @nullable String config,
      @nullable BoxStyle boxStyle,
      int creationTime,
      int lastModifiedTime});

  $BoxStyleCopyWith<$Res> get boxStyle;
}

/// @nodoc
class _$PlacedScrapItemCopyWithImpl<$Res>
    implements $PlacedScrapItemCopyWith<$Res> {
  _$PlacedScrapItemCopyWithImpl(this._value, this._then);

  final PlacedScrapItem _value;
  // ignore: unused_field
  final $Res Function(PlacedScrapItem) _then;

  @override
  $Res call({
    Object documentId = freezed,
    Object key = freezed,
    Object bookId = freezed,
    Object pageId = freezed,
    Object scrapId = freezed,
    Object dx = freezed,
    Object dy = freezed,
    Object width = freezed,
    Object height = freezed,
    Object rot = freezed,
    Object scale = freezed,
    Object aspect = freezed,
    Object contentType = freezed,
    Object data = freezed,
    Object config = freezed,
    Object boxStyle = freezed,
    Object creationTime = freezed,
    Object lastModifiedTime = freezed,
  }) {
    return _then(_value.copyWith(
      documentId:
          documentId == freezed ? _value.documentId : documentId as String,
      key: key == freezed ? _value.key : key as String,
      bookId: bookId == freezed ? _value.bookId : bookId as String,
      pageId: pageId == freezed ? _value.pageId : pageId as String,
      scrapId: scrapId == freezed ? _value.scrapId : scrapId as String,
      dx: dx == freezed ? _value.dx : dx as double,
      dy: dy == freezed ? _value.dy : dy as double,
      width: width == freezed ? _value.width : width as double,
      height: height == freezed ? _value.height : height as double,
      rot: rot == freezed ? _value.rot : rot as double,
      scale: scale == freezed ? _value.scale : scale as double,
      aspect: aspect == freezed ? _value.aspect : aspect as double,
      contentType: contentType == freezed
          ? _value.contentType
          : contentType as ContentType,
      data: data == freezed ? _value.data : data as String,
      config: config == freezed ? _value.config : config as String,
      boxStyle: boxStyle == freezed ? _value.boxStyle : boxStyle as BoxStyle,
      creationTime:
          creationTime == freezed ? _value.creationTime : creationTime as int,
      lastModifiedTime: lastModifiedTime == freezed
          ? _value.lastModifiedTime
          : lastModifiedTime as int,
    ));
  }

  @override
  $BoxStyleCopyWith<$Res> get boxStyle {
    if (_value.boxStyle == null) {
      return null;
    }
    return $BoxStyleCopyWith<$Res>(_value.boxStyle, (value) {
      return _then(_value.copyWith(boxStyle: value));
    });
  }
}

/// @nodoc
abstract class _$PlacedScrapItemCopyWith<$Res>
    implements $PlacedScrapItemCopyWith<$Res> {
  factory _$PlacedScrapItemCopyWith(
          _PlacedScrapItem value, $Res Function(_PlacedScrapItem) then) =
      __$PlacedScrapItemCopyWithImpl<$Res>;
  @override
  $Res call(
      {@nullable String documentId,
      @nullable String key,
      String bookId,
      String pageId,
      String scrapId,
      double dx,
      double dy,
      double width,
      double height,
      double rot,
      double scale,
      double aspect,
      @nullable ContentType contentType,
      @nullable String data,
      @nullable String config,
      @nullable BoxStyle boxStyle,
      int creationTime,
      int lastModifiedTime});

  @override
  $BoxStyleCopyWith<$Res> get boxStyle;
}

/// @nodoc
class __$PlacedScrapItemCopyWithImpl<$Res>
    extends _$PlacedScrapItemCopyWithImpl<$Res>
    implements _$PlacedScrapItemCopyWith<$Res> {
  __$PlacedScrapItemCopyWithImpl(
      _PlacedScrapItem _value, $Res Function(_PlacedScrapItem) _then)
      : super(_value, (v) => _then(v as _PlacedScrapItem));

  @override
  _PlacedScrapItem get _value => super._value as _PlacedScrapItem;

  @override
  $Res call({
    Object documentId = freezed,
    Object key = freezed,
    Object bookId = freezed,
    Object pageId = freezed,
    Object scrapId = freezed,
    Object dx = freezed,
    Object dy = freezed,
    Object width = freezed,
    Object height = freezed,
    Object rot = freezed,
    Object scale = freezed,
    Object aspect = freezed,
    Object contentType = freezed,
    Object data = freezed,
    Object config = freezed,
    Object boxStyle = freezed,
    Object creationTime = freezed,
    Object lastModifiedTime = freezed,
  }) {
    return _then(_PlacedScrapItem(
      documentId:
          documentId == freezed ? _value.documentId : documentId as String,
      key: key == freezed ? _value.key : key as String,
      bookId: bookId == freezed ? _value.bookId : bookId as String,
      pageId: pageId == freezed ? _value.pageId : pageId as String,
      scrapId: scrapId == freezed ? _value.scrapId : scrapId as String,
      dx: dx == freezed ? _value.dx : dx as double,
      dy: dy == freezed ? _value.dy : dy as double,
      width: width == freezed ? _value.width : width as double,
      height: height == freezed ? _value.height : height as double,
      rot: rot == freezed ? _value.rot : rot as double,
      scale: scale == freezed ? _value.scale : scale as double,
      aspect: aspect == freezed ? _value.aspect : aspect as double,
      contentType: contentType == freezed
          ? _value.contentType
          : contentType as ContentType,
      data: data == freezed ? _value.data : data as String,
      config: config == freezed ? _value.config : config as String,
      boxStyle: boxStyle == freezed ? _value.boxStyle : boxStyle as BoxStyle,
      creationTime:
          creationTime == freezed ? _value.creationTime : creationTime as int,
      lastModifiedTime: lastModifiedTime == freezed
          ? _value.lastModifiedTime
          : lastModifiedTime as int,
    ));
  }
}

@JsonSerializable(explicitToJson: true)

/// @nodoc
class _$_PlacedScrapItem extends _PlacedScrapItem with DiagnosticableTreeMixin {
  _$_PlacedScrapItem(
      {@nullable this.documentId,
      @nullable this.key,
      this.bookId,
      this.pageId,
      this.scrapId,
      this.dx = 0,
      this.dy = 0,
      this.width = 0,
      this.height = 0,
      this.rot = 0,
      this.scale = 1,
      this.aspect = 1,
      @nullable this.contentType,
      @nullable this.data,
      @nullable this.config,
      @nullable this.boxStyle,
      this.creationTime = -1,
      this.lastModifiedTime = -1})
      : assert(dx != null),
        assert(dy != null),
        assert(width != null),
        assert(height != null),
        assert(rot != null),
        assert(scale != null),
        assert(aspect != null),
        assert(creationTime != null),
        assert(lastModifiedTime != null),
        super._();

  factory _$_PlacedScrapItem.fromJson(Map<String, dynamic> json) =>
      _$_$_PlacedScrapItemFromJson(json);

  @override
  @nullable
  final String documentId;
  @override
  @nullable
  final String key;
  @override
  final String bookId;
  @override
  final String pageId;
  @override
  final String scrapId;
  @JsonKey(defaultValue: 0)
  @override
  final double dx;
  @JsonKey(defaultValue: 0)
  @override
  final double dy;
  @JsonKey(defaultValue: 0)
  @override
  final double width;
  @JsonKey(defaultValue: 0)
  @override
  final double height;
  @JsonKey(defaultValue: 0)
  @override
  final double rot;
  @JsonKey(defaultValue: 1)
  @override
  final double scale;
  @JsonKey(defaultValue: 1)
  @override
  final double aspect;
  @override
  @nullable
  final ContentType contentType;
  @override
  @nullable
  final String data;
  @override
  @nullable
  final String config;
  @override
  @nullable
  final BoxStyle boxStyle;
  @JsonKey(defaultValue: -1)
  @override
  final int creationTime;
  @JsonKey(defaultValue: -1)
  @override
  final int lastModifiedTime;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PlacedScrapItem(documentId: $documentId, key: $key, bookId: $bookId, pageId: $pageId, scrapId: $scrapId, dx: $dx, dy: $dy, width: $width, height: $height, rot: $rot, scale: $scale, aspect: $aspect, contentType: $contentType, data: $data, config: $config, boxStyle: $boxStyle, creationTime: $creationTime, lastModifiedTime: $lastModifiedTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PlacedScrapItem'))
      ..add(DiagnosticsProperty('documentId', documentId))
      ..add(DiagnosticsProperty('key', key))
      ..add(DiagnosticsProperty('bookId', bookId))
      ..add(DiagnosticsProperty('pageId', pageId))
      ..add(DiagnosticsProperty('scrapId', scrapId))
      ..add(DiagnosticsProperty('dx', dx))
      ..add(DiagnosticsProperty('dy', dy))
      ..add(DiagnosticsProperty('width', width))
      ..add(DiagnosticsProperty('height', height))
      ..add(DiagnosticsProperty('rot', rot))
      ..add(DiagnosticsProperty('scale', scale))
      ..add(DiagnosticsProperty('aspect', aspect))
      ..add(DiagnosticsProperty('contentType', contentType))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('config', config))
      ..add(DiagnosticsProperty('boxStyle', boxStyle))
      ..add(DiagnosticsProperty('creationTime', creationTime))
      ..add(DiagnosticsProperty('lastModifiedTime', lastModifiedTime));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PlacedScrapItem &&
            (identical(other.documentId, documentId) ||
                const DeepCollectionEquality()
                    .equals(other.documentId, documentId)) &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.bookId, bookId) ||
                const DeepCollectionEquality().equals(other.bookId, bookId)) &&
            (identical(other.pageId, pageId) ||
                const DeepCollectionEquality().equals(other.pageId, pageId)) &&
            (identical(other.scrapId, scrapId) ||
                const DeepCollectionEquality()
                    .equals(other.scrapId, scrapId)) &&
            (identical(other.dx, dx) ||
                const DeepCollectionEquality().equals(other.dx, dx)) &&
            (identical(other.dy, dy) ||
                const DeepCollectionEquality().equals(other.dy, dy)) &&
            (identical(other.width, width) ||
                const DeepCollectionEquality().equals(other.width, width)) &&
            (identical(other.height, height) ||
                const DeepCollectionEquality().equals(other.height, height)) &&
            (identical(other.rot, rot) ||
                const DeepCollectionEquality().equals(other.rot, rot)) &&
            (identical(other.scale, scale) ||
                const DeepCollectionEquality().equals(other.scale, scale)) &&
            (identical(other.aspect, aspect) ||
                const DeepCollectionEquality().equals(other.aspect, aspect)) &&
            (identical(other.contentType, contentType) ||
                const DeepCollectionEquality()
                    .equals(other.contentType, contentType)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.config, config) ||
                const DeepCollectionEquality().equals(other.config, config)) &&
            (identical(other.boxStyle, boxStyle) ||
                const DeepCollectionEquality()
                    .equals(other.boxStyle, boxStyle)) &&
            (identical(other.creationTime, creationTime) ||
                const DeepCollectionEquality()
                    .equals(other.creationTime, creationTime)) &&
            (identical(other.lastModifiedTime, lastModifiedTime) ||
                const DeepCollectionEquality()
                    .equals(other.lastModifiedTime, lastModifiedTime)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(documentId) ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(bookId) ^
      const DeepCollectionEquality().hash(pageId) ^
      const DeepCollectionEquality().hash(scrapId) ^
      const DeepCollectionEquality().hash(dx) ^
      const DeepCollectionEquality().hash(dy) ^
      const DeepCollectionEquality().hash(width) ^
      const DeepCollectionEquality().hash(height) ^
      const DeepCollectionEquality().hash(rot) ^
      const DeepCollectionEquality().hash(scale) ^
      const DeepCollectionEquality().hash(aspect) ^
      const DeepCollectionEquality().hash(contentType) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(config) ^
      const DeepCollectionEquality().hash(boxStyle) ^
      const DeepCollectionEquality().hash(creationTime) ^
      const DeepCollectionEquality().hash(lastModifiedTime);

  @JsonKey(ignore: true)
  @override
  _$PlacedScrapItemCopyWith<_PlacedScrapItem> get copyWith =>
      __$PlacedScrapItemCopyWithImpl<_PlacedScrapItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PlacedScrapItemToJson(this);
  }
}

abstract class _PlacedScrapItem extends PlacedScrapItem {
  _PlacedScrapItem._() : super._();
  factory _PlacedScrapItem(
      {@nullable String documentId,
      @nullable String key,
      String bookId,
      String pageId,
      String scrapId,
      double dx,
      double dy,
      double width,
      double height,
      double rot,
      double scale,
      double aspect,
      @nullable ContentType contentType,
      @nullable String data,
      @nullable String config,
      @nullable BoxStyle boxStyle,
      int creationTime,
      int lastModifiedTime}) = _$_PlacedScrapItem;

  factory _PlacedScrapItem.fromJson(Map<String, dynamic> json) =
      _$_PlacedScrapItem.fromJson;

  @override
  @nullable
  String get documentId;
  @override
  @nullable
  String get key;
  @override
  String get bookId;
  @override
  String get pageId;
  @override
  String get scrapId;
  @override
  double get dx;
  @override
  double get dy;
  @override
  double get width;
  @override
  double get height;
  @override
  double get rot;
  @override
  double get scale;
  @override
  double get aspect;
  @override
  @nullable
  ContentType get contentType;
  @override
  @nullable
  String get data;
  @override
  @nullable
  String get config;
  @override
  @nullable
  BoxStyle get boxStyle;
  @override
  int get creationTime;
  @override
  int get lastModifiedTime;
  @override
  @JsonKey(ignore: true)
  _$PlacedScrapItemCopyWith<_PlacedScrapItem> get copyWith;
}

BoxStyle _$BoxStyleFromJson(Map<String, dynamic> json) {
  return _BoxStyle.fromJson(json);
}

/// @nodoc
class _$BoxStyleTearOff {
  const _$BoxStyleTearOff();

// ignore: unused_element
  _BoxStyle call(
      {@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
          Color bgColor = Colors.transparent,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
          Color fgColor = Colors.black,
      @nullable
          BoxFonts font,
      @nullable
          TextAlign align}) {
    return _BoxStyle(
      bgColor: bgColor,
      fgColor: fgColor,
      font: font,
      align: align,
    );
  }

// ignore: unused_element
  BoxStyle fromJson(Map<String, Object> json) {
    return BoxStyle.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $BoxStyle = _$BoxStyleTearOff();

/// @nodoc
mixin _$BoxStyle {
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get bgColor;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get fgColor;
  @nullable
  BoxFonts get font;
  @nullable
  TextAlign get align;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $BoxStyleCopyWith<BoxStyle> get copyWith;
}

/// @nodoc
abstract class $BoxStyleCopyWith<$Res> {
  factory $BoxStyleCopyWith(BoxStyle value, $Res Function(BoxStyle) then) =
      _$BoxStyleCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color bgColor,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color fgColor,
      @nullable BoxFonts font,
      @nullable TextAlign align});
}

/// @nodoc
class _$BoxStyleCopyWithImpl<$Res> implements $BoxStyleCopyWith<$Res> {
  _$BoxStyleCopyWithImpl(this._value, this._then);

  final BoxStyle _value;
  // ignore: unused_field
  final $Res Function(BoxStyle) _then;

  @override
  $Res call({
    Object bgColor = freezed,
    Object fgColor = freezed,
    Object font = freezed,
    Object align = freezed,
  }) {
    return _then(_value.copyWith(
      bgColor: bgColor == freezed ? _value.bgColor : bgColor as Color,
      fgColor: fgColor == freezed ? _value.fgColor : fgColor as Color,
      font: font == freezed ? _value.font : font as BoxFonts,
      align: align == freezed ? _value.align : align as TextAlign,
    ));
  }
}

/// @nodoc
abstract class _$BoxStyleCopyWith<$Res> implements $BoxStyleCopyWith<$Res> {
  factory _$BoxStyleCopyWith(_BoxStyle value, $Res Function(_BoxStyle) then) =
      __$BoxStyleCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color bgColor,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color fgColor,
      @nullable BoxFonts font,
      @nullable TextAlign align});
}

/// @nodoc
class __$BoxStyleCopyWithImpl<$Res> extends _$BoxStyleCopyWithImpl<$Res>
    implements _$BoxStyleCopyWith<$Res> {
  __$BoxStyleCopyWithImpl(_BoxStyle _value, $Res Function(_BoxStyle) _then)
      : super(_value, (v) => _then(v as _BoxStyle));

  @override
  _BoxStyle get _value => super._value as _BoxStyle;

  @override
  $Res call({
    Object bgColor = freezed,
    Object fgColor = freezed,
    Object font = freezed,
    Object align = freezed,
  }) {
    return _then(_BoxStyle(
      bgColor: bgColor == freezed ? _value.bgColor : bgColor as Color,
      fgColor: fgColor == freezed ? _value.fgColor : fgColor as Color,
      font: font == freezed ? _value.font : font as BoxFonts,
      align: align == freezed ? _value.align : align as TextAlign,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_BoxStyle extends _BoxStyle with DiagnosticableTreeMixin {
  _$_BoxStyle(
      {@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
          this.bgColor = Colors.transparent,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
          this.fgColor = Colors.black,
      @nullable
          this.font,
      @nullable
          this.align})
      : assert(bgColor != null),
        assert(fgColor != null),
        super._();

  factory _$_BoxStyle.fromJson(Map<String, dynamic> json) =>
      _$_$_BoxStyleFromJson(json);

  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color bgColor;
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color fgColor;
  @override
  @nullable
  final BoxFonts font;
  @override
  @nullable
  final TextAlign align;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BoxStyle(bgColor: $bgColor, fgColor: $fgColor, font: $font, align: $align)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'BoxStyle'))
      ..add(DiagnosticsProperty('bgColor', bgColor))
      ..add(DiagnosticsProperty('fgColor', fgColor))
      ..add(DiagnosticsProperty('font', font))
      ..add(DiagnosticsProperty('align', align));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _BoxStyle &&
            (identical(other.bgColor, bgColor) ||
                const DeepCollectionEquality()
                    .equals(other.bgColor, bgColor)) &&
            (identical(other.fgColor, fgColor) ||
                const DeepCollectionEquality()
                    .equals(other.fgColor, fgColor)) &&
            (identical(other.font, font) ||
                const DeepCollectionEquality().equals(other.font, font)) &&
            (identical(other.align, align) ||
                const DeepCollectionEquality().equals(other.align, align)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(bgColor) ^
      const DeepCollectionEquality().hash(fgColor) ^
      const DeepCollectionEquality().hash(font) ^
      const DeepCollectionEquality().hash(align);

  @JsonKey(ignore: true)
  @override
  _$BoxStyleCopyWith<_BoxStyle> get copyWith =>
      __$BoxStyleCopyWithImpl<_BoxStyle>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_BoxStyleToJson(this);
  }
}

abstract class _BoxStyle extends BoxStyle {
  _BoxStyle._() : super._();
  factory _BoxStyle(
      {@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color bgColor,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color fgColor,
      @nullable BoxFonts font,
      @nullable TextAlign align}) = _$_BoxStyle;

  factory _BoxStyle.fromJson(Map<String, dynamic> json) = _$_BoxStyle.fromJson;

  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get bgColor;
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get fgColor;
  @override
  @nullable
  BoxFonts get font;
  @override
  @nullable
  TextAlign get align;
  @override
  @JsonKey(ignore: true)
  _$BoxStyleCopyWith<_BoxStyle> get copyWith;
}
