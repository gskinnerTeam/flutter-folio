import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/themes.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return FadeIn(
      child: Container(
        alignment: Alignment.center,
        color: theme.surface1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogoText(color: theme.accent1),
            VSpace.sm,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("by", style: TextStyles.title2),
                Text(" gskinner", style: TextStyles.title2.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
