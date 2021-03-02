import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';

// Styled Background for each ContextMenu
class ContextMenuCard extends StatelessWidget {
  const ContextMenuCard({Key key, this.children}) : super(key: key);
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Container(
        width: 200,
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: theme.bg1,
          borderRadius: Corners.smBorder,
          boxShadow: Shadows.universal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ));
  }
}
