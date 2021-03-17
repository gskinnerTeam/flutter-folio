import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/commands/books/set_current_book_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/views/home_page/covers_sortable_list_widgets.dart';

enum ColType { Name, Modified, Created }

class CoversSortableList extends StatefulWidget {
  final List<ScrapBookData> books;
  final double rowHeight;
  final bool isMobile;
  const CoversSortableList({Key? key, required this.books, this.rowHeight = 120, this.isMobile = false})
      : super(key: key);

  State createState() => _CoversSortableListState();
}

class _CoversSortableListState extends State<CoversSortableList> {
  bool _ascending = true;
  ColType _currentCol = ColType.Name;

  ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int getSort(ColType t) => _currentCol != t ? 0 : (_ascending ? 1 : -1);
    AppTheme theme = context.watch();
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
                    decoration: BoxDecoration(color: theme.surface1),
                    height: 30,
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
