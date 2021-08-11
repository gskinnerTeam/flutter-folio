import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

import 'my_movable_box.dart';

// Create a list of random boxes
double rnd([double value = 1]) => Random().nextDouble() * value;
List<BoxTransformData> _boxes = List.generate(
  200,
  (index) => BoxTransformData(offset: Offset(rnd(600), rnd(600)), scale: .5 + rnd()),
);

// Create a Stack that will render each Box
class OptimizedDragStack extends StatefulWidget {
  const OptimizedDragStack({Key? key}) : super(key: key);

  @override
  _OptimizedDragStackState createState() => _OptimizedDragStackState();
}

class _OptimizedDragStackState extends State<OptimizedDragStack> {
  // When a box ask to go on top, just re-order the list and rebuild.
  // This will cause the entire stack to rebuild once, which is pretty expensive, but ok since it only happens once per drag.
  void _handleMoveStart(BoxTransformData bt) {
    _boxes.remove(bt);
    _boxes.add(bt);
    setState(() {});
  }

  bool get _useOptimizedBuildMethod => true;
  void _handleMoveUpdated(BoxTransformData data, Offset delta) {
    // Update position of box
    data.offset += delta;
    // Now there's 2 ways we can rebuild the view...
    if (_useOptimizedBuildMethod) {
      // FAST: Trigger a notifyListeners() calls on the data object itself.
      // Only the box tied to this data will call setState
      data.notifyListeners();
    } else {
      // SLOW: Rebuild the parent stack. This works too, but EVERY child rebuilds.
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Stack(
        // Create a bunch of Box Widgets from our BoxTransforms
        children: _boxes.map(
          (BoxTransformData boxData) {
            return MyMovableBox(
                // Give each box a key, so it won't lose it's state when _boxes is re-ordered
                key: ValueKey(boxData),
                data: boxData,
                onMoveStarted: _handleMoveStart,
                onMoveUpdated: _handleMoveUpdated,
                child: _SquareImage(scale: boxData.scale));
          },
        ).toList(),
      )),
    );
  }
}

class _SquareImage extends StatelessWidget {
  final double scale;

  const _SquareImage({Key? key, this.scale = 1}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100 * scale,
        height: 100 * scale,
        child: Container(
          padding: const EdgeInsets.all(20),
          color: RandomColor().randomColor(),
          child: CachedNetworkImage(
            imageUrl:
                "https://images.unsplash.com/photo-1557800636-894a64c1696f?ixlib=rb-1.2.1&auto=format&fit=crop&w=701&q=80",
            fit: BoxFit.cover,
          ),
        ));
  }
}
