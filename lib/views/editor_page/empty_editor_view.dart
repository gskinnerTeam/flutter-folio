import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/styled_widgets/styled_spacers.dart';

class EmptyEditorView extends StatelessWidget {
  const EmptyEditorView({Key? key, required this.readOnly}) : super(key: key);
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Insets.offset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            VSpace.lg,
            Padding(
              padding: EdgeInsets.only(left: Insets.med),
              child: UiText(
                  span: TextSpan(children: [
                    TextSpan(
                        text: "Welcome to Flutter Folio!\n\n",
                        style: TextStyles.title1.copyWith(fontWeight: FontWeight.w800)),
                    const TextSpan(
                        text: "- Use your phone or desktop to upload photos into your Folios\n\n"
                            "- Design your scrapbooks on larger screen devices like desktop, laptop and tablet.\n\n"
                            "- Share them with family and friends with a web link!\n\n"),
                    if (readOnly == false) ...[
                      TextSpan(
                          text: "Upload some photos and create a new page to get started!",
                          style: TextStyles.title2.copyWith(fontWeight: FontWeight.w800)),
                    ]
                  ]),
                  style: TextStyles.title2),
            ),
          ],
        ),
      ),
    );
  }
}
