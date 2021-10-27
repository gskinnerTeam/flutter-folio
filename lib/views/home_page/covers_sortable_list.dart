import 'dart:math';

import 'package:context_menus/context_menus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/_utils/device_info.dart';
import 'package:flutter_folio/_widgets/alignments.dart';
import 'package:flutter_folio/_widgets/animated/animated_rotation.dart' as amrotation;
import 'package:flutter_folio/_widgets/gradient_container.dart';
import 'package:flutter_folio/commands/books/set_current_book_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:timeago/timeago.dart' as timeago;

enum ColType { Name, Modified, Created }

class CoversSortableList extends StatefulWidget {
  final List<ScrapBookData> books;
  final double rowHeight;
  final bool isMobile;
  const CoversSortableList({Key? key, required this.books, this.rowHeight = 120, this.isMobile = false})
      : super(key: key);

  @override
  State createState() => _CoversSortableListState();
}

class _CoversSortableListState extends State<CoversSortableList> {
  bool _ascending = true;
  ColType _currentCol = ColType.Name;

  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int getSort(ColType t) => _currentCol != t ? 0 : (_ascending ? 1 : -1);
    AppTheme theme = context.watch();
    double headerHeight = max(28, 36 + Theme.of(context).visualDensity.vertical * 6);
    List<ScrapBookData> books = _sortedBooks(widget.books).toList();
    return StyledPageScaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Determine which columns to show
          bool showModifier = constraints.maxWidth > 450;
          bool showCreated = constraints.maxWidth > 600;
          return Column(
            children: [
              VSpace(widget.isMobile ? 16 : 75),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.offset),
                child: ClipRRect(
                  borderRadius: Corners.medBorder,
                  child: Container(
                    color: theme.surface1,
                    height: headerHeight,
                    child: Row(
                      children: [
                        Expanded(
                          child: SortableListHeader(
                            "Name",
                            onPressed: () => _handleColumnPressed(ColType.Name),
                            sortDir: getSort(ColType.Name),
                          ),
                        ),
                        if (showModifier)
                          SizedBox(
                            width: 150,
                            child: SortableListHeader(
                              "Last Modified",
                              onPressed: () => _handleColumnPressed(ColType.Modified),
                              sortDir: getSort(ColType.Modified),
                            ),
                          ),
                        if (showCreated)
                          SizedBox(
                            width: 150,
                            child: SortableListHeader(
                              "Date Created",
                              onPressed: () => _handleColumnPressed(ColType.Created),
                              sortDir: getSort(ColType.Created),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              VSpace.xs,
              Flexible(
                child: FocusTraversalGroup(
                  child: Padding(
                    padding: EdgeInsets.only(left: Insets.offset, right: Insets.offset - 16, bottom: Insets.offset),
                    child: StyledScrollbar(
                      // Fixes a bug on macOs where flutter seems to show 2 scrollbars TODO: Log and reproduce a bug on this
                      enabled: DeviceOS.isMacOS == false,
                      controller: _scrollController,
                      child: ListView.builder(
                          controller: _scrollController,
                          itemExtent: 120,
                          itemCount: books.length,
                          itemBuilder: (_, int index) {
                            ScrapBookData book = books[index];
                            return SortableListRow(book,
                                key: ValueKey(book.documentId),
                                showModified: showModifier,
                                showCreated: showCreated,
                                onPressed: () => _handleRowPressed(book));
                          }),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Iterable<ScrapBookData> _sortedBooks(List<ScrapBookData> books) {
    if (_ascending) {
      switch (_currentCol) {
        case ColType.Name:
          return books.orderBy((book) => book.title);
        // The times are reverse-sorted, as we display them as "time ago" if "time ago" goes up, date goes down...
        case ColType.Modified:
          return books.orderByDescending((book) => book.lastModifiedTime);
        case ColType.Created:
          return books.orderBy((book) => book.creationTime);
      }
    } else {
      switch (_currentCol) {
        case ColType.Name:
          return books.orderByDescending((book) => book.title);
        case ColType.Modified:
          return books.orderBy((book) => book.lastModifiedTime);
        case ColType.Created:
          return books.orderByDescending((book) => book.creationTime);
      }
    }
  }

  void _handleColumnPressed(ColType sortMetric) {
    if (sortMetric == _currentCol) {
      setState(() => _ascending = !_ascending);
    } else {
      setState(() {
        _currentCol = sortMetric;
      });
    }
  }

  void _handleRowPressed(ScrapBookData book) => SetCurrentBookCommand().run(book);
}

class SortableListHeader extends StatelessWidget {
  const SortableListHeader(this.label, {Key? key, required this.sortDir, required this.onPressed}) : super(key: key);
  final String label;
  final int sortDir;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return SimpleBtn(
      cornerRadius: 0,
      onPressed: onPressed,
      child: SizedBox(
        height: double.infinity,
        child: Row(
          children: [
            HSpace.lg,
            Text(
              label,
              style: sortDir != 0 ? TextStyles.body3 : TextStyles.body2,
            ),
            HSpace.xs,
            AnimatedOpacity(
              opacity: sortDir == 0 ? 0 : 1,
              duration: Times.fast,
              child: amrotation.AnimatedRotation(
                duration: Times.fast,
                end: sortDir == 1 ? 180 : 0,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: theme.accent1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SortableListRow extends StatelessWidget {
  final VoidCallback onPressed;
  final ScrapBookData book;
  final bool showModified;
  final bool showCreated;

  const SortableListRow(this.book,
      {Key? key, required this.onPressed, this.showModified = false, this.showCreated = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Insets.xs),
      child: ContextMenuRegion(
        contextMenu: BookContextMenu(book),
        child: ClipRRect(
          borderRadius: Corners.medBorder,
          child: Stack(
            children: [
              // Cover Image
              Positioned.fill(child: BookCoverImage(book)),
              // Bg Fade 1
              CenterRight(child: HzGradient([Colors.black.withOpacity(0), Colors.black], const [0, .5], width: 400)),
              // Bg Fade 2
              VtGradient([Colors.black.withOpacity(0), Colors.black.withOpacity(.9)], const [0, 1]),
              // Press handler
              Positioned.fill(child: SimpleBtn(onPressed: onPressed, child: Container())),
              // Content
              BottomLeft(
                child: Padding(
                  padding: EdgeInsets.all(Insets.lg),
                  // Wrap the content row in intrinsic height, lets us use the Center() only along the hz axis
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Share Btn
                        StyledSharedBtn(book: book),
                        HSpace(Insets.med),
                        // Title
                        Expanded(
                          child: UiText(
                            text: book.title,
                            style: TextStyles.h2.copyWith(color: Colors.white, height: 1),
                          ),
                        ),
                        const Spacer(),
                        if (showModified)
                          SizedBox(
                            width: 150,
                            child: Center(
                              child: UiText(
                                  text: timeago.format(book.getLastModifiedDate()),
                                  style: TextStyles.body1.copyWith(color: theme.surface1)),
                            ),
                          ),
                        if (showCreated)
                          SizedBox(
                            width: 150,
                            child: Center(
                              child: UiText(
                                  text: timeago.format(book.getCreationDate()),
                                  style: TextStyles.body1.copyWith(color: theme.surface1)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
