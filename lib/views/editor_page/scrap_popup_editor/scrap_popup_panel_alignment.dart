import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_folio/core_packages.dart';

class ScrapPopupPanelAlignment extends StatelessWidget {
  const ScrapPopupPanelAlignment({Key? key, this.onAlignmentPressed, required this.value}) : super(key: key);
  final void Function(TextAlign value)? onAlignmentPressed;
  final TextAlign value;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Alignment",
          style: TextStyles.caption.copyWith(color: theme.grey, height: 1),
        ),
        Row(
          children: [
            _AlignmentBtn(
              Icons.format_align_left,
              isSelected: value == TextAlign.left,
              onPressed: () => onAlignmentPressed?.call(TextAlign.left),
            ),
            _AlignmentBtn(
              Icons.format_align_center,
              isSelected: value == TextAlign.center,
              onPressed: () => onAlignmentPressed?.call(TextAlign.center),
            ),
            _AlignmentBtn(
              Icons.format_align_right,
              isSelected: value == TextAlign.right,
              onPressed: () => onAlignmentPressed?.call(TextAlign.right),
            ),
          ],
        ),
      ],
    );
  }
}

class _AlignmentBtn extends StatelessWidget {
  const _AlignmentBtn(this.icon, {Key? key, this.onPressed, this.isSelected = false}) : super(key: key);
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Expanded(
        child: SimpleBtn(
            onPressed: onPressed,
            ignoreDensity: false,
            child: Center(
              child: MaterialIcon(
                icon,
                color: isSelected ? theme.greyStrong : theme.grey,
                size: 22,
              ),
            )));
  }
}
