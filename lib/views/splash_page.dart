import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/logger.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _showLogView = false;
  final bool _allowLogView = kDebugMode;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return StyledPageScaffold(
      body: Stack(
        children: [
          FadeOut(
            delay: const Duration(milliseconds: 500),
            child: FadeIn(
              child: GestureDetector(
                onTap: _allowLogView ? () => setState(() => _showLogView = true) : null,
                child: Container(
                  alignment: Alignment.center,
                  color: theme.surface1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppLogoText(color: theme.accent1),
                      VSpace.sm,
                      UiText(
                          span: TextSpan(children: [
                        TextSpan(text: "by", style: TextStyles.title2),
                        TextSpan(text: " gskinner", style: TextStyles.title2.copyWith(fontWeight: FontWeight.w800))
                      ]))
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_showLogView) ...{
            Positioned.fill(
                child: GestureDetector(child: _LoggerView(), onTap: () => setState(() => _showLogView = false))),
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
    logHistory.addListener(_handleLogChanged);
  }

  @override
  void dispose() {
    logHistory.removeListener(_handleLogChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Text(logHistory.value),
      ),
    );
  }

  void _handleLogChanged() => setState(() {});
}
