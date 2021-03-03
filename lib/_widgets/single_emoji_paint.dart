import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class SingleEmojiPaint extends StatelessWidget {
  const SingleEmojiPaint(this.emoji, {Key key}) : super(key: key);
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: CustomPaint(painter: _EmojiPainter(emoji)),
      )
    ]);
  }
}

class _EmojiPainter extends CustomPainter {
  _EmojiPainter(this.emoji);
  final String emoji;

  @override
  void paint(Canvas canvas, Size size) {
    // A bunch of hacks to get emojis right on windows and mac
    double fontScale = UniversalPlatform.isMacOS ? 1.09 : .88;
    double offsetX = UniversalPlatform.isMacOS ? -.04 : -.1;
    double offsetY = UniversalPlatform.isMacOS ? -.04 : 0;
    ;
    TextSpan span = new TextSpan(
        style: new TextStyle(
          //fontFamily: Fonts.emoji,
          height: 1.14,
          fontSize: size.height * fontScale,
          color: Colors.black,
        ),
        text: emoji ?? "😀");
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(size.width * offsetX, size.height * offsetY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
