import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/device_info.dart';
import 'package:flutter_folio/_utils/input_utils.dart';
import 'package:flutter_folio/_utils/native_window_utils/window_utils.dart';
import 'package:flutter_folio/_widgets/alignments.dart';
import 'package:flutter_folio/_widgets/popover/popover_notifications.dart';
import 'package:flutter_folio/_widgets/popover/popover_region.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/app_user.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/views/user_profile_card/user_profile_card.dart';
import 'package:universal_platform/universal_platform.dart';

part 'app_title_bar_desktop.dart';
part 'app_title_bar_mobile.dart';

class AppTitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch();
    // Optionally wrap the content in a Native title bar. This may be a no-op depending on platform.
    return IoUtils.instance.wrapNativeTitleBarIfRequired(SizedBox(
      height: UniversalPlatform.isMacOS ? 28 : 40,
      child: Stack(
        children: [
          // All titlebars share a bg
          ShadowedBg(theme.surface1),
          // Switch between mobile and desktop title bars
          if (DeviceInfo.isDesktop || kIsWeb) ...[
            _AppTitleBarDesktop(),
          ] else ...[
            _AppTitleBarMobile(),
          ]
        ],
      ),
    ));
  }
}

class _TitleText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool enableVersion = false;
    return IgnorePointer(
      child: Stack(
        children: [
          Center(child: AppLogoText(constraints: BoxConstraints(maxHeight: 12))),
          if (enableVersion) ...[
            BottomCenter(
                child:
                    Text("v" + AppModel.kVersion, style: TextStyles.body3.copyWith(fontSize: 10, color: Colors.grey))),
          ]
        ],
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of(context);
    return FadeInDown(
        child: SimpleBtn(
      onPressed: () => handleBackPressed(context),
      child: Container(
        height: double.infinity,
        child: Row(
          children: [
            Icon(Icons.chevron_left),
            Text("Back", style: TextStyles.body2.copyWith(color: theme.greyStrong)),
            HSpace.med
          ],
        ),
      ),
    ));
  }

  void handleBackPressed(BuildContext context) {
    InputUtils.unFocus();
    context.read<AppModel>().popNav();
  }
}

class _AdaptiveProfileBtn extends StatelessWidget {
  const _AdaptiveProfileBtn({Key key, this.useBottomSheet = false, this.invertRow = false, this.isVisible = true})
      : super(key: key);
  final bool useBottomSheet;
  final bool invertRow;
  final bool isVisible;
  @override
  Widget build(BuildContext context) {
    AppUser user = context.select((AppModel m) => m.currentUser);
    if (user == null) return Container();
    // Use a non-scaled vertical padding here
    final profileIcon = StyledCircleImage(
      padding: EdgeInsets.symmetric(horizontal: Insets.med, vertical: 4),
      url: user?.imageUrl ?? AppUser.kDefaultImageUrl,
      borderSize: 2,
    );

    return Visibility(
        visible: isVisible,
        child: useBottomSheet
            ? SimpleBtn(
                onPressed: () => _showProfileSheet(context),
                child: profileIcon,
              )
            : PopOverRegion.click(
                popChild: ClipRect(
                  child: UserProfileCard(),
                  //child: Container(width: 100, height: 100, color: Colors.red),
                ),
                popAnchor: invertRow ? Alignment.topRight : Alignment.topLeft,
                anchor: invertRow ? Alignment.bottomRight : Alignment.bottomLeft,
                child: profileIcon));
  }

  void _showProfileSheet(BuildContext context) {
    showStyledBottomSheet(context, child: BottomSheetProfileEditorCard());
  }
}
