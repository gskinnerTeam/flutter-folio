import 'package:context_menus/context_menus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/_utils/device_info.dart';
import 'package:flutter_folio/_utils/keyboard_utils.dart';
import 'package:flutter_folio/_utils/notifications/close_notification.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
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
    Key? key,
    required this.bookId,
    this.contextMenuButtons,
    this.onSelectionChanged,
    this.onDeletePressed,
    this.mobileMode = false,
  }) : super(key: key);

  final String bookId;
  final List<ContextMenuButtonConfig> Function(ScrapItem item)? contextMenuButtons;
  final void Function(List<ScrapItem> items)? onSelectionChanged;
  final VoidCallback? onDeletePressed;
  final bool mobileMode;

  @override
  ScrapPilePickerState createState() => ScrapPilePickerState();
}

class ScrapPilePickerState extends State<ScrapPilePicker> with RawKeyboardListenerMixin {
  final ScrollController _scrollController = ScrollController();
  List<ScrapItem>? _bookScraps = [];
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
    if (KeyboardUtils.isMultiSelectModifierDown && value.logicalKey == LogicalKeyboardKey.keyA) {
      _handleSelectAllPressed();
    }
  }

  void _handlePickImagesPressed([bool enableCamera = true]) async {
    List<PickedImage> images = await PickImagesCommand().run(allowMultiple: true, enableCamera: enableCamera);
    UploadImageScrapsCommand().run(widget.bookId, images);
  }

  void _handleBgTapped() => clearSelection();

  void _handleScrapPressed(int index) {
    final scraps = _bookScraps;
    if (scraps == null) return;
    // Mobile mode does not allow deletion, or insertion of images. So no need to select them.
    if (widget.mobileMode) return;
    // Touch mode will handle multi-select differently
    bool touchMode = context.read<AppModel>().enableTouchMode;
    String id = scraps[index].documentId;
    // Use a utility method to handle the click, and return us a new set of ids
    _selectedIds = KeyboardUtils.handleMultiSelectListClick(
      clicked: id,
      selected: _selectedIds,
      all: scraps.map((e) => e.documentId).toList(),
      touchMode: touchMode,
      allowSpanSelect: true,
    );
    setState(() {});
    _notifySelectionChangeHandler();
  }

  /// Toggle between select-all or select-none
  void _handleSelectAllPressed() {
    if (_bookScraps == null) return;
    // Check whether we're selecting, or de-selecting all
    bool doSelectAll = _selectedIds.length != _bookScraps!.length;
    _selectedIds.clear();
    final bookScraps = _bookScraps;
    if (doSelectAll && bookScraps != null) {
      for (final s in bookScraps) {
        _selectedIds.add(s.documentId);
      }
    }
    setState(() {});
    _notifySelectionChangeHandler();
  }

  // Converts selected scraps to a list of ids, and notifies any listeners.
  void _notifySelectionChangeHandler() {
    List<ScrapItem> selectedScraps = [];
    final bookScraps = _bookScraps;
    if (bookScraps != null) {
      for (final s in bookScraps) {
        if (_selectedIds.contains(s.documentId)) selectedScraps.add(s);
      }
    }
    widget.onSelectionChanged?.call(selectedScraps);
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    _isVisible = info.visibleFraction > 0;
  }
}
