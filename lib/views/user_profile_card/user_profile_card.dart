import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/input_utils.dart';
import 'package:flutter_folio/_widgets/animated/animated_fractional_offset.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/views/user_profile_card/user_profile_form.dart';

/// Wraps a [UserProfileForm] with some constraints, and a "slide down" animation.
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    VisualDensity density = Theme.of(context).visualDensity;
    return GestureDetector(
      onTap: InputUtils.unFocus,
      child: SizedBox(
          width: 280,
          height: 400 + density.vertical * 24,
          child: Stack(
            children: [
              Positioned.fill(
                  child: AnimatedFractionalOffset(
                duration: Times.medium,
                curve: Curves.easeOut,
                begin: const Offset(0, -1),
                end: const Offset(0, 0),
                child: Container(
                  padding: EdgeInsets.only(left: Insets.lg, right: Insets.lg, top: Insets.med),
                  decoration: BoxDecoration(
                    color: theme.surface1,
                    borderRadius: const BorderRadius.vertical(bottom: Corners.smRadius),
                  ),
                  child: const UserProfileForm(),
                ),
              )),
              _TopShadow(),
            ],
          )),
    );
  }
}

class _TopShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRect(
        child: FractionalTranslation(
            translation: const Offset(0, -1),
            child: Container(decoration: BoxDecoration(color: Colors.red, boxShadow: Shadows.universal))),
      ),
    );
  }
}
