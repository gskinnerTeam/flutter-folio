import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/_utils/notifications/close_notification.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_widgets/mixins/raw_keyboard_listener_mixin.dart';
import 'package:flutter_folio/commands/books/create_placed_scraps_command.dart';
import 'package:flutter_folio/commands/books/delete_scraps_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/views/scrap_pile_picker/scrap_pile_picker.dart';

class ContentPickerScrapsPanel extends StatefulWidget {
  const ContentPickerScrapsPanel({Key key, @required this.bookId, this.isVisible = false, @required this.pageId})
      : super(key: key);
  final String bookId;
  final String pageId;
  final bool isVisible;

  @override
  _ContentPickerScrapsPanelState createState() => _ContentPickerScrapsPanelState();
}

class _ContentPickerScrapsPanelState extends State<ContentPickerScrapsPanel> with RawKeyboardListenerMixin {
  List<ScrapItem> _selectedItems = [];
  GlobalKey<ScrapPilePickerState> _scrapPileGridKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    bool touchMode = context.select((AppModel m) => m.enableTouchMode);
    bool isPageSelected = StringUtils.isNotEmpty(widget.pageId);
    return Visibility(
      visible: widget.isVisible,
      maintainState: true,
      child: GlassCard(
        child: Container(
          width: 520,
          height: 610,
          // Wrap entire view in a FocusTraversalGroup
          child: FocusTraversalGroup(
            child: Column(
              children: [
                /// Scrolling Grid of Images
                Flexible(
                  child: ScrapPilePicker(
                    key: _scrapPileGridKey,
                    bookId: widget.bookId,
                    onSelectionChanged: _handleScrapPickerChanged,
                    contextMenuLabels: (ScrapItem scrap) => [
                      "Delete ...",
                      "Add To Page",
                    ],
                    contextMenuActions: (ScrapItem scrap) => [
                      () => _handleDeletePressed(scrap),
                      isPageSelected ? () => _handleAddPressed(scrap) : null,
                    ],
                  ),
                ),

                /// Bottom Bar
                FocusTraversalGroup(
                  child: AnimatedContainer(
                    duration: Times.fast,
                    curve: Curves.easeOut,
                    padding: EdgeInsets.all(touchMode ? Insets.med : Insets.lg),
                    child: _PanelBottomBar(
                      selectionCount: _selectedItems.length,
                      onAddPressed: isPageSelected ? _handleAddPressed : null,
                      onDeletePressed: _handleDeletePressed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get enableKeyListener => widget.isVisible;

  // Look for Delete or Backspace keys
  @override
  void handleKeyDown(RawKeyEvent value) {
    // Using manual-listener because RawKeyboardListener Widget was unpredictable with it's focus. TODO: Log some sort of bug on this? Or clarify usage of the Widget.
    if (widget.isVisible) {
      bool deletePressed =
          value.logicalKey == LogicalKeyboardKey.delete || value.logicalKey == LogicalKeyboardKey.backspace;
      if (deletePressed) _handleDeletePressed(null);
    }
  }

  void _handleAddPressed([ScrapItem hoverTarget]) {
    List<ScrapItem> scraps = _selectedItems.isEmpty ? [hoverTarget] : _selectedItems;
    CreatePlacedScrapCommand().run(pageId: widget.pageId, scraps: scraps);
    _scrapPileGridKey.currentState.clearSelection();
    CloseNotification().dispatch(context);
  }

  void _handleDeletePressed([ScrapItem hoverTarget]) async {
    List<ScrapItem> scraps = _selectedItems.isEmpty ? [hoverTarget] : _selectedItems;
    List<String> idList = scraps.map((e) => e.documentId).toList();
    bool didDelete = await DeleteScrapsCommand().run(bookId: widget.bookId, scrapIds: idList);
    if (didDelete) {
      _scrapPileGridKey.currentState.clearSelection();
    }
  }

  void _handleScrapPickerChanged(List<ScrapItem> items) => setState(() => _selectedItems = items);
}

class _PanelBottomBar extends StatelessWidget {
  const _PanelBottomBar({Key key, this.onAddPressed, this.onDeletePressed, @required this.selectionCount})
      : super(key: key);
  final VoidCallback onAddPressed;
  final VoidCallback onDeletePressed;
  final int selectionCount;

  @override
  Widget build(BuildContext context) {
    bool hasSelection = selectionCount > 0;
    return Row(children: [
      AnimatedOpacity(
          duration: Times.fast,
          opacity: hasSelection ? 1 : .6,
          child: SelectableText("$selectionCount items selected", style: TextStyles.body3)),
      Spacer(),
      SecondaryBtn(onPressed: hasSelection ? onDeletePressed : null, label: "DELETE"),
      HSpace.med,
      PrimaryBtn(onPressed: hasSelection ? onAddPressed : null, label: "ADD TO PAGE"),
    ]);
  }
}
