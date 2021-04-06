// @dart=2.12
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/animated/animated_scale.dart';
import 'package:flutter_folio/core_packages.dart';

import 'auth_form.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool portraitMode = context.widthPx < 800;
    // Calculate how wide or tall we want the form to be. Use golden ratio for nice aesthetics.
    double formWidth = max(500, context.widthPx - context.widthPx / 1.618);
    double formHeight = max(500, context.heightPx - context.heightPx / 1.618);
    return Flex(
      // Switch from row to column when in portrait mode
      direction: portraitMode ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Let the device screen be flexible
        Flexible(
          child: _DeviceScreens(portraitMode && false),
        ),
        // Control the size of the form with a SizedBox
        SizedBox(
          width: formWidth,
          height: formHeight,
          child: AuthForm(),
        ),
      ],
    );
  }
}

class _DeviceScreens extends StatelessWidget {
  const _DeviceScreens(this.portraitMode, {Key? key}) : super(key: key);
  final bool portraitMode;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return ClipRRect(
      child: Container(
        color: theme.greyWeak,
        width: double.infinity,
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (_, constraints) {
            double offsetX = 0, offsetY = 0;
            double width = portraitMode ? 500 : 1200;
            double height = 1000;
            List<Widget> images;
            // if (portraitMode) {
            //   images = [
            //     _LandingPageImage("dashedLine-mobile.png", Offset(0, 0), height: 250, scaleOnHover: false),
            //     // _LandingPageImage("tablet.png", Offset(0, 50), height: 350),
            //     // _LandingPageImage("phone.png", Offset(50, 500), height: 650),
            //     // _LandingPageImage("web.png", Offset(440, 600), height: 500),
            //     // _LandingPageImage("laptop.png", Offset(550, 100), height: 400),
            //   ];
            // } else {
            if (constraints.maxWidth < width) {
              offsetX = -(width - constraints.maxWidth) / 2;
            }
            images = [
              _LandingPageImage("dashedLine-desktop.png", Offset(180, -400), height: 1300, scaleOnHover: false),
              _LandingPageImage("tablet.png", Offset(0, 50), height: 350),
              _LandingPageImage("phone.png", Offset(50, 500), height: 650),
              _LandingPageImage("web.png", Offset(440, 600), height: 500),
              _LandingPageImage("laptop.png", Offset(550, 100), height: 400),
            ];
            // }
            return Transform.translate(
              offset: Offset(offsetX, offsetY),
              child: SizedBox(
                width: width,
                height: height,
                child: Stack(clipBehavior: Clip.none, children: images),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LandingPageImage extends StatelessWidget {
  _LandingPageImage(this.imagePath, this.offset, {Key? key, required this.height, this.scaleOnHover = true})
      : super(key: key);
  final Offset offset;
  final String imagePath;
  final double height;
  final bool scaleOnHover;
  final ValueNotifier<bool> _isMouseOverNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isMouseOverNotifier,
      builder: (_, bool isMouseOver, __) {
        double scale = isMouseOver ? 1.05 : 1;
        return Positioned(
          left: offset.dx,
          top: offset.dy,
          height: height,
          child: AnimatedScale(
            begin: 1,
            end: scale,
            duration: Times.fast,
            curve: Curves.easeOut,
            child: MouseRegion(
              onEnter: (_) => _isMouseOverNotifier.value = true && scaleOnHover,
              onExit: (_) => _isMouseOverNotifier.value = false,
              child: Image.asset(
                "assets/images/landing_page/$imagePath",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        );
      },
    );
  }
}
