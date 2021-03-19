import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/flexibles/seperated_flexibles.dart';
import 'package:flutter_folio/_widgets/mixins/loading_state_mixin.dart';
import 'package:flutter_folio/commands/books/delete_page_scrap_command.dart';
import 'package:flutter_folio/commands/books/shift_placed_scraps_sort_order_command.dart';
import 'package:flutter_folio/commands/books/update_current_book_cover_photo_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/books_model.dart';

class ScrapPopupPanelButtonStrip extends StatefulWidget {
  const ScrapPopupPanelButtonStrip({Key? key, required this.scrap}) : super(key: key);
  final PlacedScrapItem scrap;

  @override
  _ScrapPopupPanelButtonStripState createState() => _ScrapPopupPanelButtonStripState();
}

class _ScrapPopupPanelButtonStripState extends State<ScrapPopupPanelButtonStrip> with LoadingStateMixin {
  @override
  Widget build(BuildContext context) {
    // Bind to page for rebuilds because our re-order might trigger it
    context.select((BooksModel m) => m.currentPage);
    // Bind to current book cover photo
    String? currentCoverPhoto = context.select((BooksModel m) => m.currentBook?.imageUrl);
    bool isCoverPhoto = widget.scrap.isPhoto && currentCoverPhoto == widget.scrap.data;
    bool disableCoverPhotoBtn = isCoverPhoto || widget.scrap.isPhoto == false;
    return GestureDetector(
      onTap: () {}, // Swallow any taps on this stack, so that disabled btns don't trigger a menu close
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.sm),
            child: SeparatedRow(
              mainAxisAlignment: MainAxisAlignment.center,
              separatorBuilder: () => HSpace.sm,
              children: [
                _IconBtn(onPressed: isLoading ? null : _handleSendBackPressed, icon: AppIcons.send_backward),
                _IconBtn(onPressed: isLoading ? null : _handleMoveForwardPressed, icon: AppIcons.move_forward),
                _IconBtn(
                    isSelected: isCoverPhoto,
                    onPressed: disableCoverPhotoBtn ? null : _handleCoverPhotoPressed,
                    icon: AppIcons.star),
                _IconBtn(onPressed: _handleDeletePressed, icon: AppIcons.trashcan),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleDeletePressed() => DeletePageScrapCommand().run(widget.scrap);

  void _handleMoveForwardPressed() => load(() async {
        await ShiftPlacedScrapsSortOrderCommand().run(1, widget.scrap);
      });

  void _handleSendBackPressed() => load(
        () async {
          await ShiftPlacedScrapsSortOrderCommand().run(-1, widget.scrap);
        },
      );

  void _handleCoverPhotoPressed() => UpdateCurrentBookCoverPhotoCommand().run(widget.scrap);
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({Key? key, this.onPressed, required this.icon, this.isSelected = false}) : super(key: key);
  final VoidCallback? onPressed;
  final AppIcons icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Flexible(
      child: SimpleBtn(
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: AppIcon(icon, color: isSelected ? theme.accent1 : theme.greyStrong, size: 16)),
        onPressed: onPressed,
      ),
    );
  }
}
