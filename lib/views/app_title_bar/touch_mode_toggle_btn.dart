import 'package:anchored_popups/anchored_popup_region.dart';
import 'package:anchored_popups/anchored_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/decorated_container.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/themes.dart';

/// Toggles the current 'enableTouchMode' settings.
/// This widget treats density inversely to the rest of the app, as it is meant to indicate the mode the user wants to switch to.
/// For example, if a user is in high density mode, using their finger, we provide a low-density (large) visual hit area for the finger
/// Conversely, if a user in in low density mode, using a mouse, we provide a high-density (small)  visual hit area for the mouse
class TouchModeToggleBtn extends StatefulWidget {
  const TouchModeToggleBtn({Key? key, required this.invertPopupAlign}) : super(key: key);
  final bool invertPopupAlign;
  @override
  _TouchModeToggleBtnState createState() => _TouchModeToggleBtnState();
}

class _TouchModeToggleBtnState extends State<TouchModeToggleBtn> {
  @override
  Widget build(BuildContext context) {
    void handleTouchModeToggled(bool value) {
      // Manually close popup when mode is toggled, this enables a new tooltip to come in
      AnchoredPopups.of(context)?.hide();
      context.read<AppModel>().enableTouchMode = !value;
    }

    AppTheme theme = context.watch();
    bool touchMode = context.select((AppModel m) => m.enableTouchMode);
    return Theme(
      // Override visual density for this btn, it has different rules than all other btns in the app
      data: ThemeData(visualDensity: VisualDensity.compact),
      child: SimpleBtn(
        onPressed: () => handleTouchModeToggled(touchMode),
        child: SizedBox(
          width: 40,
          child: Stack(
            children: [
              Positioned.fill(
                  child: AnimatedPadding(
                duration: Times.fast,
                curve: Curves.easeOut,
                padding: EdgeInsets.all(touchMode ? Insets.sm : Insets.xs),
                child: DecoratedContainer(
                  borderRadius: 99,
                  color: theme.grey.withOpacity(.3),
                  child: AnchoredPopUpRegion.hover(
                    key: ValueKey(touchMode),
                    popAnchor: widget.invertPopupAlign ? Alignment.topRight : Alignment.topLeft,
                    anchor: widget.invertPopupAlign ? Alignment.bottomRight : Alignment.bottomLeft,
                    popChild: StyledTooltip(
                      touchMode ? "Switch to Precision Mode" : "Switch to Touch Mode",
                      arrowAlignment: widget.invertPopupAlign ? Alignment.topRight : Alignment.topLeft,
                    ),
                    child: MaterialIcon(
                      touchMode ? Icons.mouse : Icons.fingerprint,
                      color: theme.accent1,
                      size: touchMode ? 16 : 26,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
