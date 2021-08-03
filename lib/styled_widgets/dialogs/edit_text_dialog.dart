import 'package:flutter/material.dart';

import '../../commands/books/update_placed_scrap_command.dart';
import '../../data/book_data.dart';
import '../../styles.dart';
import '../labeled_text_input.dart';
import 'base_dialog.dart';

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
