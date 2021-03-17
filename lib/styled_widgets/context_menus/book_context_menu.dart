import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/app/copy_share_link_command.dart';
import 'package:flutter_folio/commands/books/delete_book_command.dart';
import 'package:flutter_folio/commands/books/set_current_book_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/styled_widgets/context_menus/core/base_context_menu.dart';
import 'package:flutter_folio/styled_widgets/context_menus/core/context_menu_button.dart';
import 'package:flutter_folio/styled_widgets/context_menus/core/context_menu_card.dart';

class BookContextMenu extends BaseContextMenu {
  BookContextMenu(this.book);
  final ScrapBookData book;

  void _handleViewPressed(BuildContext context) => SetCurrentBookCommand().run(book);
  void _handleSharePressed() => CopyShareLinkCommand().run(book.documentId);
  void _handleDeletePressed() {
    DeleteBookCommand().run(book);
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return ContextMenuCard(
      children: [
        ContextMenuBtn("View",
            icon: AppIcons.view, onPressed: () => handlePressed(context, () => _handleViewPressed(context))),
        ContextDivider(),
        ContextMenuBtn("Share",
            icon: AppIcons.share, onPressed: () => handlePressed(context, () => _handleSharePressed())),
        ContextDivider(),
        ContextMenuBtn("Delete",
            hoverBgColor: theme.greyStrong,
            icon: AppIcons.trashcan,
            onPressed: () => handlePressed(context, () => _handleDeletePressed())),
      ],
    );
  }
}
