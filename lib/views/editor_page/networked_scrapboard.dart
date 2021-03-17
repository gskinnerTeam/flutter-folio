import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/data_utils.dart';
import 'package:flutter_folio/commands/books/delete_page_scrap_command.dart';
import 'package:flutter_folio/commands/books/update_page_command.dart';
import 'package:flutter_folio/commands/books/update_placed_scrap_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/views/editor_page/placed_scrap_renderer.dart';
import 'package:flutter_folio/views/editor_page/scrap_popup_editor/scrap_popup_editor.dart';
import 'package:flutter_folio/views/editor_page/scrapboard/scrap_data.dart';
import 'package:flutter_folio/views/editor_page/scrapboard/scrapboard.dart';

/// The [NetworkedScrapboard] binds a Scrapboard component to the Database.
class NetworkedScrapboard extends StatefulWidget {
  const NetworkedScrapboard(
      //this.bookId, String this.pageId,
      {Key? key,
      this.startOffset = Offset.zero,
      this.readOnly = false,
      this.onSelectionChanged})
      : super(key: key);
  final Offset startOffset;
  final bool readOnly;

  @override
  _NetworkedScrapboardState createState() => _NetworkedScrapboardState();

  final void Function(List<ScrapData<PlacedScrapItem>> boxes)? onSelectionChanged;
}

class _NetworkedScrapboardState extends State<NetworkedScrapboard> {
  List<ScrapData<PlacedScrapItem>> _selectedBoxes = [];
  ScrapPageData? _currentPage;
  bool _ignoreKeyboardEvents = false;
  bool _isTranslating = false;
  ValueNotifier<bool> isTranslatingNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    BooksModel books = context.watch<BooksModel>();
    _currentPage = books.currentPage;
    List<PlacedScrapItem>? scrapsList = books.currentPageScraps;
    scrapsList = List.from(scrapsList ?? []);
    // Strip hidden items from the list, they are non visual.
    scrapsList.removeWhere((s) => s.contentType == ContentType.Hidden);
    // Apply sorting to remaining items
    scrapsList = DataUtils.sortListById((scrapsList), _currentPage?.boxOrder ?? []);
    // Create ScrapBoxData from our PlacedScraps, that the Scrapboard can work with.
    List<ScrapData<PlacedScrapItem>> boxes = scrapsList.map((item) => item.toBoxData()).toList();
    // Main Stack
    return Stack(
      children: [
        /// Scrapboard - Holds all boxes for this page
        Scrapboard<PlacedScrapItem>(
          readOnly: widget.readOnly,
          boxes: boxes,
          onTranslated: _handleBoxTranslated,
          onTranslateEnded: _handleBoxTranslateEnded,
          onOrderChanged: (_, List<ScrapData<PlacedScrapItem>> boxes) {
            if (_currentPage != null) _handleBoxReorder(_currentPage!, boxes);
          },
          onBoxDeleted: _handleBoxDeleted,
          onSelectionChanged: _handleSelectionChanged,
          idBuilder: (item) => item.data.documentId,
          itemControlsBuilder: (item) {
            return ValueListenableBuilder(
                valueListenable: isTranslatingNotifier,
                child: Transform.translate(
                  offset: Offset(item.dx - ScrapPopupEditor.kWidth / 2, item.dy + item.height / 2 - 20),
                  child: ScrapPopupEditor(
                    key: ValueKey(item.documentId),
                    scrap: item,
                    onRotChanged: (value) => _handleRotChanged(item, value),
                    onStyleChanged: (style) => _handleScrapStyleChanged(item, style),
                  ),
                ),
                builder: (_, bool isTranslating, cachedChild) {
                  if (isTranslating) return Container();
                  return cachedChild!;
                });
          },
          itemBuilder: (item) {
            int _selectedIndex = _selectedBoxes.indexWhere((b) => b.data.documentId == item.documentId);
            bool isSelected = _selectedIndex != -1;
            return PlacedScrapRenderer(
              item,
              isSelected: isSelected,
              onEditStarted: _handleScrapEditStarted,
              onEditEnded: _handleScrapEditEnded,
            );
          },
          lockAspectForItem: (item) => item.data.contentType == ContentType.Emoji,
          startOffset: widget.startOffset,
          // Convert PlacedScrapItem's to a BoxData that is expected by the Scrapboard
        ),
      ],
    );
    //   },
    // );
    // });
  }

  void _handleBoxTranslated(ScrapData<PlacedScrapItem> box) async {
    _isTranslating = true;
    isTranslatingNotifier.value = true;
    context.read<BooksModel>().replaceCurrentPageScrap(box.data, silent: true);
  }

  void _handleBoxTranslateEnded(ScrapData<PlacedScrapItem> box) async {
    PlacedScrapItem scrapItem = PlacedScrapItem.fromBoxData(box);
    _isTranslating = false;
    await UpdatePageScrapCommand().run(scrapItem);
    if (_isTranslating == false) {
      isTranslatingNotifier.value = false;
    }
  }

  void _handleBoxDeleted(ScrapData<PlacedScrapItem> box) {
    if (_ignoreKeyboardEvents) return;
    DeletePageScrapCommand().run(box.data);
  }

  void _handleBoxReorder(ScrapPageData scrapPageData, List<ScrapData<PlacedScrapItem>> boxList) async {
    List<String> boxOrder = boxList.map((element) => element.data.documentId).toList();
    UpdatePageCommand().run(scrapPageData.copyWith(boxOrder: boxOrder));
  }

  void _handleSelectionChanged(ScrapData<PlacedScrapItem>? box, List<ScrapData<PlacedScrapItem>> boxes) {
    setState(() => _selectedBoxes = boxes);
    widget.onSelectionChanged?.call(boxes);
  }

  void _handleScrapEditStarted() => _ignoreKeyboardEvents = true;

  void _handleScrapEditEnded() => _ignoreKeyboardEvents = false;

  void _handleScrapStyleChanged(PlacedScrapItem item, BoxStyle boxStyle) {
    item = item.copyWith(boxStyle: boxStyle);
    UpdatePageScrapCommand().run(item);
  }

  void _handleRotChanged(PlacedScrapItem item, double value) {
    item = item.copyWith(rot: value);
    UpdatePageScrapCommand().run(item);
  }
}
