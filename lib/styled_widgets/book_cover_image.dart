// Wraps a CachedNetworkImage + a fallback placeholder if no image is set.
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_widgets/app_image.dart';
import 'package:flutter_folio/data/book_data.dart';

/// An image that falls back to a placeholder img
class BookCoverImage extends StatefulWidget {
  const BookCoverImage(this.data, {Key? key}) : super(key: key);
  final ScrapBookData data;

  @override
  _BookCoverImageState createState() => _BookCoverImageState();
}

class _BookCoverImageState extends State<BookCoverImage> {
  @override
  Widget build(BuildContext context) {
    bool usePlaceholder = StringUtils.isEmpty(widget.data.imageUrl);
    if (!usePlaceholder) {
      //print(widget.data.imageUrl);
      return HostedImage(widget.data.imageUrl, fit: BoxFit.cover);
    } else {
      return Image.asset("assets/images/empty-background.png", fit: BoxFit.cover);
    }
  }
}
