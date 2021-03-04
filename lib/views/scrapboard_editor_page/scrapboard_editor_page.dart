import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/alignments.dart';
import 'package:flutter_folio/commands/books/refresh_current_book_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/views/scrap_pile_picker/scrap_pile_picker.dart';

import 'networked_scrapboard.dart';
import 'empty_scrapboard_view.dart';
import 'panels/book_info_panel.dart';
import 'panels/content_picker_tab_menu.dart';
import 'panels/draggable_page_menu_panel.dart';
import 'panels/simple_pages_menu.dart';

class BookEditorPage extends StatefulWidget {
  const BookEditorPage({Key key, @required this.bookId, this.readOnly = false}) : super(key: key);
  final String bookId;
  final bool readOnly;

  @override
  _BookEditorPageState createState() => _BookEditorPageState();
}

class _BookEditorPageState extends State<BookEditorPage> {
  String get bookId => widget.bookId;

  @override
  Widget build(BuildContext context) {
    String pageId = context.select((BooksModel m) => m.currentPage?.documentId);
    List<ScrapPageData> pageList = context.select((BooksModel m) => m.currentBookPages);
    if (pageList == null) return LoadingIndicator();

    double leftMenuWidth = 212;
    bool isPhone = context.widthPx < Sizes.largePhone;
    bool showSimpleView = widget.readOnly || isPhone;

    return StyledPageScaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Main Scrapboard with placed scraps for the current page, sits under any floating menu panels
          if (pageList.isNotEmpty) ...[
            Positioned.fill(
              // Block EditorScrapboard layer from keyboard focus as it is optimized for mouse/touch controls
              child: NetworkedScrapboard(
                  //bookId, pageId,
                  // tweak the start-offset of the scrap-board depending on form factor
                  startOffset: Offset(
                    showSimpleView ? Insets.offset : 300, // More left padding when the full-menus are present
                    showSimpleView ? 120 : 60, // More top padding when the simple menu is present
                  ),
                  readOnly: widget.readOnly),
            ),
          ] else ...[
            Padding(
              padding: EdgeInsets.only(left: showSimpleView ? 0 : 240, right: showSimpleView ? 0 : 80),
              child: EmptyScrapboardView(readOnly: widget.readOnly),
            ),
          ],

          /// Mobile or Read-Only mode share the same simple menu...
          if (showSimpleView) ...[
            FocusTraversalGroup(
              child: TopLeft(child: SimplePagesMenu(pageList, selectedPageId: pageId)),
            ),

            /// Show scrap-button if not readOnly
            if (widget.readOnly == false) ...[
              _MobileScrapPileBtn(onPressed: () => _handleScrapPilePressed(context, bookId)),
            ],
          ]

          /// Full Editing Controls for large form-factors
          else ...{
            /// Collapsing Info and Page panels with Editable Text
            FocusTraversalGroup(
              child: _InfoAndPagePanels(bookId, pageList, width: leftMenuWidth),
            ),

            /// Content Picker, this should sit on top of everything
            /// as it has an internal Stack with an overlay-like layer
            FocusTraversalGroup(
              child: ContentPickerMenuPanel(bookId: bookId, pageId: pageId),
            ),
          },
        ],
      ),
    );
    // });
  }

  void _handleGuestUserPoll(Timer timer) => RefreshCurrentBookCommand();

  void _handleScrapPilePressed(BuildContext context, String bookId) {
    showStyledBottomSheet(context,
        child: SizedBox(height: context.heightPx * .6, child: ScrapPilePicker(bookId: bookId, mobileMode: true)));
  }
}

/// Floating FAB style btn
class _MobileScrapPileBtn extends StatelessWidget {
  const _MobileScrapPileBtn({Key key, this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    bool touchMode = context.select((AppModel m) => m.enableTouchMode);
    double size = touchMode ? 60 : 50;
    return BottomRight(
      child: Padding(
        padding: EdgeInsets.all(Insets.offset),
        child: AnimatedContainer(
            duration: Times.fast,
            curve: Curves.easeOut,
            width: size,
            height: size,
            child: PrimaryBtn(
              cornerRadius: 99,
              onPressed: onPressed,
              child: AppIcon(AppIcons.image, color: theme.surface1),
            )),
      ),
    );
  }
}

/// Vertical stack of 2 menus
/// TODO: This could be more responsive, using more height for the top panel, and more width for both panels when extended.
class _InfoAndPagePanels extends StatelessWidget {
  const _InfoAndPagePanels(this.bookId, this.pages, {Key key, @required this.width}) : super(key: key);
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
                  EditorPanelInfo(width: panelWidth, height: topPanelHeight),
                  VSpace.lg,
                  // Pages Panel
                  DraggablePageMenuPanel(pages, height: bottomPanelHeight),
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
