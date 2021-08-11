import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/styled_widgets/context_menus/context_menu_widgets.dart';
import 'package:flutter_folio/themes.dart';

class StyledContextMenuOverlay extends StatelessWidget {
  const StyledContextMenuOverlay({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return ContextMenuOverlay(
      dividerBuilder: (_) => const ContextDivider(),
      cardBuilder: (_, children) => ContextMenuCard(children: children, padding: EdgeInsets.zero),
      buttonStyle: ContextMenuButtonStyle(
        textStyle: TextStyles.body2,
        shortcutTextStyle: TextStyles.body2.copyWith(color: theme.grey),
        hoverFgColor: theme.surface1,
        hoverBgColor: theme.accent1,
      ),
      child: child,
    );
  }
}
