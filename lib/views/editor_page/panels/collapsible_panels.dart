import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/styled_widgets/styled_spacers.dart';
import 'package:flutter_folio/styles.dart';
import 'package:flutter_folio/views/editor_page/panels/collapsible_info_panel.dart';
import 'package:flutter_folio/views/editor_page/panels/collapsible_pages_panel.dart';

/// Vertical stack of 2 menus
/// TODO: This could be more responsive, using more height for the top panel, and more width for both panels when extended.
class CollapsiblePanels extends StatelessWidget {
  const CollapsiblePanels(this.bookId, this.pages, {Key? key, required this.width}) : super(key: key);
  final String bookId;
  final List<ScrapPageData> pages;
  final double width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        // Calculate the size for the two stacked panels. Top one is fixed, the btm fills the remainder of the space.
        Size size = constraints.biggest;
        // Menu gets wider as screen size grows
        double panelWidth = width;
        double topPanelHeight = 168;
        double bottomPanelHeight = max(size.height - (Insets.xl + topPanelHeight + Insets.lg + Insets.xl), 100);
        return Stack(
          children: [
            /// Left-side Books Menu
            Positioned(
              left: Insets.offset,
              top: Insets.xl,
              bottom: Insets.xl,
              width: panelWidth,
              child: Column(
                children: [
                  // Info Panel
                  CollapsibleInfoPanel(width: panelWidth, height: topPanelHeight),
                  VSpace.lg,
                  // Pages Panel
                  CollapsiblePagesPanel(pages, height: bottomPanelHeight),
                ],
              ), // BookPagesMenu(),
            )
          ],
        );
      },
    );
    //});
  }
}
