import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/styled_widgets/app_icons.dart';

class ContextMenuIcon extends StatelessWidget {
  final AppIcons icon;
  final Color? color;

  const ContextMenuIcon({Key? key, required this.icon, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return AppIcon(icon, size: 14, color: color ?? theme.greyStrong);
  }
}

class ContextMenuIconHovered extends StatelessWidget {
  const ContextMenuIconHovered({Key? key, required this.icon}) : super(key: key);
  final AppIcons icon;
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return ContextMenuIcon(icon: icon, color: theme.surface1);
  }
}

class ContextDivider extends StatelessWidget {
  const ContextDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Divider(color: theme.greyWeak, height: .5),
    );
  }
}
