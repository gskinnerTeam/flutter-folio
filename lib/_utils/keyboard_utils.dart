import 'package:flutter/services.dart';
import 'package:flutter_folio/_utils/device_info.dart';

class KeyboardUtils {
  static bool get isSpanSelectModifierDown => isKeyDown({LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight});
  static bool get isControlDown => isKeyDown({LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.controlRight});
  static bool get isMetaDown => isKeyDown({LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.metaRight});
  static bool get isWindowsDown => isMetaDown;
  static bool get isCommandDown => isMetaDown;

  static bool isKeyDown(Set<LogicalKeyboardKey> keys) {
    return keys.intersection(RawKeyboard.instance.keysPressed).isNotEmpty;
  }

  static bool get isMultiSelectModifierDown {
    bool isDown = false;
    // Command on MacOS, and Control on Windows/Linux are generally analogous
    if (DeviceOS.isMacOS) {
      isDown = KeyboardUtils.isCommandDown;
    } else {
      isDown = KeyboardUtils.isControlDown;
    }
    return isDown;
  }

  // Determine what to do when an image is pressed. This varies depending on input mode and platform.
  // Keyboard users will support ctrl/cmd modifiers, while Touch devices are optimized for single taps
  static List<String> handleMultiSelectListClick(
      {required String clicked,
      required List<String> selected,
      required List<String> all,
      required bool touchMode,
      bool allowSpanSelect = true}) {
    selected = List.from(selected); // Clone list so we don't modify the original accidentally
    bool wasSelected = selected.contains(clicked);
    // Span select
    if (allowSpanSelect && isSpanSelectModifierDown && all.isNotEmpty) {
      selected = _selectSpan(clicked: clicked, selected: selected, all: all);
    }
    // Single item select (
    else if (touchMode || KeyboardUtils.isMultiSelectModifierDown) {
      if (wasSelected) {
        selected.remove(clicked);
      } else {
        selected.add(clicked);
      }
    }
    // Keyboard mode, without the modifier key, is a simple single-select tap
    else {
      // On Mac, tapping a selected thing in Finder does nothing
      if ((DeviceOS.isMacOS) && wasSelected) {
        return selected;
      }
      // On Linux/Win clicking a thing will select it and de-select any others
      selected.clear();
      selected.add(clicked);
    }
    return selected;
  }

  // Note: This doesn't act exactly like the OS but it's pretty close.
  static List<String> _selectSpan(
      {required String clicked, required List<String> selected, required List<String> all}) {
    // First click, just select the clicked item
    if (selected.isEmpty) return [clicked];
    // Span select, some items are already selected
    String mostRecent = selected.last;
    // Span select. Assume the last item in the list was the most recent select. Get all items from there to the selected value
    int mostRecentIndex = all.indexWhere((i) => i == mostRecent);
    int clickedIndex = all.indexWhere((i) => i == clicked);
    int startIndex = clickedIndex > mostRecentIndex ? mostRecentIndex : clickedIndex;
    int endIndex = clickedIndex > mostRecentIndex ? clickedIndex : mostRecentIndex;
    for (var i = startIndex; i <= endIndex; i++) {
      selected.add(all[i]);
    }
    return selected;
  }
}
