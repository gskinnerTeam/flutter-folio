import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_widgets/app_image.dart';
import 'package:flutter_folio/_widgets/decorated_container.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/styled_widgets/styled_load_spinner.dart';

import 'scrap_pile_picker.dart';

class SelectableScrapBtn extends StatelessWidget {
  const SelectableScrapBtn({Key? key, required this.img, required this.onPressed, this.isSelected = false})
      : super(key: key);

  final VoidCallback onPressed;
  final String img;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    if (StringUtils.isEmpty(img)) {
      return const Center(child: StyledLoadSpinner());
    }
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(Insets.xs),
          child: GridBtn(
              onPressed: onPressed,
              bgColor: theme.greyStrong,
              child: HostedImage(
                img,
                fit: BoxFit.contain,
              )),
        ),
        if (isSelected) ...[
          DecoratedContainer(borderWidth: 2, borderColor: theme.focus, borderRadius: Corners.lg, ignorePointer: true),
        ],
      ],
    );
  }
}
