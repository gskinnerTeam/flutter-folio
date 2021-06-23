import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum Emojis {
  beers,
  checkmark,
  confetti,
  cool,
  crying_face,
  dizzy_face,
  exclamation_question,
  fire,
  folded_hands,
  heart_eyes,
  hundred_points,
  kissing_face,
  location_pin,
  musical_notes,
  palms_up,
  pile_of_poo,
  red_heart,
  shooting_star,
  smiling_eyes,
  sparkles,
  squinting_face,
  sunglasses_face,
  tears_of_joy_face,
  warning_sign,
}

class Emoji extends StatelessWidget {
  final Emojis? emoji;
  final double? size;

  const Emoji(this.emoji, {Key? key, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (emoji == null) return Container();
    String fileName = describeEnum(emoji!).toLowerCase().replaceAll("_", "-");
    String path = 'assets/images/emoji/' + fileName + '.svg';
    return SvgPicture.asset(path, width: size, height: size);
  }
}
