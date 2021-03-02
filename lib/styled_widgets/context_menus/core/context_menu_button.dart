import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:provider/provider.dart';

// A single ContextMenu button
class ContextMenuBtn extends StatefulWidget {
  const ContextMenuBtn(this.label,
      {Key key, this.onPressed, this.icon, this.shortcutLabel, this.hoverBgColor, this.iconColor})
      : super(key: key);
  final String label;
  final String shortcutLabel;
  final VoidCallback onPressed;
  final AppIcons icon;
  final Color iconColor;
  final Color hoverBgColor;

  @override
  _ContextMenuBtnState createState() => _ContextMenuBtnState();
}

class _ContextMenuBtnState extends State<ContextMenuBtn> {
  bool _isMouseOver = false;
  set isMouseOver(bool isMouseOver) => setState(() => _isMouseOver = isMouseOver);
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    bool isDisabled = widget.onPressed == null;
    bool showMouseOver = _isMouseOver && !isDisabled;
    Color fgColor = showMouseOver ? theme.surface1 : theme.greyStrong;
    return GestureDetector(
      onTapDown: (_) => isMouseOver = true,
      onTapUp: (_) {
        isMouseOver = false;
        widget.onPressed?.call();
      },
      child: MouseRegion(
        onEnter: (_) => isMouseOver = true,
        onExit: (_) => isMouseOver = false,
        cursor: !isDisabled ? SystemMouseCursors.click : MouseCursor.defer,
        child: Opacity(
          opacity: isDisabled ? .7 : 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Insets.med, vertical: Insets.med),
            width: double.infinity,
            color: showMouseOver ? (widget.hoverBgColor ?? theme.accent1) : Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Optional Icon
                if (widget.icon != null) ...[
                  AppIcon(widget.icon, size: 16, color: widget.iconColor ?? fgColor),
                  HSpace.med,
                ],

                /// Main Label
                Text(
                  widget.label ?? "",
                  style: TextStyles.caption.copyWith(color: fgColor),
                ),
                Spacer(),

                /// Shortcut Label
                if (widget.shortcutLabel != null) ...[
                  Opacity(
                      opacity: showMouseOver ? 1 : .7,
                      child: Text(widget.shortcutLabel, style: TextStyles.caption.copyWith(color: fgColor)))
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
