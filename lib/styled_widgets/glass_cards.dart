import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/input_utils.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_widgets/decorated_container.dart';
import 'package:flutter_folio/_widgets/gradient_container.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/models/app_model.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({Key? key, required this.child, this.alpha = .6, this.radius}) : super(key: key);
  final Widget child;
  final double alpha;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: InputUtils.unFocus,
      child: DecoratedContainer(
        shadows: Shadows.universal,
        child: ClipRRect(
          borderRadius: radius ?? Corners.lgBorder,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(alpha), child: child),
          ),
        ),
      ),
    );
  }
}

class CollapsingCard extends StatefulWidget {
  const CollapsingCard(
      {Key? key, required this.child, required this.height, required this.title, this.icon, this.titleClosed})
      : super(key: key);
  final Widget child;
  final double height;
  final String title;
  final String? titleClosed;
  final Widget? icon;

  @override
  _CollapsingCardState createState() => _CollapsingCardState();
}

class _CollapsingCardState extends State<CollapsingCard> with TickerProviderStateMixin {
  late AnimationController anim1;
  bool _isOpen = true;
  double animatedHeightValue(double headerHeight) {
    return headerHeight + (widget.height - headerHeight) * CurveTween(curve: Curves.easeOut).evaluate(anim1);
  }

  @override
  void initState() {
    super.initState();
    anim1 = AnimationController(vsync: this, duration: Times.fast, value: 1);
    anim1.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    if (_isOpen == false && StringUtils.isNotEmpty(widget.titleClosed)) {
      title = widget.titleClosed!;
    }
    double headerHeight = context.select((AppModel m) => m.enableTouchMode) ? 50 : 40;
    return SizedBox(
      height: animatedHeightValue(headerHeight),
      child: Stack(
        children: [
          // Content
          GlassCard(
            child: AnimatedPadding(
              duration: Times.fast,
              curve: Curves.easeOut,
              padding: EdgeInsets.only(top: headerHeight),
              child: FadeTransition(opacity: anim1, child: widget.child),
            ),
          ),
          // Clickable Header
          TweenAnimationBuilder<double>(
            duration: Times.fast,
            tween: Tween(begin: headerHeight, end: headerHeight),
            builder: (_, value, __) => _CollapsableCardHeader(
              onPressed: _handlePressed,
              height: value,
              animation: anim1,
              isOpen: _isOpen,
              title: title,
              icon: widget.icon,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePressed() => setState(() {
        _isOpen = !_isOpen;
        _isOpen ? anim1.forward() : anim1.reverse();
      });
}

// Button w/ arrow that sits on top of a [CollapsableCard]
class _CollapsableCardHeader extends StatelessWidget {
  const _CollapsableCardHeader(
      {Key? key,
      required this.onPressed,
      required this.height,
      required this.animation,
      required this.isOpen,
      required this.title,
      this.icon})
      : super(key: key);
  final VoidCallback onPressed;
  final double height;
  final AnimationController animation;
  final bool isOpen;
  final String title;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Stack(
      fit: StackFit.expand,
      children: [
        /// Shadow that sits under the header when open
        Positioned(
            top: height,
            left: 0,
            right: 0,
            height: 6,
            child: FadeTransition(
                opacity: animation,
                child: VtGradient(
                  [Colors.black.withOpacity(.1), Colors.black.withOpacity(0)],
                  const [0, 1],
                ))),

        /// Clickable Header
        SimpleBtn(
            hoverColors: BtnColors(fg: theme.greyMedium, bg: Colors.transparent),
            onPressed: onPressed,
            child: Container(
              height: height,
              // Background with rounded corners on top, and (sometimes) on bottom.
              decoration: BoxDecoration(
                color: theme.bg1.withOpacity(.3),
                borderRadius: BorderRadius.vertical(
                    top: Corners.lgRadius,
                    // Tween btm corners from rounded to non-rounded when open
                    bottom: Radius.circular(Corners.lg * (1 - animation.value))),
              ),
              child: Row(
                children: [
                  HSpace.sm,
                  Transform.rotate(angle: pi * animation.value, child: const Icon(Icons.keyboard_arrow_down)),
                  HSpace.xs,
                  Expanded(
                      child: Text(title.toUpperCase(),
                          maxLines: 1, style: TextStyles.callout2.copyWith(color: theme.greyStrong))),
                  if (icon != null) icon!,
                ],
              ),
            )),
      ],
    );
  }
}
