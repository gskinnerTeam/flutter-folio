import 'package:context_menus/context_menus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/_utils/context_utils.dart';
import 'package:flutter_folio/_widgets/animated/auto_fade.dart';
import 'package:flutter_folio/_widgets/animated/opening_card.dart';
import 'package:flutter_folio/_widgets/rounded_card.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';

import 'book_cover/book_cover.dart';

/// Holds a list of [BookCover] and a Stack that features one of them in a Fullscreen format.
class CoversFlowList extends StatefulWidget {
  const CoversFlowList({Key? key, required this.books}) : super(key: key);
  final List<ScrapBookData> books;

  @override
  _CoversFlowListState createState() => _CoversFlowListState();
}

class _CoversFlowListState extends State<CoversFlowList> {
  ScrapBookData? _bgBook;
  ScrapBookData? _fgBook;
  Offset? _currentCardPos;
  bool _isOpening = false;
  final ScrollController _scrollController = ScrollController();
  Map<int, GlobalKey<_CollapsingListCardState>> keysByIndex = {};

  Size get cardSize => const Size(260, 141);

  @override
  void initState() {
    _fgBook = _bgBook = widget.books[0];
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CoversFlowList oldWidget) {
    if (oldWidget.books != widget.books) {
      ScrapBookData? prevBook = _bgBook;
      List<ScrapBookData?> l = List.from(widget.books);
      _bgBook = l.firstWhere((b) => b?.documentId == _bgBook?.documentId, orElse: () => null);
      _fgBook = l.firstWhere((b) => b?.documentId == _fgBook?.documentId, orElse: () => null);
      // If the current book is missing, fallback to the first item in the list
      if (_bgBook == null && widget.books.isNotEmpty) {
        _bgBook = prevBook; // use the deleted object as the bg for a nice transition
        _fgBook = widget.books[0];
      }
      keysByIndex.clear();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return StyledPageScaffold(
      body: Listener(
        onPointerSignal: (signal) {
          if (signal is PointerScrollEvent) _handlePointerSignal(signal);
        },
        behavior: HitTestBehavior.translucent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(color: Colors.grey),

                /// ///////////////////////////////////////////////////
                /// BackgroundCard, this gets updated when the OpeningCard finishes opening
                if (_bgBook != null) ...[
                  ContextMenuRegion(
                    contextMenu: const AppContextMenu(),
                    child: BookCoverWidget(_bgBook!, largeMode: true),
                  ),
                ],

                // Until we have a position, we'll hide the OpeningContainer and FadeUnderlay
                if (_currentCardPos != null) ...[
                  /// A black underlay that sits between the background and transition, fading in each time we change books.
                  /// This gives the impression the background card is fading to black
                  Positioned.fill(
                    key: ObjectKey(_fgBook),
                    child: AutoFade(
                      duration: Times.slow,
                      child: IgnorePointer(
                        child: Container(color: Colors.black.withOpacity(.9)),
                      ),
                    ),
                  ),

                  /// ///////////////////////////////////////////////////
                  /// OpeningContainer, Each time the key is changed, opens from a topLeftOffset + boxSize,
                  /// Tweens to fills it's parent.
                  /// Gives the impression that a list item is travelling out of the list into the parent view
                  if (_fgBook != null && _currentCardPos != null) ...[
                    OpeningContainer(
                      key: ValueKey(_fgBook!.documentId),
                      topLeftOffset: _currentCardPos!,
                      closedSize: cardSize,
                      duration: Times.slow,
                      child: BookCoverWidget(_fgBook!, largeMode: true),
                      onEnd: _handleCardOpened,
                    ),
                  ]
                ],

                /// ///////////////////////////////////////////////////
                /// List of Cards that report their globalOffset when clicked
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: cardSize.height + Insets.lg + Insets.med * 2,
                    padding: EdgeInsets.only(bottom: Insets.lg),
                    // List
                    child: FocusTraversalGroup(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: Insets.offset, vertical: Insets.med),
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        itemCount: widget.books.length,
                        // Build  a collapsing card, closes when it is the selected item
                        itemBuilder: (_, index) {
                          ScrapBookData data = widget.books[index];
                          bool isSelected = data.documentId == _fgBook?.documentId;
                          return _CollapsingListCard(data,
                              key: ValueKey(data.documentId),
                              isSelected: isSelected,
                              openWidth: cardSize.width,
                              openHeight: cardSize.height,
                              onPressed: _handleItemClicked);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  GlobalKey<_CollapsingListCardState> _getKey(int index) {
    if (keysByIndex.containsKey(index) == false) {
      keysByIndex[index] = GlobalKey<_CollapsingListCardState>();
    }
    return keysByIndex[index]!;
  }

  void _selectNextIndex({bool goBack = false}) {
    if (_isOpening) return;
    int scrollDir = goBack ? -1 : 1;
    int currentIndex = widget.books.indexWhere((element) => element.documentId == _fgBook?.documentId);
    int newIndex = currentIndex + scrollDir;
    // This list doesn't support looping, do nothing if they try and scroll out of bounds
    if (newIndex < 0 || newIndex > widget.books.length - 1) return;
    // Get a key for the nextCard, and trigger it's pressed event
    GlobalKey<_CollapsingListCardState> nextCard = _getKey(newIndex);
    nextCard.currentState?._handlePressed();
    // Scroll the list in the appropriate amt
    // Some aesthetic polish, we want to skip scrolling on the first card
    if (currentIndex == 0 && scrollDir > 0) return;
    _scrollController.animateTo(_scrollController.offset + scrollDir * cardSize.width,
        duration: Times.medium, curve: Curves.easeOut);
  }

  // When card is clicked, change selectedData and set isOpening flag
  void _handleItemClicked(Offset globalPos, ScrapBookData data) {
    if (_fgBook == data) return;
    if (_isOpening) return;
    // Convert the globalPos we get from the clickedItem, into a localState for this Widget
    Offset localPos = ContextUtils.globalToLocal(context, globalPos);
    //print(localPos);
    setState(() {
      // The _bgBook may be stale since the _fgBook was changed, update it before we start a new transition.
      // We didn't want to update it while the user was editing text, but we need to now as the _fgBook is switching to a new object.
      if (_bgBook != null) {
        for (final b in widget.books) {
          if (b.documentId == _bgBook?.documentId) _bgBook = b;
        }
      }
      // Start opening
      _currentCardPos = localPos;
      _fgBook = data;
      _isOpening = true;
    });
  }

  // When card finishes opening, swap a new bgLayer into place, and set isOpening flag
  void _handleCardOpened() {
    setState(() {
      _isOpening = false;
      _bgBook = _fgBook;
    });
  }

  void _handlePointerSignal(PointerScrollEvent event) {
    _selectNextIndex(goBack: event.scrollDelta.dy > 0);
  }
}

class _CollapsingListCard extends StatefulWidget {
  const _CollapsingListCard(this.data,
      {required this.openWidth,
      required this.openHeight,
      this.closedWidth,
      this.closedHeight,
      required this.onPressed,
      required this.isSelected,
      this.vertical = false,
      Key? key})
      : super(key: key);

  final ScrapBookData data;
  final double openWidth;
  final double openHeight;
  final void Function(Offset pos, ScrapBookData data) onPressed;
  final bool isSelected;
  final bool vertical;
  final double? closedWidth;
  final double? closedHeight;

  @override
  _CollapsingListCardState createState() => _CollapsingListCardState();
}

class _CollapsingListCardState extends State<_CollapsingListCard> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    double gap = Insets.lg;
    return AnimatedContainer(
      duration: Times.slow,
      curve: Curves.easeOut,
      // Close the card when it is selected
      width: widget.isSelected ? widget.closedWidth ?? 0 : widget.openWidth,
      height: widget.isSelected ? widget.closedHeight ?? 0 : widget.openHeight,
      padding: !widget.vertical ? EdgeInsets.only(right: gap) : EdgeInsets.only(bottom: gap),
      // Mask the rounded corners
      child: SimpleBtn(
        onPressed: widget.isSelected ? null : _handlePressed,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: Corners.medBorder,
              // BookCover Card
              child: ContextMenuRegion(
                contextMenu: BookContextMenu(widget.data),
                child: Stack(
                  children: [
                    BookCoverWidget(
                      widget.data,
                      isSelected: widget.isSelected,
                      //Disable btn if we're currently selected
                      onPressed: widget.isSelected ? null : (Offset pos) => widget.onPressed(pos, widget.data),
                    ),
                    // Super-subtle outline border
                    RoundedBorder(
                      color: theme.greyStrong.withOpacity(.3),
                      width: 1.5,
                      radius: Corners.med,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handlePressed() {
    Offset pos = ContextUtils.localToGlobal(context);
    widget.onPressed(pos, widget.data);
  }
}
