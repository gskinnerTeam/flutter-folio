import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BoxTransformData extends ChangeNotifier {
  Offset offset;
  double scale;
  BoxTransformData({this.offset = Offset.zero, this.scale = 1});

  @override
  // ignore: unnecessary_overrides
  void notifyListeners() => super.notifyListeners();
}

class MyMovableBox extends StatelessWidget {
  const MyMovableBox(
      {Key? key, required this.child, required this.data, this.onMoveStarted, this.onMoveUpdated, this.onScaleUpdated})
      : super(key: key);
  final BoxTransformData data;
  final void Function(BoxTransformData)? onMoveStarted;
  final void Function(BoxTransformData, Offset)? onMoveUpdated;
  final void Function(BoxTransformData, double)? onScaleUpdated;
  final Widget child;

  // Move dispatchers
  void _handlePanStart(DragStartDetails details) => onMoveStarted?.call(data);
  void _handlePanUpdate(DragUpdateDetails details) => onMoveUpdated?.call(data, details.delta);

  // Mouse-wheel
  void _handlePointerSignal(PointerSignalEvent signal) {
    if (signal is PointerScrollEvent) {
      double delta = -signal.scrollDelta.dy * .001;
      onScaleUpdated?.call(data, delta);
    }
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    return Listener(
      //Listen for mouse-wheel scroll
      onPointerSignal: _handlePointerSignal,
      child: GestureDetector(
        // Listen for drag and pinch events
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        // Rebuild the box anytime it's data changes
        child: AnimatedBuilder(
          animation: data,
          builder: (BuildContext context, _) {
            // Position the child, using a margin to offset it (you can use Transform.translate instead to avoid squishing at the margins)
            return Container(
                padding: EdgeInsets.only(
                  left: max(0, data.offset.dx),
                  top: max(0, data.offset.dy),
                ),
                child: child);
          },
        ),
      ),
    );
  }
}
