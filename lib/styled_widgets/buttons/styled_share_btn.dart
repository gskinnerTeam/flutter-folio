import 'package:anchored_popups/anchored_popup_region.dart';
import 'package:anchored_popups/anchored_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/app/copy_share_link_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';

class StyledSharedBtn extends StatelessWidget {
  const StyledSharedBtn({
    Key? key,
    required this.book,
    this.iconColor,
  }) : super(key: key);
  final Color? iconColor;
  final ScrapBookData book;

  @override
  Widget build(BuildContext context) {
    void _handleSharePressed() {
      // Close popup when pressed
      AnchoredPopups.of(context)?.hide();
      CopyShareLinkCommand().run(book.documentId);
    }

    AppTheme theme = context.watch();
    return AnchoredPopUpRegion.hover(
        //TODO: anchors should be configurable here?
        anchor: Alignment.centerRight,
        popAnchor: Alignment.centerLeft,
        popChild: const StyledTooltip("Copy Share Link", arrowAlignment: Alignment.centerLeft),
        child: SimpleBtn(
            child: Padding(
              padding: EdgeInsets.all(Insets.sm),
              child: Icon(Icons.share, color: iconColor ?? theme.surface1),
            ),
            onPressed: _handleSharePressed));
  }
}
