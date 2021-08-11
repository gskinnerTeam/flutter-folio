import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/commands/books/set_current_book_command.dart';
import 'package:flutter_folio/commands/books/update_book_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Represents the Widget in "Large Mode"
class LargeBookCover extends StatelessWidget {
  const LargeBookCover(this.book, {Key? key}) : super(key: key);
  final ScrapBookData book;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    // Collapse padding a bit on short views
    double paddingScale = context.heightPx < 650 ? .5 : 1;
    return LayoutBuilder(
      builder: (_, constraints) => FadeInLeft(
        delay: const Duration(milliseconds: 500),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 510),
          child: FocusTraversalGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Title
                InlineTextEditor(
                  book.title,
                  maxLines: 2,
                  maxLength: 22,
                  onFocusOut: _handleTitleEditingEnded,
                  promptText: "Add Title",
                  key: ValueKey("title" + book.title),
                  width: min(constraints.maxWidth, 550),
                  style: TextStyles.h1.copyWith(color: theme.surface1),
                ),
                VSpace.med,

                /// Meta-Data (page count, last edited, etc)
                UiText(
                    span: TextSpan(children: [
                  TextSpan(
                      text: "${book.pageCount} page${book.pageCount == 1 ? "" : "s"}, ",
                      style: TextStyles.title1.copyWith(color: theme.surface1)),
                  TextSpan(
                      text: " edited ${timeago.format(book.getLastModifiedDate())}",
                      style: TextStyles.title2.copyWith(color: theme.grey))
                ])),

                /// Thick Divider
                VSpace(36 * paddingScale),
                Container(color: Colors.deepOrange, width: 32, height: 4),
                VSpace.sm,

                /// Desc
                InlineTextEditor(book.desc,
                    key: ValueKey("desc" + book.desc),
                    promptText: "Add Description",
                    onFocusOut: _handleDescEditingEnded,
                    width: 300,
                    // SB: Set web to 1 instead of 1.8, it was causing rendering issues where the text would get cut-off.
                    // TODO: Log bug on this ^
                    style: TextStyles.body1.copyWith(height: kIsWeb ? 1 : 1.8, color: theme.greyWeak),
                    maxLength: 30 * 3,
                    maxLines: 3),
                VSpace(Insets.xl * 1.2 * paddingScale),

                /// Call to Action Button
                Row(
                  children: [
                    ContextMenuRegion(
                      contextMenu: BookContextMenu(book),
                      child: PrimaryBtn(
                          label: "VIEW FOLIO", icon: Icons.chevron_right, onPressed: _handleViewFolioPressed),
                    ),
                    HSpace.sm,
                    StyledSharedBtn(book: book),
                  ],
                ),
                Flexible(child: VSpace(Insets.lg + 120 + 80 * paddingScale))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleViewFolioPressed() => SetCurrentBookCommand().run(book);

  void _handleTitleEditingEnded(String value) {
    UpdateBookCommand().run(book.copyWith(title: value));
  }

  void _handleDescEditingEnded(String value) {
    UpdateBookCommand().run(book.copyWith(desc: value));
  }
}
