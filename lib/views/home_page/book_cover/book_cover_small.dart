import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:provider/provider.dart';

class SmallBookCover extends StatelessWidget {
  const SmallBookCover(this.book, {Key? key, this.topTitle = false}) : super(key: key);
  final ScrapBookData book;
  final bool topTitle;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return FadeInUp(
      delay: Times.medium,
      child: Text(
        book.title,
        style: TextStyles.h3.copyWith(color: theme.surface1),
      ),
    );
  }
}
