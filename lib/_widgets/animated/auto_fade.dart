import 'package:flutter/material.dart';

class AutoFade extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final Curve curve;

  const AutoFade({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = Offset.zero,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOut,
  }) : super(key: key);
  @override
  _AutoFadeState createState() => _AutoFadeState();
}

class _AutoFadeState extends State<AutoFade> with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> anim;

  @override
  void initState() {
    animController = AnimationController(vsync: this, duration: widget.duration);
    animController.addListener(() => setState(() {}));
    anim = animController.drive(CurveTween(curve: widget.curve));
    Future.delayed(widget.delay, () {
      if (mounted) animController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Offset startPos = widget.offset;
    Animation<Offset> position = Tween<Offset>(begin: startPos, end: Offset.zero).animate(anim);
    return Transform.translate(
      offset: position.value,
      child: Opacity(opacity: anim.value, child: widget.child),
    );
  }
}
