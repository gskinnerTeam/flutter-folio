// @dart=2.12
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/_widgets/animated/opening_card.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/views/home_page/book_cover/book_cover.dart';

/// Holds a list of [BookCover] and a Stack that features one of them in a Fullscreen format.
class CoversFlowListMobile extends StatefulWidget {
  const CoversFlowListMobile({Key? key, required this.books}) : super(key: key);
  final List<ScrapBookData> books;

  @override
  _CoversFlowListMobileState createState() => _CoversFlowListMobileState();
}

class _CoversFlowListMobileState extends State<CoversFlowListMobile> {
  ScrapBookData? _bgBook;
  ScrapBookData? _fgBook;
  late int _previewBookIdx;
  Offset? _currentCardPos;
  Offset? _currentCursorPos;
  bool _isOpening = false;
  bool _editingText = false;

  @override
  void initState() {
    bool hasBooks = widget.books.isNotEmpty;
    if (hasBooks) {
      _fgBook = _bgBook = widget.books.first;
    }
    //TODO: This is probably a bug? Make sure empty view works properly here
    _previewBookIdx = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StyledPageScaffold(
      body: Listener(
        onPointerSignal: _handlePointerSignal,
        behavior: HitTestBehavior.translucent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = context.widthPx < Sizes.smallPhone;
            Size boxSize = Size(isMobile ? constraints.maxWidth : 260, 141);

            _currentCursorPos = Offset(0, constraints.maxHeight - boxSize.width / 2);
            List<ScrapBookData> books = widget.books;
            return Stack(
              children: [
                Container(color: Colors.grey),

                /// ///////////////////////////////////////////////////
                /// BackgroundCard, this gets updated then the OpeningCard finishes opening
                if (_bgBook != null) ...[
                  BookCoverWidget(_bgBook!, largeMode: true),
                ],

                if (_currentCardPos != null && _fgBook != null) ...[
                  OpeningContainer(
                    key: ValueKey(_fgBook),
                    topLeftOffset: _currentCardPos!,
                    closedSize: boxSize,
                    duration: Times.slow,
                    child: BookCoverWidget(_fgBook!, largeMode: true),
                    onEnd: _handleCardOpened,
                  ),
                ],

                /// ///////////////////////////////////////////////////
                /// Preview card, this shows the next card in the list
                if (books.length > 1) ...[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 51),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Insets.xl),
                        width: boxSize.width,
                        height: boxSize.height,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: Corners.medBorder,
                              child: BookCoverWidget(books[_previewBookIdx], largeMode: false, topTitle: true),
                            ),
                            GestureDetector(
                              onTapUp: (details) => _switchNextFolio(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                GestureDetector(
                  onVerticalDragEnd: _handleVerticalSwipe,
                  //onHorizontalDragEnd: _handleHorizontalSwipe,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // When card finishes opening, swap a new bgLayer into place, and set isOpening flag
  void _handleCardOpened() {
    setState(() {
      _isOpening = false;
      _bgBook = _fgBook;
    });
  }

  void _handleVerticalSwipe(DragEndDetails details) {
    if (details.primaryVelocity! > 10) {
      _switchPreviousFolio();
    } else if (details.primaryVelocity! < -10) {
      _switchNextFolio();
    }
  }

  // void _handleHorizontalSwipe(DragEndDetails details) {
  //   if (details.primaryVelocity > 0) _switchNextFolio();
  //   if (details.primaryVelocity < 0) _switchPreviousFolio();
  // }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (event.scrollDelta.dy < 0) _switchPreviousFolio();
      if (event.scrollDelta.dy > 0) _switchNextFolio();
    }
  }

  void _switchPreviousFolio() {
    int previousIdx = (_previewBookIdx - 2) % widget.books.length;
    _switchFolio(widget.books[previousIdx], false);
  }

  void _switchNextFolio() {
    _switchFolio(widget.books[_previewBookIdx]);
  }

  // When card is clicked, change selectedData and set isOpening flag
  void _switchFolio(ScrapBookData data, [bool next = true]) {
    if (_editingText) return;
    if (_fgBook == data) return;
    if (_isOpening) return;
    setState(() {
      if (next)
        ++_previewBookIdx;
      else
        --_previewBookIdx;

      // Clamp book index to books list length
      _previewBookIdx %= widget.books.length;

      // The _bgBook may be stale since the _fgBook was changed, update it before we start a new transition.
      // We didn't want to update it while the user was editing text, but we need to now as the _fgBook is switching to a new object.
      if (_bgBook != null) {
        widget.books.forEach((b) {
          if (b.documentId == _bgBook?.documentId) _bgBook = b;
        });
      }
      // Start opening
      _currentCardPos = _currentCursorPos;
      _fgBook = data;
      _isOpening = true;
    });
  }

  bool _handleTextEditNotifications(Notification e) {
    if (e is InlineTextEditorFocusNotification) {
      setState(() => _editingText = e.hasFocus);
    }
    return false;
  }
}
