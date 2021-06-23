import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/time_utils.dart';
import 'package:flutter_folio/views/editor_page/scrapboard/scrap_data.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_data.freezed.dart';
part 'book_data.g.dart';

enum ContentType { Photo, Text, Emoji, Hidden }

abstract class FirebaseDoc {
  String get documentId;
}

/// One book, contains many pages
@freezed
class ScrapBookData with _$ScrapBookData implements FirebaseDoc {
  const ScrapBookData._();
  @JsonSerializable(explicitToJson: true)
  factory ScrapBookData({
    @Default("") String documentId,
    String? key,
    @Default("") String title,
    @Default("") String desc,
    @Default(-1) int creationTime,
    @Default(-1) int lastModifiedTime,
    @Default(0) int pageCount,
    @Default("") String imageUrl,
    @Default([]) List<String> pageOrder,
    //List<ScrapPageData> events,
  }) = _ScrapBookData;

  factory ScrapBookData.fromJson(Map<String, dynamic> json) => _$ScrapBookDataFromJson(json);

  // Used for testing
  static Random r = Random();
  static ScrapBookData random() {
    final modified = DateTime.now().subtract(Duration(minutes: Random().nextInt(9999)));
    final created = modified.subtract(Duration(days: r.nextInt(30)));
    return ScrapBookData(
        documentId: "${Random().nextInt(999999)}",
        title: lorem(words: 1 + r.nextInt(2)),
        imageUrl: getRandomUnsplashImg(),
        desc: lorem(paragraphs: 1, words: 50 + Random().nextInt(50)),
        pageCount: 1 + r.nextInt(5),
        creationTime: created.millisecondsSinceEpoch,
        lastModifiedTime: modified.millisecondsSinceEpoch);
  }

  static List<String> unsplashIds = [
    "1494548162494-384bba4ab999",
    "1567878130373-9c952877ed1d",
    "1574579991264-a87099cc17b1",
    "1532465473170-c5a4ce480bee",
    "1517699418036-fb5d179fef0c"
  ];
  static String imgFromId(String id) => "https://images.unsplash.com/photo-$id?w=1800&q=95&${Random().nextInt(999)}";
  static String getRandomUnsplashImg() => imgFromId(unsplashIds[r.nextInt(unsplashIds.length)]);

  DateTime getLastModifiedDate() => DateTime.fromMillisecondsSinceEpoch(lastModifiedTime);
  DateTime getCreationDate() => DateTime.fromMillisecondsSinceEpoch(creationTime);
}

// One page in a ScrapBook, contains many placed items's
@freezed
class ScrapPageData with _$ScrapPageData implements FirebaseDoc {
  const ScrapPageData._();
  @JsonSerializable(explicitToJson: true)
  factory ScrapPageData({
    @Default("") String documentId,
    String? key,
    @Default("") String bookId,
    @Default("") String title,
    @Default("") String desc,
    @Default([]) List<String> boxOrder,
    //@Default([]) List<ScrapBoxData> pictures,
  }) = _ScrapPageData;

  factory ScrapPageData.fromJson(Map<String, dynamic> json) => _$ScrapPageDataFromJson(json);
}

// A scrap that is in the "pile" for some book. Not tied to any specific page.
// A scrap will capture time and location whenever possible, and optionally contain multiple photos or some text
@freezed
class ScrapItem with _$ScrapItem implements FirebaseDoc {
  const ScrapItem._();
  @JsonSerializable(explicitToJson: true)
  factory ScrapItem({
    @Default("") String documentId,
    String? key,
    @Default("") String bookId,
    @Default("") String data,
    String? config,
    @Default([]) List<String> photos,
    @Default(-1) int creationTime,
    @Default(1) double aspect,
    ContentType? contentType,
  }) = _ScrapItem;

  factory ScrapItem.fromJson(Map<String, dynamic> json) => _$ScrapItemFromJson(json);
}

