import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/books/create_folio_command.dart';
import 'package:flutter_folio/core_packages.dart';

class CreateFolioBottomSheetContent extends StatefulWidget {
  const CreateFolioBottomSheetContent({Key key, this.onSubmit}) : super(key: key);
  final VoidCallback onSubmit;

  @override
  _CreateFolioBottomSheetContentState createState() => _CreateFolioBottomSheetContentState();
}

class _CreateFolioBottomSheetContentState extends State<CreateFolioBottomSheetContent> {
  String _title = "";
  String _desc = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.xl, vertical: Insets.lg),
      child: Column(
        children: [
          Text("Folio Information".toUpperCase(), style: TextStyles.callout1),
          VSpace.med,
          LabeledTextInput(
              label: "Title", labelStyle: TextStyles.title1, text: _title, onChanged: (value) => _title = value),
          VSpace.lg,
          LabeledTextInput(
            label: "Description",
            labelStyle: TextStyles.title1,
            text: _desc,
            numLines: 5,
            hintText: "Optional",
            onChanged: (value) => _desc = value,
          ),
          VSpace.med,
          PrimaryBtn(
            label: "Create a new collection",
            onPressed: _handleNewCollectionPressed,
          ),
        ],
      ),
    );
  }

  void _handleNewCollectionPressed() {
    Navigator.pop(context);
    CreateFolioCommand().run(title: _title, desc: _desc);
  }
}
