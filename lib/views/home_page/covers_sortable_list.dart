import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/commands/books/set_current_book_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';

import 'covers_sortable_list_widgets.dart';

enum ColType { Name, Modified, Created }

class CoversSortableList extends StatefulWidget {
  final List<ScrapBookData> books;
  final double rowHeight;
  final bool isMobile;
  const CoversSortableList({Key key, this.books, this.rowHeight = 120, this.isMobile = false}) : super(key: key);

  State createState() => _CoversSortableListState();
}

class _CoversSortableListState extends State<CoversSortableList> {
  bool _ascending = true;
  ColType _currentCol = ColType.Name;

  ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StyledPageScaffold(
      body: Column(
        children: [
          VSpace(widget.isMobile ? 16 : 75),
          Flexible(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double modifiedWidth = widget.isMobile ? 0 : 150;
                double createdWidth = widget.isMobile ? 0 : 150;
                double flexPx = constraints.maxWidth - modifiedWidth - createdWidth - Insets.offset * 2;
                double sortDir = _ascending ? 1 : -1;
                bool skipCreatedColumn = flexPx < 300 || widget.isMobile;
                if (skipCreatedColumn) {
                  flexPx += createdWidth;
                }
                return FocusTraversalGroup(
                  child: Padding(
                    padding: EdgeInsets.only(left: Insets.offset, right: Insets.offset - 16, bottom: Insets.offset),
                    child: StyledScrollbar(
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: DataTable(
                            columnSpacing: 0,
                            horizontalMargin: 0,
                            dataRowHeight: widget.rowHeight + Insets.sm,
                            headingRowHeight: 32,
                            dividerThickness: 0,
                            onSelectAll: null,
                            columns: [
                              DataColumn(
                                label: BookColumnHeader("Name",
                                    sortLabel: widget.isMobile ? "Last Modified" : null,
                                    onPressed: () =>
                                        _handleColumnPressed(widget.isMobile ? ColType.Modified : ColType.Name),
                                    width: flexPx,
                                    height: 32,
                                    hzAlignment: widget.isMobile ? BookColumnAlignment.All : BookColumnAlignment.Left,
                                    sortDir: _currentCol == (widget.isMobile ? ColType.Modified : ColType.Name)
                                        ? sortDir
                                        : 0),
                              ),
                              DataColumn(
                                label: BookColumnHeader("Last Modified",
                                    onPressed: () => _handleColumnPressed(ColType.Modified),
                                    width: modifiedWidth,
                                    height: 32,
                                    hzAlignment:
                                        skipCreatedColumn ? BookColumnAlignment.Right : BookColumnAlignment.Center,
                                    sortDir: _currentCol == ColType.Modified ? sortDir : 0),
                              ),
                              if (!skipCreatedColumn)
                                DataColumn(
                                  label: BookColumnHeader("Date Created",
                                      onPressed: () => _handleColumnPressed(ColType.Created),
                                      width: createdWidth,
                                      height: 32,
                                      hzAlignment: BookColumnAlignment.Right,
                                      sortDir: _currentCol == ColType.Created ? sortDir : 0),
                                ),
                            ],
                            rows: _sortedBooks(widget.books).map((book) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    BookRowItem(flexPx, widget.rowHeight, book,
                                        hzAlignment:
                                            widget.isMobile ? BookColumnAlignment.All : BookColumnAlignment.Left),
                                    onTap: () => _handleRowPressed(book),
                                  ),
                                  DataCell(
                                    BookRowItem(
                                      modifiedWidth,
                                      widget.rowHeight,
                                      book,
                                      type: ColType.Modified,
                                      hzAlignment:
                                          skipCreatedColumn ? BookColumnAlignment.Right : BookColumnAlignment.Center,
                                    ),
                                    onTap: () => _handleRowPressed(book),
                                  ),
                                  if (!skipCreatedColumn)
                                    DataCell(
                                      BookRowItem(createdWidth, widget.rowHeight, book,
                                          type: ColType.Created, hzAlignment: BookColumnAlignment.Right),
                                      onTap: () => _handleRowPressed(book),
                                    ),
                                ],
                              );
                            }).toList()),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
          return books.orderBy((book) => book.lastModifiedTime);
      }
    } else {
      switch (_currentCol) {
        case ColType.Name:
          return books.orderByDescending((book) => book.title);
        case ColType.Modified:
          return books.orderBy((book) => book.creationTime);
        case ColType.Created:
          return books.orderByDescending((book) => book.creationTime);
      }
    }

    print("Error: Sort metric unsupported: $_currentCol");
    return Iterable<ScrapBookData>.empty();
  }

  void _handleColumnPressed(ColType sortMetric) {
    if (sortMetric == _currentCol) {
      setState(() => _ascending = !_ascending);
    } else {
      setState(() {
        _currentCol = sortMetric;
        _ascending = true;
      });
    }
  }

  void _handleRowPressed(ScrapBookData book) => SetCurrentBookCommand().run(book);
}
