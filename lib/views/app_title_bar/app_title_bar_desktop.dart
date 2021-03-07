part of 'app_title_bar.dart';

class _AppTitleBarDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Determine whether to show back button. We don't want to show it for "guest" users
    bool isGuestUser = context.select((AppModel m) => m.isGuestUser);
    bool canGoBack = context.select((AppModel m) => m.canPopNav);
    bool showBackBtn = isGuestUser == false && canGoBack;

    bool isMac = UniversalPlatform.isMacOS;
    bool isMobile = context.widthPx < Sizes.smallPhone;
    bool showTouchToggle = true; //context.select((AppModel m) => m.hasUser) == true;

    return Stack(children: [
      // Centered TitleText
      Center(child: _TitleText()),
      // Btns
      Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isMac) ...[
            // Mac title bar has a different layout as it's window btns are left aligned
            HSpace(80), // Reserve some space for the native btns
            if (showBackBtn) _BackBtn(),
            Spacer(),
            if (showTouchToggle) _TouchModeToggleBtn(invertPopupAlign: isMac),
            HSpace.med,
            _AdaptiveProfileBtn(invertRow: true, useBottomSheet: isMobile),
          ] else ...[
            // Linux and Windows are left aligned and simple
            _AdaptiveProfileBtn(useBottomSheet: isMobile),
            HSpace.sm,
            if (showTouchToggle) _TouchModeToggleBtn(invertPopupAlign: isMac),
            HSpace.sm,
            if (showBackBtn) _BackBtn(),
          ]
        ],
      ),
    ]);
  }
}

class _TouchModeToggleBtn extends StatelessWidget {
  const _TouchModeToggleBtn({Key key, @required this.invertPopupAlign}) : super(key: key);
  final bool invertPopupAlign;

  @override
  Widget build(BuildContext context) {
    void handleTouchModeToggled(bool value) {
      ClosePopoverNotification().dispatch(context);
      context.read<AppModel>().enableTouchMode = !value;
    }

    AppTheme theme = context.watch();
    bool touchMode = context.select((AppModel m) => m.enableTouchMode);
    double padding = touchMode ? 4 : 0;
    return Center(
      child: SimpleBtn(
        cornerRadius: 99,
        onPressed: () => handleTouchModeToggled(touchMode),
        child: SizedBox(
          width: 32,
          height: 32,
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
      ),
    );
  }
}
