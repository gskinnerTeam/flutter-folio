import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/core_packages.dart';

class AppLogoText extends StatelessWidget {
  const AppLogoText({Key? key, this.constraints, this.color}) : super(key: key);
  final BoxConstraints? constraints;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    Widget img = Image.asset(
      "assets/images/logos/flutterfolio-logo.png",
      fit: BoxFit.contain,
      color: color ?? theme.accent1,
      //TODO: Log bug for blurry image filtering on windows
      filterQuality: FilterQuality.high,
    );
    return (constraints == null) ? img : ConstrainedBox(constraints: constraints!, child: img);
  }
}
