import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/device_info.dart';
import 'package:flutter_folio/_widgets/alignments.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/views/scrap_pile_picker/scrap_pile_picker.dart';

import 'empty_editor_view.dart';
import 'networked_scrapboard.dart';
import 'panels/collapsible_panels.dart';
import 'panels/content_picker_tab_menu.dart';
import 'panels/simple_pages_menu.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key, required this.bookId, this.readOnly = false}) : super(key: key);
  final String bookId;
  final bool readOnly;

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  String get bookId => widget.bookId;

  @override
  Widget build(BuildContext context) {
    String? pageId = context.select((BooksModel m) => m.currentPage?.documentId);
    List<ScrapPageData>? pageList = context.select((BooksModel m) => m.currentBookPages);
    if (pageList == null) return const LoadingIndicator();
    double leftMenuWidth = 212;
    // Check form factor of device to see if we want to allow them to edit
    // Disable editing for phone users, or when in read-only mode
    bool isPhone = DeviceScreen.isPhone(context) && DeviceOS.isMobile;
    bool disableEditing = widget.readOnly || isPhone;
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
                    disableEditing ? Insets.offset : 300, // More left padding when the full-menus are present
                    disableEditing ? 120 : 60, // More top padding when the simple menu is present
                  ),
                  readOnly: disableEditing),
            ),
          ] else ...[
            // Empty placeholder view
            Padding(
              padding: EdgeInsets.only(left: disableEditing ? 0 : 240, right: disableEditing ? 0 : 80),
              child: EmptyEditorView(readOnly: widget.readOnly),
            ),
          ],

          /// Mobile or Read-Only mode share the same simple menu...
          if (disableEditing) ...[
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
              child: CollapsiblePanels(bookId, pageList, width: leftMenuWidth),
            ),

            /// Content Picker, this should sit on top of everything
            /// as it has an internal Stack with an overlay-like layer
            FocusTraversalGroup(
              child: ContentPickerTabMenu(bookId: bookId, pageId: pageId),
            ),
          },
        ],
      ),
    );
    // });
  }

  void _handleScrapPilePressed(BuildContext context, String bookId) {
    showStyledBottomSheet(context,
        child: SizedBox(
          height: context.heightPx * .6,
          // Show scrap-pile picker in a bottom-sheet
          child: ScrapPilePicker(bookId: bookId, mobileMode: true),
        ));
  }
}

/// Floating FAB style btn
class _MobileScrapPileBtn extends StatelessWidget {
  const _MobileScrapPileBtn({Key? key, required this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return BottomRight(
      child: Padding(
        padding: EdgeInsets.all(Insets.offset),
        child: PrimaryBtn(
          cornerRadius: 99,
          onPressed: onPressed,
          child: AppIcon(AppIcons.image, color: theme.surface1, size: 20),
        ),
      ),
    );
  }
}
