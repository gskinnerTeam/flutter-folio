import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/src/gestures/events.dart';
import 'package:flutter_folio/_utils/input_utils.dart';
import 'package:flutter_folio/_utils/keyboard_utils.dart';
import 'package:flutter_folio/_widgets/mixins/raw_keyboard_listener_mixin.dart';
import 'package:vector_math/vector_math_64.dart' as math64;

import 'movable_scrap.dart';
import 'scrap_data.dart';

class Scrapboard<T> extends StatefulWidget {
  const Scrapboard(
      {Key? key,
      required this.boxes,
      required this.itemBuilder,
      this.onTranslated,
      this.onTranslateEnded,
      this.onBoxDeleted,
      this.onOrderChanged,
      required this.idBuilder,
      required this.lockAspectForItem,
      this.startOffset = Offset.zero,
      this.readOnly = false,
      this.onSelectionChanged,
      this.itemControlsBuilder})
      : super(key: key);

  final List<ScrapData<T>> boxes;
  final Widget Function(T data) itemBuilder;
  final Widget Function(T data)? itemControlsBuilder;
  final String Function(ScrapData<T>) idBuilder;
  final bool Function(ScrapData<T>) lockAspectForItem;
  final Offset startOffset;

  final void Function(ScrapData<T>)? onTranslated;
  final void Function(ScrapData<T>)? onTranslateEnded;
  final void Function(ScrapData<T>)? onBoxDeleted;
  final void Function(ScrapData<T> selected, List<ScrapData<T>> all)? onOrderChanged;
  final void Function(ScrapData<T>? selected, List<ScrapData<T>> all)? onSelectionChanged;

  final bool readOnly;

  @override
  ScrapboardState createState() => ScrapboardState<T>();
}

class ScrapboardState<T> extends State<Scrapboard<T>> with RawKeyboardListenerMixin {
  bool get _lockAspectOnResize => KeyboardUtils.isSpanSelectModifierDown;
  double kBoardHeight = 1200;
  double kBoardWidth = 1200 * 1.33;

  /// Internal
  ValueNotifier<bool> isCardHovered = ValueNotifier(false);
  final TransformationController _transformController = TransformationController();
  double _scale = 1;
  final List<String> _selectedBoxIds = [];
  bool _isSpaceBarDown = false;

  // We create a copy of the assigned boxList, so we can work on it internally
  List<ScrapData<T>> get _tmpBoxes => widget.boxes;

  // We create a key for each boxData so we can access their state and control them if needed.
  final Map<String, GlobalKey<MovableScrapState>> _boxKeysById = {};

  @override
  bool get enableKeyListener => true;

  @override
  void initState() {
    super.initState();

    // Respect a startOffset so parent widgets can control the initial positition of the InteractiveViewer
    // Respect a startOffset so parent widgets can control the initial position of the InteractiveViewer
    _transformController.value = Matrix4.translation(
      math64.Vector3(widget.startOffset.dx, widget.startOffset.dy, 0),
    );
    _transformController.addListener(_handleViewerTransformed);
  }

