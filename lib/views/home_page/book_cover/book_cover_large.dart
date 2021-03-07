import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/_widgets/context_menu_overlay.dart';
import 'package:flutter_folio/commands/books/set_current_book_command.dart';
import 'package:flutter_folio/commands/books/update_book_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'book_cover_notifications.dart';

/// Represents the Widget in "Large Mode"
class LargeBookCover extends StatefulWidget {
  const LargeBookCover(this.book, {Key key}) : super(key: key);
  final ScrapBookData book;

  @override
  _LargeBookCoverState createState() => _LargeBookCoverState();
}

class _LargeBookCoverState extends State<LargeBookCover> {
  ScrapBookData get book => widget.book;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    // Collapse padding a bit on short views
    double paddingScale = context.heightPx < 650 ? .5 : 1;
    return FadeInLeft(
      delay: Duration(milliseconds: 500),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 510),
        child: FocusTraversalGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              InlineTextEditor(
                book.title,
                maxLines: 2,
                onFocusIn: _handleEditingStarted,
                onFocusOut: _handleTitleEditingEnded,
                promptText: "Add Title",
                key: ValueKey("title" + book.title),
                width: 590,
                style: TextStyles.h1.copyWith(color: theme.surface1),
              ),
              VSpace.med,

              /// Meta-Data (page count, last edited, etc)
              SelectableText.rich(TextSpan(children: [
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
                  onFocusIn: _handleEditingStarted,
                  onFocusOut: _handleDescEditingEnded,
                  width: 370,
                  // SB: Set web to 1 instead of 1.8, it was causing rendering issues where the text would get cut-off.
                  // TODO: Log bug on this ^
                  style: TextStyles.body1.copyWith(height: kIsWeb ? 1 : 1.8, color: theme.greyWeak),
                  maxLines: 3),
              VSpace(Insets.xl * 1.2 * paddingScale),

              /// Call to Action Button
              Row(
                children: [
                  ContextMenuRegion(
                      contextMenu: BookContextMenu(book),
                      child: PrimaryBtn(
                          label: "VIEW FOLIO", icon: Icons.chevron_right, onPressed: _handleViewFolioPressed)),
                  HSpace.sm,
                  StyledSharedBtn(book: book),
                ],
              ),
              Flexible(child: VSpace(Insets.lg + 120 + 80 * paddingScale))
            ],
          ),
        ),
      ),
    );
  }

  void _handleViewFolioPressed() => SetCurrentBookCommand().run(book);

  void _handleEditingStarted() {
    BookEditingEndedNotification().dispatch(context);
  }

  void _handleTitleEditingEnded(String value) {
    UpdateBookCommand().run(book.copyWith(title: value));
    BookEditingEndedNotification().dispatch(context);
  }

  void _handleDescEditingEnded(String value) {
    UpdateBookCommand().run(book.copyWith(desc: value));
    BookEditingEndedNotification().dispatch(context);
  }
}
