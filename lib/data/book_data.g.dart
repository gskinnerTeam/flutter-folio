// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ScrapBookData _$_$_ScrapBookDataFromJson(Map<String, dynamic> json) {
  return _$_ScrapBookData(
    documentId: json['documentId'] as String? ?? '',
    key: json['key'] as String?,
    title: json['title'] as String? ?? '',
    desc: json['desc'] as String? ?? '',
    creationTime: json['creationTime'] as int? ?? -1,
    lastModifiedTime: json['lastModifiedTime'] as int? ?? -1,
    pageCount: json['pageCount'] as int? ?? 0,
    imageUrl: json['imageUrl'] as String? ?? '',
    pageOrder: (json['pageOrder'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$_$_ScrapBookDataToJson(_$_ScrapBookData instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'key': instance.key,
      'title': instance.title,
      'desc': instance.desc,
      'creationTime': instance.creationTime,
      'lastModifiedTime': instance.lastModifiedTime,
      'pageCount': instance.pageCount,
      'imageUrl': instance.imageUrl,
      'pageOrder': instance.pageOrder,
    };

_$_ScrapPageData _$_$_ScrapPageDataFromJson(Map<String, dynamic> json) {
  return _$_ScrapPageData(
    documentId: json['documentId'] as String? ?? '',
    key: json['key'] as String?,
    bookId: json['bookId'] as String? ?? '',
    title: json['title'] as String? ?? '',
    desc: json['desc'] as String? ?? '',
    boxOrder: (json['boxOrder'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$_$_ScrapPageDataToJson(_$_ScrapPageData instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'key': instance.key,
      'bookId': instance.bookId,
      'title': instance.title,
      'desc': instance.desc,
      'boxOrder': instance.boxOrder,
    };

_$_ScrapItem _$_$_ScrapItemFromJson(Map<String, dynamic> json) {
  return _$_ScrapItem(
    documentId: json['documentId'] as String? ?? '',
    key: json['key'] as String?,
    bookId: json['bookId'] as String? ?? '',
    data: json['data'] as String? ?? '',
    config: json['config'] as String?,
    photos:
        (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
            [],
    creationTime: json['creationTime'] as int? ?? -1,
    aspect: (json['aspect'] as num?)?.toDouble() ?? 1,
    contentType:
        _$enumDecodeNullable(_$ContentTypeEnumMap, json['contentType']),
  );
}

Map<String, dynamic> _$_$_ScrapItemToJson(_$_ScrapItem instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'key': instance.key,
      'bookId': instance.bookId,
      'data': instance.data,
      'config': instance.config,
      'photos': instance.photos,
      'creationTime': instance.creationTime,
      'aspect': instance.aspect,
      'contentType': _$ContentTypeEnumMap[instance.contentType],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$ContentTypeEnumMap = {
  ContentType.Photo: 'Photo',
  ContentType.Text: 'Text',
  ContentType.Emoji: 'Emoji',
  ContentType.Hidden: 'Hidden',
};

_$_PlacedScrapItem _$_$_PlacedScrapItemFromJson(Map<String, dynamic> json) {
  return _$_PlacedScrapItem(
    documentId: json['documentId'] as String? ?? '',
    key: json['key'] as String?,
    bookId: json['bookId'] as String? ?? '',
    pageId: json['pageId'] as String? ?? '',
    scrapId: json['scrapId'] as String? ?? '',
    dx: (json['dx'] as num?)?.toDouble() ?? 0,
    dy: (json['dy'] as num?)?.toDouble() ?? 0,
    width: (json['width'] as num?)?.toDouble() ?? 0,
    height: (json['height'] as num?)?.toDouble() ?? 0,
    rot: (json['rot'] as num?)?.toDouble() ?? 0,
    scale: (json['scale'] as num?)?.toDouble() ?? 1,
    aspect: (json['aspect'] as num?)?.toDouble() ?? 1,
    contentType:
        _$enumDecodeNullable(_$ContentTypeEnumMap, json['contentType']),
    data: json['data'] as String? ?? '',
    config: json['config'] as String?,
    boxStyle: json['boxStyle'] == null
        ? null
        : BoxStyle.fromJson(json['boxStyle'] as Map<String, dynamic>),
    creationTime: json['creationTime'] as int? ?? -1,
    lastModifiedTime: json['lastModifiedTime'] as int? ?? -1,
  );
}

Map<String, dynamic> _$_$_PlacedScrapItemToJson(_$_PlacedScrapItem instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'key': instance.key,
      'bookId': instance.bookId,
      'pageId': instance.pageId,
      'scrapId': instance.scrapId,
      'dx': instance.dx,
      'dy': instance.dy,
      'width': instance.width,
      'height': instance.height,
      'rot': instance.rot,
      'scale': instance.scale,
      'aspect': instance.aspect,
      'contentType': _$ContentTypeEnumMap[instance.contentType],
      'data': instance.data,
      'config': instance.config,
      'boxStyle': instance.boxStyle?.toJson(),
      'creationTime': instance.creationTime,
      'lastModifiedTime': instance.lastModifiedTime,
    };

_$_BoxStyle _$_$_BoxStyleFromJson(Map<String, dynamic> json) {
  return _$_BoxStyle(
    bgColor: _colorFromJson(json['bgColor'] as String),
    fgColor: _colorFromJson(json['fgColor'] as String),
    font:
        _$enumDecodeNullable(_$BoxFontsEnumMap, json['font']) ?? BoxFonts.Lato,
    align: _$enumDecodeNullable(_$TextAlignEnumMap, json['align']) ??
        TextAlign.start,
  );
}

Map<String, dynamic> _$_$_BoxStyleToJson(_$_BoxStyle instance) =>
    <String, dynamic>{
      'bgColor': _colorToJson(instance.bgColor),
      'fgColor': _colorToJson(instance.fgColor),
      'font': _$BoxFontsEnumMap[instance.font],
      'align': _$TextAlignEnumMap[instance.align],
    };

const _$BoxFontsEnumMap = {
  BoxFonts.Caveat: 'Caveat',
  BoxFonts.PathwayGothicOne: 'PathwayGothicOne',
  BoxFonts.Amiri: 'Amiri',
  BoxFonts.Lato: 'Lato',
  BoxFonts.Mali: 'Mali',
  BoxFonts.AlfaSlabOne: 'AlfaSlabOne',
};

const _$TextAlignEnumMap = {
  TextAlign.left: 'left',
  TextAlign.right: 'right',
  TextAlign.center: 'center',
  TextAlign.justify: 'justify',
  TextAlign.start: 'start',
  TextAlign.end: 'end',
};