// A Scrap that has been placed onto a page, it has a position, rotation and scale.
// It may have a reference to a scrapId from the pile, or it may just be a piece of content itself
@freezed
class PlacedScrapItem with _$PlacedScrapItem implements FirebaseDoc {
  const PlacedScrapItem._();
  @JsonSerializable(explicitToJson: true)
  factory PlacedScrapItem({
    @Default("") String documentId,
    String? key,
    @Default("") String bookId,
    @Default("") String pageId,
    @Default("") String scrapId,
    @Default(0) double dx,
    @Default(0) double dy,
    @Default(0) double width,
    @Default(0) double height,
    @Default(0) double rot,
    @Default(1) double scale,
    @Default(1) double aspect,
    ContentType? contentType,
    @Default("") String data,
    String? config,
    BoxStyle? boxStyle,
    @Default(-1) int creationTime,
    @Default(-1) int lastModifiedTime,
  }) = _PlacedScrapItem;

  factory PlacedScrapItem.fromJson(Map<String, dynamic> json) => _$PlacedScrapItemFromJson(json);

  String get transformHash => "$documentId${(dx).round()}${(dy).round()}${(rot).round()}${(scale).round()}";

  bool get isPhoto => contentType == ContentType.Photo;
  bool get isEmoji => contentType == ContentType.Emoji;
  bool get isText => contentType == ContentType.Text;

  static PlacedScrapItem fromBoxData(ScrapData<PlacedScrapItem> item) {
    return item.data.copyWith(
      aspect: item.aspect,
      dx: item.offset.dx,
      dy: item.offset.dy,
      width: item.size.width,
      height: item.size.height,
      rot: item.rot,
      lastModifiedTime: TimeUtils.nowMillis,
    );
  }

  ScrapData<PlacedScrapItem> toBoxData() {
    return ScrapData<PlacedScrapItem>(this)
      ..offset = Offset(dx, dy)
      ..aspect = aspect
      ..rot = rot
      ..size = Size(width, height);
  }
}

@freezed
class BoxStyle with _$BoxStyle {
  const BoxStyle._();
  factory BoxStyle({
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) @Default(Colors.transparent) Color bgColor,
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) @Default(Colors.black) Color fgColor,
    @Default(BoxFonts.Lato) BoxFonts font,
    @Default(TextAlign.start) TextAlign align,
  }) = _BoxStyle;

  factory BoxStyle.fromJson(Map<String, dynamic> json) => _$BoxStyleFromJson(json);
}

enum BoxFonts { Caveat, PathwayGothicOne, Amiri, Lato, Mali, AlfaSlabOne }

String boxFontToDisplay(BoxFonts? font) {
  if (font == BoxFonts.Caveat) return "Caveat";
  if (font == BoxFonts.PathwayGothicOne) return "Pathway Gothic One";
  if (font == BoxFonts.Amiri) return "Amiri";
  if (font == BoxFonts.Lato) return "Lato";
  if (font == BoxFonts.Mali) return "Mali";
  if (font == BoxFonts.AlfaSlabOne) return "Alfa Slab One";
  return "Unknown";
}

String boxFontToFamily(BoxFonts? font) {
  if (font == BoxFonts.Caveat) return "Caveat";
  if (font == BoxFonts.PathwayGothicOne) return "PathwayGothicOne";
  if (font == BoxFonts.Amiri) return "Amiri";
  if (font == BoxFonts.Lato) return "Lato";
  if (font == BoxFonts.Mali) return "Mali";
  if (font == BoxFonts.AlfaSlabOne) return "AlfaSlabOne";
  return "Unknown";
}

Color _colorFromJson(String colorString) {
  int? intColor = int.tryParse(colorString, radix: 16);
  if (intColor == null) {
    return Colors.black;
  } else {
    return Color(intColor);
  }
}

String _colorToJson(Color color) => color.value.toRadixString(16);
