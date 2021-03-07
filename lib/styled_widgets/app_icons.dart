import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum AppIcons {
  add,
  camera,
  emoji,
  image,
  link_out,
  move_forward,
  scraps,
  send_backward,
  share,
  star,
  text,
  toggle_carousel,
  toggle_list,
  trashcan,
  view
}

class AppIcon extends StatelessWidget {
  final AppIcons icon;
  final double size;
  final Color color;

  const AppIcon(this.icon, {Key key, this.size, this.color}) : super(key: key);
  Widget build(BuildContext c) {
    String i = describeEnum(icon).toLowerCase().replaceAll("_", "-");
    return Container(
      width: size,
      height: size,
      child: Center(
        child: Image.asset('assets/images/icons/' + i + '.png', width: size, height: size, color: color),
      ),
    );
  }
}
