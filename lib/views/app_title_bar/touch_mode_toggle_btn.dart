import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/popover/popover_notifications.dart';
import 'package:flutter_folio/_widgets/popover/popover_region.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/themes.dart';
import 'package:flutter_folio/core_packages.dart';

class TouchModeToggleBtn extends StatelessWidget {
  const TouchModeToggleBtn({Key? key, required this.invertPopupAlign}) : super(key: key);
  final bool invertPopupAlign;

  @override
  Widget build(BuildContext context) {
    void handleTouchModeToggled(bool value) {
      ClosePopoverNotification().dispatch(context);
      context.read<AppModel>().enableTouchMode = !value;
    }

    AppTheme theme = context.watch();
    bool touchMode = context.select((AppModel m) => m.enableTouchMode);
    double padding = touchMode ? 8 : 4;
    return SimpleBtn(
      onPressed: () => handleTouchModeToggled(touchMode),
      child: Container(
        width: 40,
        child: Stack(
          children: [
            Positioned.fill(
                child: TweenAnimationBuilder<double>(
              tween: Tween(begin: padding, end: padding),
              duration: Times.fast,
              curve: Curves.easeOut,
              builder: (_, animatedPadding, __) => Padding(
                padding: EdgeInsets.all(animatedPadding),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    color: theme.grey.withOpacity(.3),
                  ),
                  child: PopOverRegion.hover(
                    key: ValueKey(touchMode),
                    popAnchor: invertPopupAlign ? Alignment.topRight : Alignment.topLeft,
                    anchor: invertPopupAlign ? Alignment.bottomRight : Alignment.bottomLeft,
                    popChild: StyledTooltip(touchMode ? "Switch to Precision Mode" : "Switch to Touch Mode",
                        arrowAlignment: invertPopupAlign ? Alignment.topRight : Alignment.topLeft),
                    child: MaterialIcon(
                      touchMode ? Icons.mouse : Icons.fingerprint,
                      color: theme.accent1,
                      size: 22 - animatedPadding,
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
