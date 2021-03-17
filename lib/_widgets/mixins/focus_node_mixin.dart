import 'package:flutter/material.dart';

mixin SingleFocusNodeMixin<T extends StatefulWidget> on State<T> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
