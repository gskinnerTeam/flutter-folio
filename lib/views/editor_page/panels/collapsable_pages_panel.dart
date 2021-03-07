import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/data_utils.dart';
import 'package:flutter_folio/commands/books/create_page_command.dart';
import 'package:flutter_folio/commands/books/set_current_page_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/views/editor_page/draggable_page_menu/draggable_page_menu.dart';

class CollapsablePagesPanel extends StatefulWidget {
  const CollapsablePagesPanel(this.pages, {Key key, @required this.height}) : super(key: key);
  final List<ScrapPageData> pages;
  final double height;

  @override
  _CollapsablePagesPanelState createState() => _CollapsablePagesPanelState();
}

class _CollapsablePagesPanelState extends State<CollapsablePagesPanel> {
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
          Container(
            child: list.isEmpty
                ? _EmptyView()
                : DraggablePagesMenu(
                    pageId: page?.documentId,
                    pages: list,
                    onPressed: _handlePagePressed,
                  ),
          ),
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

class _EmptyView extends StatefulWidget {
  @override
  __EmptyViewState createState() => __EmptyViewState();
}

class __EmptyViewState extends State<_EmptyView> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Padding(
      padding: EdgeInsets.all(Insets.med).copyWith(top: Insets.xl),
      child: Text(
        "Create your first page by pressing the ➕ button.",
        textAlign: TextAlign.center,
        style: TextStyles.callout1.copyWith(color: theme.greyMedium, height: 1.5),
      ),
    );
  }
}
