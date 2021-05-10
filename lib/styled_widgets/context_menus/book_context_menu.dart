import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/app/copy_share_link_command.dart';
import 'package:flutter_folio/commands/books/delete_book_command.dart';
import 'package:flutter_folio/commands/books/set_current_book_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/styled_widgets/context_menus/context_menu_widgets.dart';

class BookContextMenu extends StatefulWidget {
  BookContextMenu(this.book);
  final ScrapBookData book;

  @override
  _BookContextMenuState createState() => _BookContextMenuState();
}

class _BookContextMenuState extends State<BookContextMenu> with ContextMenuStateMixin {
  void _handleViewPressed(BuildContext context) => SetCurrentBookCommand().run(widget.book);

  void _handleSharePressed() => CopyShareLinkCommand().run(widget.book.documentId);

  void _handleDeletePressed() {
    DeleteBookCommand().run(widget.book);
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return cardBuilder(
      context,
      [
        buttonBuilder(
          context,
          ContextMenuButtonConfig(
            "View",
            icon: ContextMenuIcon(icon: AppIcons.view),
            iconHover: ContextMenuIconHovered(icon: AppIcons.view),
            onPressed: () => handlePressed(context, () => _handleViewPressed(context)),
          ),
        ),
        buildDivider(),
        buttonBuilder(
          context,
          ContextMenuButtonConfig(
            "Share",
            icon: ContextMenuIcon(icon: AppIcons.share),
            iconHover: ContextMenuIconHovered(icon: AppIcons.share),
            onPressed: () => handlePressed(context, () => _handleSharePressed()),
          ),
        ),
        buildDivider(),
        buttonBuilder(
          context,
          ContextMenuButtonConfig(
            "Delete",
            icon: ContextMenuIcon(icon: AppIcons.trashcan),
            iconHover: ContextMenuIconHovered(icon: AppIcons.trashcan),
            onPressed: () => handlePressed(context, () => _handleDeletePressed()),
          ),
          // Custom hover color for delete button
          context.contextMenuOverlay.buttonStyle.copyWith(hoverBgColor: theme.greyStrong),
        ),
      ],
    );
  }
}
