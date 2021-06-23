import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/models/app_model.dart';

class ScrapPilePickerTitleBar extends StatelessWidget {
  const ScrapPilePickerTitleBar(
      {Key? key,
      required this.onSelectAllPressed,
      required this.onClosePressed,
      required this.title,
      required this.isAllSelected,
      this.mobileMode = false})
      : super(key: key);
  final VoidCallback onSelectAllPressed;
  final VoidCallback onClosePressed;
  final String title;
  final bool isAllSelected;
  final bool mobileMode;

  @override
  Widget build(BuildContext context) {
    bool touchMode = context.select((AppModel m) => m.enableTouchMode);
    return AnimatedPadding(
      curve: Curves.easeOut,
      duration: Times.fast,
      padding: EdgeInsets.symmetric(horizontal: Insets.med, vertical: Insets.lg),
      child: Stack(
        children: [
          if (mobileMode == false)
            Row(
              children: [
                TextBtn("Select ${isAllSelected ? "None" : "All"}", onPressed: onSelectAllPressed),
                const Spacer(),
                SimpleBtn(
                    child: AnimatedPadding(
                      curve: Curves.easeOut,
                      duration: Times.fast,
                      padding: EdgeInsets.all(touchMode ? 4 : 0),
                      child: const MaterialIcon(Icons.close),
                    ),
                    onPressed: onClosePressed)
              ],
            ),
          Positioned.fill(
            child: Center(child: UiText(text: title, style: TextStyles.title1)),
          )
        ],
      ),
    );
  }
}
