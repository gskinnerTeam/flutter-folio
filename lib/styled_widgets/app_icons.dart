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
  view,
  github,
  website
}

class AppIcon extends StatelessWidget {
  final AppIcons icon;
  final double size;
  final Color color;

  const AppIcon(this.icon, {Key? key, required this.size, required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String i = describeEnum(icon).toLowerCase().replaceAll("_", "-");
    String path = 'assets/images/icons/' + i + '.png';
    //print(path);
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Image.asset(path, width: size, height: size, color: color, filterQuality: FilterQuality.high),
      ),
    );
  }
}
