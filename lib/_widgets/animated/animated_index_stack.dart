import 'package:flutter/material.dart';

class AnimatedIndexStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const AnimatedIndexStack({
    Key? key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 250),
  }) : super(key: key);

  @override
  _AnimatedIndexStackState createState() => _AnimatedIndexStackState();
}

class _AnimatedIndexStackState extends State<AnimatedIndexStack> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedIndexStack oldWidget) {
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(index: widget.index, children: widget.children),
    );
  }
}