  @override
  Widget build(BuildContext context) {
    final _selected = _getSelectedBoxInstances();
    // If a singe item is selected, use the itemControlsBuilder to show any item controls provided by the parent widget.
    Widget? itemControls;
    if (_selected.isNotEmpty) {
      itemControls = widget.itemControlsBuilder?.call(_selected.first.data);
    }
    return Scaffold(
      body: Stack(
        children: [
          ValueListenableBuilder(
            // When a card is highlighted, we want to disable pan/scale on the InteractiveViewer
            valueListenable: isCardHovered,
            builder: (BuildContext context, bool value, Widget? cachedChild) {
              return GestureDetector(
                onTap: _handleBgPressed,
                child: InteractiveViewer(
                    transformationController: _transformController,
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    minScale: 0.5,
                    maxScale: 3,
                    constrained: false,
                    scaleEnabled: !value,
                    panEnabled: !value,
                    child: cachedChild!),
              );
            },
            // Cache the Stack of Scraps so we can control panEnabled/scaleEnabled without rebuilding every card
            child: Container(
              width: kBoardWidth,
              height: kBoardHeight,
              color: Colors.grey.shade300,
              child: ClipRect(
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    ..._tmpBoxes.map((boxData) {
                      String boxId = widget.idBuilder(boxData);
                      bool isSelected = _selectedBoxIds.contains(boxId);
                      bool showControls = isSelected && _selectedBoxIds.length == 1;
                      return MovableScrap<T>(
                        // Each box needs a key so it doesn't lose state when the stack-order is changed
                        // This also reduces draw calls
                        key: _getBoxKey(boxId),
                        data: boxData,
                        onPressed: _handleBoxTap,
                        onMoved: _handleBoxMoved,
                        //Pass moveEnd directly to the widget
                        onMoveComplete: _handleBoxMoveComplete,
                        // Scale
                        onZoomed: _handleZoom,
                        // Corner Drag
                        onCornerDragged: _handleCornerDragged,
                        onRotateDragged: _handleRotateDragged,
                        onCornerDragComplete: _handleDragComplete,
                        // Allow the box to animate itself out, and then ask us to delete
                        onOutTweenComplete: _handleBoxDeleteTriggered,
                        // Watch boxes to see if the mouse is over one, if we are, we'll disable InteractiveViewer for panning/scrolling
                        onMouseOverChanged: _handleMouseOverChanged,
                        isSelected: showControls,
                        showControls: showControls,
                        // Use provided builder to render actual item
                        child: widget.itemBuilder.call(boxData.data),
                      );
                    }).toList(),

                    if (itemControls != null) ...[
                      itemControls,
                    ],

                    /// Use a transparent layer to block any interaction when we're in read-only mode
                    if (widget.readOnly || _isSpaceBarDown) ...[
                      MouseRegion(
                        cursor: SystemMouseCursors.move,
                        child: Container(color: Colors.transparent),
                      )
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Size _clampBoxSize(ScrapData<T> boxData) => Size(
        boxData.size.width.clamp(150, 2000).toDouble(),
        boxData.size.height.clamp(150, 2000).toDouble(),
      );

  // Gets a cached key for a given document id
  GlobalKey<MovableScrapState> _getBoxKey(String id) {
    if (!_boxKeysById.containsKey(id)) {
      _boxKeysById[id] = GlobalKey<MovableScrapState>();
      //print("CreateKey: $id");
    }
    return _boxKeysById[id]!;
  }

  List<ScrapData<T>> _getSelectedBoxInstances() =>
      _tmpBoxes.where((b) => _selectedBoxIds.contains(widget.idBuilder(b))).toList();

  @override
  // Enter "move" mode when space is held down
  void handleKeyDown(RawKeyDownEvent value) {
    if (value.logicalKey == LogicalKeyboardKey.space) {
      setState(() => _isSpaceBarDown = true);
    }
  }

  @override
  void handleKeyUp(RawKeyUpEvent value) async {
    if (value.logicalKey == LogicalKeyboardKey.space) {
      setState(() => _isSpaceBarDown = false);
    }
  }

  void _handleBoxMoved(ScrapData<T> boxData, Offset delta) {
    boxData.offset += delta / _scale;
    widget.onTranslated?.call(boxData);
  }

  void _handleBoxMoveComplete(ScrapData<T> boxData) {
    widget.onTranslateEnded?.call(boxData);
  }

  void _handleZoom(ScrapData<T> boxData, double delta) {
    //print(delta);
    boxData.size *= 1 + delta;
    boxData.size = _clampBoxSize(boxData);
    widget.onTranslated?.call(boxData);
  }

  void _handleCornerDragged(ScrapData<T> boxData, Offset delta) {
    bool isLockForced = widget.lockAspectForItem.call(boxData);
    if (_lockAspectOnResize || isLockForced) {
      bool useHz = (delta.dx).abs() > (delta.dy).abs();
      delta = Offset(useHz ? delta.dx : delta.dy * boxData.aspect, useHz ? delta.dx / boxData.aspect : delta.dy);
    }
    Size origSize = boxData.size;
    boxData.size += delta;
    boxData.size = _clampBoxSize(boxData); // Enforce min size
    delta = Offset(boxData.size.width - origSize.width, boxData.size.height - origSize.height);
    boxData.offset += delta * .5;
    widget.onTranslated?.call(boxData);
  }

  void _handleDragComplete(ScrapData<T> boxData) {
    widget.onTranslateEnded?.call(boxData);
  }

  void _handleRotateDragged(ScrapData<T> boxData, Offset delta) {
    double d = delta.dx.abs() > delta.dy.abs() ? delta.dx : delta.dy;
    double rot = d > 0 ? .5 : -.5;
    rot = (boxData.rot + rot).clamp(-30.0, 30.0);
    boxData.rot = rot;
    widget.onTranslated?.call(boxData);
  }

  void _handleBoxTap(ScrapData<T> boxData) {
    void moveBoxToTop() {
      _tmpBoxes.remove(boxData);
      _tmpBoxes.add(boxData);
    }

    String id = widget.idBuilder(boxData);
    _selectedBoxIds.clear();
    _selectedBoxIds.add(id);
    //setState(() {});
    widget.onOrderChanged?.call(boxData, _tmpBoxes);
    widget.onSelectionChanged?.call(boxData, _getSelectedBoxInstances());
    setState(() => moveBoxToTop());
  }

  void _handleBoxDeleteTriggered(ScrapData<T> data) {
    setState(() => _tmpBoxes.remove(data));
    widget.onBoxDeleted?.call(data);
  }

  // Each box will handle it's own movement but we need to disable InteractiveViewer when one is moused over.
  void _handleMouseOverChanged(bool value) {
    isCardHovered.value = value;
  }

  void _handleBgPressed() {
    InputUtils.unFocus();
    setState(() {
      _selectedBoxIds.clear();
      widget.onSelectionChanged?.call(null, []);
    });
  }

  // scale the movement with the viewer scale, so we always get 1:1 movement with the mouse
  // ie, if the viewer is zoomed to 0.5x scale, we will 2x the mouseDelta, which feels correct.
  void _handleViewerTransformed() => _scale = _transformController.value.row0[0];
}
