import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/data_utils.dart';
import 'package:flutter_folio/commands/books/create_page_command.dart';
import 'package:flutter_folio/commands/books/set_current_page_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/views/scrapboard_editor_page/draggable_page_menu/draggable_page_menu.dart';

class DraggablePageMenuPanel extends StatefulWidget {
  const DraggablePageMenuPanel(this.pages, {Key key, @required this.height}) : super(key: key);
  final List<ScrapPageData> pages;
  final double height;

  @override
  _DraggablePageMenuPanelState createState() => _DraggablePageMenuPanelState();
}

class _DraggablePageMenuPanelState extends State<DraggablePageMenuPanel> {
  ScrapBookData _book;

  @override
  Widget build(BuildContext context) {
    /// State Bindings
    _book = context.select((BooksModel m) => m.currentBook);
    ScrapPageData page = context.select((BooksModel m) => m.currentPage);

    /// Build
    List<ScrapPageData> list = DataUtils.sortListById((widget.pages ?? []), _book?.pageOrder);
    return CollapsingCard(
      title: "Pages",
      titleClosed: page?.title,
      icon: _RoundedBtn(onPressed: _handleAddPressed),
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (page != null) ...[
            Container(
              child: DraggablePagesMenu(
                pageId: page.documentId,
                pages: list,
                onPressed: _handlePagePressed,
              ),
            ),
          ]
        ],
      ),
    );
  }

  /// Handlers
  void _handleAddPressed() => CreatePageCommand().run();

  void _handlePagePressed(ScrapPageData e) => SetCurrentPageCommand().run(e);
}

class _RoundedBtn extends StatelessWidget {
  const _RoundedBtn({Key key, this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    //TODO: Can this be served by an existing btn preset? If not, consider creating one?
    return SimpleBtn(
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.all(6),
          width: 40,
          height: 40,
          child: Container(
              decoration: BoxDecoration(
                color: theme.accent1,
                borderRadius: BorderRadius.circular(99),
              ),
              child: MaterialIcon(Icons.add, color: theme.bg1, size: 16)),
        ));
  }
}
