import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MeasureSizeRenderObject extends RenderProxyBox {
  MeasureSizeRenderObject(this.onChange);
  void Function(Size size) onChange;

  Size? _prevSize;
  @override
  void performLayout() {
    super.performLayout();
    Size newSize = child?.size ?? Size.zero;
    if (_prevSize == newSize) return;
    _prevSize = newSize;
    WidgetsBinding.instance?.addPostFrameCallback((_) => onChange(newSize));
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  const MeasureSize({Key? key, required this.onChange, required Widget child}) : super(key: key, child: child);
  final void Function(Size size) onChange;
  @override
  RenderObject createRenderObject(BuildContext context) => MeasureSizeRenderObject(onChange);
}
