import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/app/copy_share_link_command.dart';
import 'package:flutter_folio/commands/books/update_book_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/books_model.dart';

class CollapsibleInfoPanel extends StatefulWidget {
  const CollapsibleInfoPanel({Key? key, required this.width, required this.height}) : super(key: key);
  final double width;
  final double height;

  @override
  _CollapsibleInfoPanelState createState() => _CollapsibleInfoPanelState();
}

class _CollapsibleInfoPanelState extends State<CollapsibleInfoPanel> {
  ScrapBookData? _book;
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    _book = context.select((BooksModel m) => m.currentBook) ?? _book;
    return CollapsingCard(
      height: widget.height,
      title: "Folio Information",
      titleClosed: _book?.title ?? "",
      icon: IconBtn(Icons.share, ignoreDensity: false, color: theme.greyStrong, onPressed: _handleSharePressed),
      child: Padding(
        padding: EdgeInsets.all(Insets.lg).copyWith(top: Insets.med),
        child: SizedBox(
          width: double.infinity,
          height: widget.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InlineTextEditor(
                _book?.title ?? "",
                width: widget.width * Insets.med * 2,
                style: TextStyles.body3.copyWith(color: theme.greyStrong),
                onFocusOut: _handleTitleChanged,
                promptText: "Add Title",
              ),
              VSpace.xs,
              Expanded(
                child: InlineTextEditor(
                  _book?.desc ?? "",
                  width: widget.width * Insets.med * 2,
                  style: TextStyles.caption.copyWith(color: theme.greyMedium),
                  alignVertical: TextAlignVertical.top,
                  maxLines: 4,
                  onFocusOut: _handleDescChanged,
                  promptText: "Add Description",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTitleChanged(String value) {
    if (_book == null) return;
    UpdateBookCommand().run(_book!.copyWith(title: value));
  }

  void _handleDescChanged(String value) {
    if (_book == null) return;
    UpdateBookCommand().run(_book!.copyWith(desc: value));
  }

  void _handleSharePressed() {
    if (_book == null) return;
    CopyShareLinkCommand().run(
      _book!.documentId,
      pageId: context.read<BooksModel>().currentPageId,
    );
  }
}
