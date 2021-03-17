import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/native_window_utils/macos_window_utils.dart';

class MacosTitleBar extends StatefulWidget {
  const MacosTitleBar(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  _MacosTitleBarState createState() => _MacosTitleBarState();
}

class _MacosTitleBarState extends State<MacosTitleBar> {
  late Future<double> _futureHeight;

  @override
  void initState() {
    _futureHeight = MacosWindowUtils.requestTitlebarHeight();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double defaultHeight = MacosWindowUtils.kDefaultTitlebarHeight;
    return FutureBuilder<double>(
        // Request the transparent titlebar height from the OS (async)
        future: _futureHeight,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          bool isFutureDone = snapshot.connectionState == ConnectionState.done;
          double height = isFutureDone ? snapshot.data ?? defaultHeight : defaultHeight;
          return GestureDetector(
            onDoubleTap: () => MacosWindowUtils.zoom(),
            child: Container(color: Colors.transparent, height: height, child: widget.child),
          );
        });
  }
}
