import 'package:anchored_popups/anchored_popup_region.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';

class StyledToggleSwitch extends StatefulWidget {
  StyledToggleSwitch(
      {Key? key,
      this.value = false,
      this.onToggled,
      required this.tooltip1,
      required this.tooltip2,
      this.icon1,
      this.icon2,
      this.materialIcon1,
      this.materialIcon2})
      : super(key: key) {
    assert((icon1 != null || materialIcon1 != null) && (icon2 != null || materialIcon2 != null));
  }
  final bool value;
  final void Function(bool value)? onToggled;
  final AppIcons? icon1;
  final IconData? materialIcon1;
  final String tooltip1;
  final AppIcons? icon2;
  final IconData? materialIcon2;
  final String tooltip2;

  @override
  _StyledToggleSwitchState createState() => _StyledToggleSwitchState();
}

class _StyledToggleSwitchState extends State<StyledToggleSwitch> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    BoxDecoration dec(Color c, double b) => BoxDecoration(color: c, borderRadius: BorderRadius.circular(b));
    double btnSize = 36 + Theme.of(context).visualDensity.vertical * 4;
    return SizedBox(
      width: btnSize * 2,
      height: btnSize,
      child: Stack(
        children: [
          // Dual-color bg
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: dec(theme.surface1, Corners.sm),
            child: Container(decoration: dec(theme.bg1, Corners.sm - 1)),
          ),

          Positioned.fill(
              child: Row(
            children: [
              _BtnWithTooltip(
                onPressed: !widget.value ? null : () => widget.onToggled?.call(false),
                child: _buildIcon(widget.icon1, widget.materialIcon1),
                toolTip: widget.tooltip1,
              ),
              _BtnWithTooltip(
                onPressed: !widget.value ? () => widget.onToggled?.call(true) : null,
                child: _buildIcon(widget.icon2, widget.materialIcon2),
                toolTip: widget.tooltip2,
              ),
            ],
          )),

          // Top Sliding Btn
          AnimatedContainer(
            duration: Times.medium,
            curve: Curves.easeOut,
            alignment: Alignment(widget.value ? 1 : -1, 0),

            /// Top icon should block clicks
            child: IgnorePointer(
              child: Container(
                width: btnSize,
                height: btnSize,
                decoration: dec(theme.surface1, Corners.sm).copyWith(boxShadow: Shadows.universal),

                /// Add an animated switcher around the icons, so we get a nice fade effect when they change
                child: AnimatedSwitcher(
                  duration: Times.fast,
                  child: Container(
                    key: ValueKey(widget.value), // key is required to trigger AnimatedSwitcher
                    child: (widget.value)
                        ? _buildIcon(widget.icon2, widget.materialIcon2, color: theme.accent1)
                        : _buildIcon(widget.icon1, widget.materialIcon1, color: theme.accent1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(AppIcons? appIcon, IconData? materialIcon, {Color? color}) {
    AppTheme theme = context.watch();
    color ??= theme.grey;
    double size = 16;
    if (appIcon != null) return AppIcon(appIcon, color: color, size: size);
    if (materialIcon != null) return Icon(materialIcon, color: color, size: size);
    return Container();
  }
}

class _BtnWithTooltip extends StatelessWidget {
  final VoidCallback? onPressed;
  final String toolTip;
  final Widget child;

  const _BtnWithTooltip({Key? key, this.onPressed, required this.toolTip, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnchoredPopUpRegion.hover(
        popChild: StyledTooltip(toolTip),
        child: SimpleBtn(onPressed: onPressed, child: Center(child: child)),
      ),
    );
  }
}
