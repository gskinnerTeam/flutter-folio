import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/themes.dart';
import 'package:flutter_folio/_utils/log_print.dart' as logPrint;

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _showLoggerView = false;
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return StyledPageScaffold(
      body: Stack(
        children: [
          FadeOut(
            delay: Duration(milliseconds: 500),
            child: FadeIn(
              child: GestureDetector(
                onTap: () => setState(() => _showLoggerView = true),
                child: Container(
                  alignment: Alignment.center,
                  color: theme.surface1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppLogoText(color: theme.accent1),
                      VSpace.sm,
                      UiText.rich(TextSpan(children: [
                        TextSpan(text: "by", style: TextStyles.title2),
                        TextSpan(text: " gskinner", style: TextStyles.title2.copyWith(fontWeight: FontWeight.w800))
                      ]))
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_showLoggerView) ...{
            Positioned.fill(
                child: GestureDetector(child: _LoggerView(), onTap: () => setState(() => _showLoggerView = false))),
          }
        ],
      ),
    );
  }
}

class _LoggerView extends StatefulWidget {
  @override
  __LoggerViewState createState() => __LoggerViewState();
}

class __LoggerViewState extends State<_LoggerView> {
  @override
  void initState() {
    super.initState();
    logPrint.onPrint = (_) => setState(() {});
  }

  @override
  void dispose() {
    logPrint.onPrint = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Text(logPrint.logHistory),
      ),
    );
  }
}
