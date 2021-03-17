import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/books/update_placed_scrap_command.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/styled_widgets/dialogs/base_dialog.dart';
import 'package:flutter_folio/styled_widgets/labeled_text_input.dart';
import 'package:flutter_folio/styles.dart';

class ScrapTextEditorDialog extends StatelessWidget {
  const ScrapTextEditorDialog(this.item, {Key? key}) : super(key: key);
  final PlacedScrapItem item;

  @override
  Widget build(BuildContext context) {
    void _handleSubmit(String value) => Navigator.pop(context);

    void _handleTextChanged(String value) {
      UpdatePageScrapCommand().run(item.copyWith(data: value));
    }

    return BaseStyledDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.lg),
            child: LabeledTextInput(
              label: "Edit Text",
              text: item.data,
              onChanged: _handleTextChanged,
              onSubmit: _handleSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
