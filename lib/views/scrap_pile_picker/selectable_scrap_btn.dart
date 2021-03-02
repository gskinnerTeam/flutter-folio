import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_widgets/app_image.dart';
import 'package:flutter_folio/core_packages.dart';

import 'scrap_pile_picker.dart';

class ScrapPickerBtn extends StatelessWidget {
  ScrapPickerBtn({Key key, this.img, this.onPressed, this.isSelected = false});

  final VoidCallback onPressed;
  final String img;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    if (StringUtils.isEmpty(img)) {
      return Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        if (isSelected) ...[
          //TODO: Need to get rid of all these containers... do a pass across the app.
          // Better: RoundedBorder(borderColor: theme.focus, width: 2, radius: Corners.lg),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
              borderRadius: Corners.lgBorder,
            ),
          )
        ],
        Padding(
          padding: EdgeInsets.all(Insets.xs * 1.25),
          child: GridBtn(
              onPressed: onPressed,
              bgColor: theme.greyStrong,
              child: HostedImage(
                img,
                fit: BoxFit.contain,
              )),
        ),
      ],
    );
  }
}
