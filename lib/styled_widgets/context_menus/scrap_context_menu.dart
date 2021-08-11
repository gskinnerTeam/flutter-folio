import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/app/save_image_to_disk_command.dart';
import 'package:flutter_folio/commands/books/delete_page_scrap_command.dart';
import 'package:flutter_folio/commands/books/shift_placed_scraps_sort_order_command.dart';
import 'package:flutter_folio/commands/books/update_current_book_cover_photo_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/styled_widgets/context_menus/context_menu_widgets.dart';

class ScrapContextMenu extends StatefulWidget {
  const ScrapContextMenu({Key? key, required this.scrap}) : super(key: key);
  final PlacedScrapItem scrap;

  @override
  _ScrapContextMenuState createState() => _ScrapContextMenuState();
}

class _ScrapContextMenuState extends State<ScrapContextMenu> with ContextMenuStateMixin {
  @override
  Widget build(BuildContext context) {
    // Declare btn handlers inside the build method to avoid boilerplate passing of context ref

    void _handleForwardPressed() => ShiftPlacedScrapsSortOrderCommand().run(1, widget.scrap);
    void _handleBackPressed() => ShiftPlacedScrapsSortOrderCommand().run(-1, widget.scrap);
    void _handleCoverPhotoPressed() async => UpdateCurrentBookCoverPhotoCommand().run(widget.scrap);
    void _handleSaveImagePressed() async => SaveImageToDiskCommand().run(widget.scrap.data);

    void _handleDeletePressed() => DeletePageScrapCommand().run(widget.scrap);

    String? currentCoverPhoto = context.select((BooksModel m) => m.currentBook)?.imageUrl;
    bool isCoverPhoto = widget.scrap.isPhoto && widget.scrap.data == currentCoverPhoto;
    bool disableCoverPhotoBtn = isCoverPhoto || widget.scrap.isPhoto == false;
    AppTheme theme = context.watch();
    return cardBuilder.call(
      context,
      [
        buttonBuilder(
          context,
          ContextMenuButtonConfig(
            "Move forward",
            icon: const ContextMenuIcon(icon: AppIcons.move_forward),
            iconHover: const ContextMenuIconHovered(icon: AppIcons.move_forward),
            shortcutLabel: "ctrl + ]",
            onPressed: () => handlePressed(context, _handleForwardPressed),
          ),
        ),
        buttonBuilder(
            context,
            ContextMenuButtonConfig("Send backward",
                shortcutLabel: "ctrl + [",
                icon: const ContextMenuIcon(icon: AppIcons.send_backward),
                iconHover: const ContextMenuIconHovered(icon: AppIcons.send_backward),
                onPressed: () => handlePressed(context, _handleBackPressed))),
        const ContextDivider(),
        if (widget.scrap.isPhoto) ...{
          if (SaveImageToDiskCommand.canUse) ...{
            buttonBuilder(
                context,
                ContextMenuButtonConfig("Save Image As...",
                    icon: const ContextMenuIcon(icon: AppIcons.image),
                    iconHover: const ContextMenuIconHovered(icon: AppIcons.image),
                    onPressed: () => handlePressed(context, _handleSaveImagePressed))),
            const ContextDivider(),
          },
          buttonBuilder(
              context,
              ContextMenuButtonConfig("Set as cover photo",
                  shortcutLabel: "ctrl + k",
                  // Use custom color for icon if this is the selected photo
                  icon: ContextMenuIcon(icon: AppIcons.star, color: isCoverPhoto ? theme.accent1 : null),
                  iconHover: const ContextMenuIconHovered(icon: AppIcons.star),
                  onPressed: disableCoverPhotoBtn ? null : () => handlePressed(context, _handleCoverPhotoPressed))),
          const ContextDivider(),
        },
        buttonBuilder(
            context,
            ContextMenuButtonConfig("Delete",
                icon: const ContextMenuIcon(icon: AppIcons.trashcan),
                iconHover: const ContextMenuIconHovered(icon: AppIcons.trashcan),
                onPressed: () => handlePressed(context, _handleDeletePressed)),
            // Custom hover color for delete button
            context.contextMenuOverlay.buttonStyle.copyWith(hoverBgColor: theme.greyStrong)),
      ],
    );
  }
}
