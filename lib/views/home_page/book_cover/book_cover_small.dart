import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:provider/provider.dart';

class SmallBookCover extends StatefulWidget {
  const SmallBookCover(this.book, {Key key, this.topTitle}) : super(key: key);
  final ScrapBookData book;
  final bool topTitle;

  @override
  _SmallBookCoverState createState() => _SmallBookCoverState();
}

class _SmallBookCoverState extends State<SmallBookCover> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return FadeInUp(
      delay: Times.medium,
      child: Text(
        widget.book.title,
        style: TextStyles.h3.copyWith(color: theme.surface1),
      ),
    );
  }
}
