import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/_utils/device_info.dart';
import 'package:flutter_folio/_utils/keyboard_utils.dart';
import 'package:flutter_folio/_utils/notifications/close_notification.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_widgets/context_menu_overlay.dart';
import 'package:flutter_folio/_widgets/gradient_container.dart';
import 'package:flutter_folio/_widgets/mixins/raw_keyboard_listener_mixin.dart';
import 'package:flutter_folio/_widgets/positioned_all.dart';
import 'package:flutter_folio/commands/books/upload_image_scraps_command.dart';
import 'package:flutter_folio/commands/pick_images_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'scrap_pile_picker_title_bar.dart';
import 'selectable_scrap_btn.dart';

part 'scrap_pile_picker_view.dart';

/// [ScrapPilePickerState] acts as a controller for [ScrapPilePickerView]
class ScrapPilePicker extends StatefulWidget {
  const ScrapPilePicker({
    Key key,
    @required this.bookId,
    this.contextMenuLabels,
    this.contextMenuActions,
    this.onSelectionChanged,
    this.onDeletePressed,
    this.mobileMode = false,
  }) : super(key: key);

  final String bookId;
  final List<String> Function(ScrapItem item) contextMenuLabels;
  final List<VoidCallback> Function(ScrapItem item) contextMenuActions;
  final void Function(List<ScrapItem> items) onSelectionChanged;
  final VoidCallback onDeletePressed;
  final bool mobileMode;

  @override
  ScrapPilePickerState createState() => ScrapPilePickerState();
}

class ScrapPilePickerState extends State<ScrapPilePicker> with RawKeyboardListenerMixin {
  ScrollController _scrollController = ScrollController();
  List<ScrapItem> _bookScraps = [];
  List<String> _selectedIds = [];

  bool _isVisible = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Bind to book scraps and inject into the view
    _bookScraps = context.select((BooksModel m) => m.currentBookScraps);
    return ScrapPilePickerView(state: this, bookScraps: _bookScraps);
  }

  @override
  bool get enableKeyListener => _isVisible;

  void clearSelection() {
    setState(() => _selectedIds.clear());
    _notifySelectionChangeHandler();
  }

  @override
  void handleKeyDown(RawKeyDownEvent value) {
    if (KeyboardUtils.isCommandOrControlDown && value.logicalKey == LogicalKeyboardKey.keyA) {
      _handleSelectAllPressed();
    }
  }

  void _handlePickImagesPressed([bool enableCamera = true]) async {
    List<String> paths = await PickImagesCommand().run(allowMultiple: true, enableCamera: enableCamera);
    UploadImageScrapsCommand().run(widget.bookId, paths);
  }

  void _handleBgTapped() => clearSelection();

  void _handleScrapPressed(int index) {
    // Mobile mode does not allow deletion, or insertion of images. So no need to select them.
    if (widget.mobileMode) return;
    bool touchMode = context.read<AppModel>().enableTouchMode;
    String id = _bookScraps[index].documentId;
    // Use a utility method to handle the click, and return us a new set of ids
    _selectedIds = KeyboardUtils.handleMultiSelectListClick(
      id,
      _selectedIds,
      _bookScraps.map((e) => e.documentId).toList(),
      touchMode: touchMode,
      allowSpanSelect: true,
    );
    setState(() {});
    _notifySelectionChangeHandler();
  }

  /// Toggle between select-all or select-none
  void _handleSelectAllPressed() {
    // Check whether we're selecting, or de-selecting all
    bool doSelectAll = _selectedIds.length != _bookScraps.length;
    _selectedIds.clear();
    if (doSelectAll) {
      _bookScraps.forEach((s) => _selectedIds.add(s.documentId));
    }
    setState(() {});
    _notifySelectionChangeHandler();
  }

  // Converts selected scraps to a list of ids, and notifies any listeners.
  void _notifySelectionChangeHandler() {
    List<ScrapItem> selectedScraps = [];
    _bookScraps.forEach((s) {
      if (_selectedIds.contains(s.documentId)) selectedScraps.add(s);
    });
    widget.onSelectionChanged?.call(selectedScraps);
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    _isVisible = info.visibleFraction > 0;
  }
}
