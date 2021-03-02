import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';

class BaseStyledDialog extends StatelessWidget {
  final Color bgColor;
  final EdgeInsets padding;
  final Widget child;

  const BaseStyledDialog({Key key, this.bgColor, this.padding, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var theme = context.watch<AppTheme>();
    return Dialog(
      backgroundColor: bgColor ?? theme.bg1,
      elevation: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 280),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(vertical: Insets.lg),
          child: IntrinsicWidth(child: child),
        ),
      ),
    );
  }
}
