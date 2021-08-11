import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/_widgets/listenable_builder.dart';
import 'package:flutter_folio/_widgets/sized_and_translated.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/views/editor_page/scrapboard/movable_scrap_selection_box.dart';
import 'package:flutter_folio/views/editor_page/scrapboard/scrap_data.dart';

// Wraps some content in a draggable box and with editing controls
// Provides basic support for translation, selection and scale events
class MovableScrap<T> extends StatefulWidget {
  const MovableScrap({
    Key? key,
    required this.data,
    required this.child,
    required this.onMoved,
    required this.onMoveComplete,
    required this.onCornerDragged,
    required this.onRotateDragged,
    required this.onCornerDragComplete,
    required this.onZoomed,
    this.onPressed,
    this.onOutTweenComplete,
    required this.onMouseOverChanged,
    this.isSelected = false,
    this.showControls = false,
  }) : super(key: key);
  final ScrapData<T> data;
  final Widget child;
  final bool isSelected;
  final bool showControls;
  final void Function(ScrapData<T> data, Offset delta) onMoved;
  final void Function(ScrapData<T> data) onMoveComplete;
  final void Function(ScrapData<T> data, double delta) onZoomed;
  final void Function(ScrapData<T> data, Offset delta) onCornerDragged;
  final void Function(ScrapData<T> data, Offset delta) onRotateDragged;
  final void Function(ScrapData<T> data) onCornerDragComplete;
  final void Function(ScrapData<T> data)? onPressed;
  final void Function(ScrapData<T> data)? onOutTweenComplete;
  final void Function(bool) onMouseOverChanged;

  @override
  MovableScrapState createState() => MovableScrapState();
}

class MovableScrapState extends State<MovableScrap> {
  final GlobalKey<MovableScrapSelectionBoxState> _uiKey = GlobalKey();

  Offset? _lastPanPos;
  //double get scale => widget.data.scale;
  Offset get offset => widget.data.offset;
  double get width => widget.data.size.width;
  double get height => widget.data.size.height;

  @override
  Widget build(BuildContext context) {
    double btnSize = Insets.xl;
    return ListenableBuilder(
      listenable: widget.data, // rebuild whenever our data changes
      builder: (BuildContext context, Widget? child) {
        // Position Content
        return SizedAndTranslated(
          size: Size(max(width, 0), max(height, 0)),
          offset: offset,
          child: Stack(
            children: [
              // Controls
              Transform.rotate(
                angle: widget.data.rot * pi / 180,
                child: MovableScrapSelectionBox(
                  key: _uiKey,
                  onZoomed: (value) => widget.onZoomed(widget.data, value),
                  onCornerDrag: (value) => widget.onCornerDragged(widget.data, value),
                  onRotateDrag: (value) => widget.onRotateDragged(widget.data, value),
                  onDragEnded: () => widget.onCornerDragComplete(widget.data),
                  isVisible: widget.showControls,
                  child: Padding(
                    padding: EdgeInsets.all(3 + btnSize),
                    // Rotate the box content according to .rot setting
                    child: _DraggableHitArea(this, child: widget.child),
                  ),
                  btnSize: btnSize,
                  showControls: widget.showControls,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleTapUp() {
    // Send move complete if we were moved
    if (_lastPanPos != null) {
      _lastPanPos = null;
      widget.onMoveComplete.call(widget.data);
    } else {
      widget.onPressed?.call(widget.data);
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _lastPanPos = details.focalPoint;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_lastPanPos == null) return;
    widget.onMoved.call(widget.data, (details.focalPoint - _lastPanPos!));
    _lastPanPos = details.focalPoint;
  }
}

class _DraggableHitArea extends StatelessWidget {
  const _DraggableHitArea(this.state, {Key? key, required this.child, this.isEnabled = true}) : super(key: key);
  final MovableScrapState state;
  final Widget child;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    if (isEnabled == false) return child;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => state.widget.onMouseOverChanged.call(true),
      onExit: (_) => state.widget.onMouseOverChanged.call(false),
      child: GestureDetector(
        onScaleStart: state._handleScaleStart,
        onScaleUpdate: state._handleScaleUpdate,
        onScaleEnd: (_) => state._handleTapUp(),
        onTap: state._handleTapUp,
        //onTapDown: (_) => state._handleTapDown(),
        // Use simple btn for easy mouseOver effect
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
