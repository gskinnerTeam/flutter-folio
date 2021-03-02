import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_widgets/positioned_all.dart';
import 'package:flutter_folio/_widgets/rounded_card.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:provider/provider.dart';

class BtnColors {
  BtnColors({@required this.bg, @required this.fg, this.outline});
  final Color bg;
  final Color fg;
  final Color outline;
}

enum BtnTheme { Primary, Secondary, Raw }

// A core btn that takes a child and wraps it in a btn that has a FocusNode.
// Colors are required. By default there is no padding.
// It takes care of adding a visual indicator  when the btn is Focused.
class RawBtn extends StatefulWidget {
  const RawBtn(
      {Key key,
      @required this.child,
      this.normalColors,
      this.hoverColors,
      @required this.onPressed,
      this.padding,
      this.focusMargin,
      this.enableShadow,
      this.enableFocus,
      this.cornerRadius})
      : super(key: key);
  final Widget child;
  final BtnColors normalColors;
  final BtnColors hoverColors;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final double focusMargin;
  final bool enableShadow;
  final bool enableFocus;
  final double cornerRadius;

  @override
  _RawBtnState createState() => _RawBtnState();
}

class _RawBtnState extends State<RawBtn> {
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(canRequestFocus: widget.enableFocus ?? true);
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant RawBtn oldWidget) {
    _focusNode.canRequestFocus = widget.enableFocus ?? true;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MaterialStateProperty<T> getMaterialState<T>({T normal, T hover}) =>
        MaterialStateProperty.resolveWith<T>((Set states) {
          if (states.contains(MaterialState.hovered)) return hover;
          if (states.contains(MaterialState.focused)) return hover;
          return normal;
        });
    AppTheme theme = Provider.of(context);
    List<BoxShadow> shadows = (widget.enableShadow ?? true) ? Shadows.universal : [];
    BtnColors normalColors = widget.normalColors ?? BtnColors(fg: theme.greyMedium, bg: Colors.transparent);
    BtnColors hoverColors = widget.hoverColors ?? BtnColors(fg: theme.focus, bg: theme.focus.withOpacity(.1));
    double focusMargin = widget.focusMargin ?? -5;
    return AnimatedOpacity(
      duration: Times.fast,
      opacity: widget.onPressed == null ? .7 : 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// Core Btn
          Container(
            // Add custom shadow
            decoration: BoxDecoration(
                borderRadius:
                    widget.cornerRadius != null ? BorderRadius.circular(widget.cornerRadius) : Corners.medBorder,
                boxShadow: shadows),
            child: TextButton(
              focusNode: _focusNode,
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(disabledMouseCursor: SystemMouseCursors.basic).copyWith(
                minimumSize: MaterialStateProperty.all(Size.zero),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.cornerRadius ?? Corners.med),
                )),
                side: getMaterialState(
                    normal: BorderSide(color: normalColors?.outline ?? Colors.transparent),
                    hover: BorderSide(color: hoverColors?.outline ?? Colors.transparent)),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor: getMaterialState(normal: normalColors.fg, hover: hoverColors.fg),
                backgroundColor: getMaterialState(normal: normalColors.bg, hover: hoverColors.bg),
              ),
              child: Padding(padding: widget.padding ?? EdgeInsets.zero, child: widget.child),
            ),
          ),

          /// Focus Decoration
          if (_focusNode.hasFocus) ...[
            PositionedAll(
              // Use negative margin for the focus state, so it lands outside our buttons actual footprint and doesn't mess up our alignments/paddings.
              all: focusMargin,
              child:
                  RoundedBorder(radius: widget.cornerRadius ?? (Corners.med - (focusMargin * .6)), color: theme.focus),
            )
          ],
        ],
      ),
    );
  }
}

// BtnContent that takes care of all the compact sizing and spacing
// Accepts label, icon and child, with child taking precedence.
class BtnContent extends StatelessWidget {
  const BtnContent(
      {Key key, this.label, this.icon, this.child, this.leadingIcon = false, this.isCompact = false, this.labelStyle})
      : super(key: key);
  final Widget child;
  final String label;
  final IconData icon;
  final bool leadingIcon;
  final bool isCompact;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    bool hasIcon = icon != null;
    bool hasLbl = StringUtils.isNotEmpty(label);
    // Add a touch of extra padding for touch users
    bool enableTouchMode = context.select((AppModel m) => m.enableTouchMode);
    int extraPadding = enableTouchMode ? 4 : 0;
    return AnimatedPadding(
      duration: Times.fast,
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(
        horizontal: (isCompact ? Insets.lg : Insets.med) + extraPadding,
        vertical: Insets.med - (isCompact ? 1 : 0) + extraPadding,
      ),
      child: child ??
          Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: leadingIcon ? TextDirection.rtl : TextDirection.ltr,
            children: [
              /// Label?
              if (hasLbl) ...[
                Text(label.toUpperCase(), style: labelStyle ?? (isCompact ? TextStyles.callout2 : TextStyles.callout1)),
              ],

              /// Spacer - Show if both pieces of content are visible
              if (hasIcon && hasLbl) ...[
                HSpace.sm,
              ],

              /// Icon?
              if (hasIcon) Icon(icon, size: isCompact ? 14 : 16),
            ],
          ),
    );
  }
}
