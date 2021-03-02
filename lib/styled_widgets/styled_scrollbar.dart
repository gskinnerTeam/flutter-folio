import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/models/app_model.dart';

class StyledScrollbar extends StatelessWidget {
  const StyledScrollbar({
    Key key,
    @required this.child,
    @required this.controller,
    this.padding,
  }) : super(key: key);
  final Widget child;
  final ScrollController controller;
  final EdgeInsets padding;

  //TODO: Log bug for scrollbar: clicking the track should jump to that approximate position
  @override
  Widget build(BuildContext context) {
    bool touchMode = context.select((AppModel m) => m.enableTouchMode);
    return Scrollbar(
      controller: controller,
      radius: Corners.smRadius,
      thickness: touchMode ? 6 : 10,
      showTrackOnHover: false,
      isAlwaysShown: touchMode == false,
      child: Padding(padding: padding ?? EdgeInsets.only(right: Insets.lg), child: child),
    );
  }
}
