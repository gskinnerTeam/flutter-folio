import 'package:anchored_popups/anchored_popup_region.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/app_user.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/views/user_profile_card/user_profile_card.dart';
import 'package:flutter_folio/views/user_profile_card/user_profile_form.dart';

class RoundedProfileBtn extends StatelessWidget {
  const RoundedProfileBtn({Key? key, this.useBottomSheet = false, this.invertRow = false}) : super(key: key);
  final bool useBottomSheet;
  final bool invertRow;
  @override
  Widget build(BuildContext context) {
    AppUser? user = context.select((AppModel m) => m.currentUser);
    if (user == null) return Container();
    //
    Widget profileIcon =
        StyledCircleImage(padding: EdgeInsets.all(Insets.xs), url: user.imageUrl ?? AppUser.kDefaultImageUrl);
    return useBottomSheet
        ? SimpleBtn(ignoreDensity: true, onPressed: () => _showProfileSheet(context), child: profileIcon)
        : AnchoredPopUpRegion.hoverWithClick(
            clickPopChild: const ClipRect(
              child: UserProfileCard(),
              //child: Container(width: 100, height: 100, color: Colors.red),
            ),
            hoverPopChild: const StyledTooltip("Open User Info panel"),
            buttonBuilder: (_, child, show) => SimpleBtn(onPressed: show, child: child),
            hoverPopAnchor: invertRow ? Alignment.topRight : Alignment.topLeft,
            clickPopAnchor: invertRow ? Alignment.topRight : Alignment.topLeft,
            clickAnchor: invertRow ? Alignment.bottomRight : Alignment.bottomLeft,
            child: profileIcon);
  }

  void _showProfileSheet(BuildContext context) {
    showStyledBottomSheet(context,
        child: Container(
          padding: EdgeInsets.all(Insets.xl),
          child: const UserProfileForm(bottomSheet: true),
        ));
  }
}
