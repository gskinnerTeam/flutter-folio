// @dart=2.12
import 'package:flutter/material.dart';

class WidgetA extends StatelessWidget {
  const WidgetA(this.size, {Key? key, required this.title, this.desc}) : super(key: key);
  final String title;
  final String? desc;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
