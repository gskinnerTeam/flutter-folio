import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

class KeyboardUtils {
  static bool get isShiftDown => isKeyDown([LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight]);
  static bool get isControlDown => isKeyDown([LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.controlRight]);
  static bool get isMetaDown => isKeyDown([LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.metaRight]);
  static bool get isWindowsDown => isMetaDown;
  static bool get isCommandDown => isMetaDown;

  static bool isKeyDown(List<LogicalKeyboardKey> keys) {
    Set<LogicalKeyboardKey> pressed = RawKeyboard.instance.keysPressed;
    for (var i = keys.length; i-- > 0;) {
      if (pressed.contains(keys[i])) {
        return true;
      }
    }
    return false;
  }

  //TODO: Feature this snippet
  static bool get isCommandOrControlDown {
    bool isDown = false;
    // If shift is not down, look for Command on Mac, and Control on Windows/Linux
    if (UniversalPlatform.isMacOS) {
      isDown = KeyboardUtils.isCommandDown;
    } else {
      isDown = KeyboardUtils.isControlDown;
    }
    return isDown;
  }

  //TODO: Feature this snippet
  // Determine what to do when an image is pressed. This varies depending on input mode and platform.
  // Keyboard users will support ctrl/cmd modifiers, while Touch devices are optimized for single taps
  static List<String> handleMultiSelectListClick(String clicked, List<String> selected, List<String> all,
      {@required bool touchMode, bool allowSpanSelect = true}) {
    selected = List.from(selected); // Clone list so we don't modify the original accidentally
    bool wasSelected = selected.contains(clicked);
    // Touch mode, or Keyboard w/ Multiselect behavior: Tap something to add it, tap again to remove it. Tap bg to de-select all.

    if (allowSpanSelect && isShiftDown && all.isNotEmpty) {
      // Span select, some items are already selected
      if (selected.isNotEmpty) {
        // Span select. Assume the last item in the list was the most recent select. Get all items from there to the selected value
        // Note: This doesn't act exactly like the OS but that logic is non-trivial to implement precisely.
        String mostRecent = selected.last ?? all.first;
        int mostRecentIndex = all.indexWhere((i) => i == mostRecent);
        int clickedIndex = all.indexWhere((i) => i == clicked);
        int startIndex = clickedIndex > mostRecentIndex ? mostRecentIndex : clickedIndex;
        int endIndex = clickedIndex > mostRecentIndex ? clickedIndex : mostRecentIndex;
        for (var i = startIndex; i <= endIndex; i++) {
          selected.add(all[i]);
        }
      }
      // No items are selected, so just add the one that was pressed
      else {
        selected = [clicked];
      }
    } else if (touchMode || KeyboardUtils.isCommandOrControlDown) {
      if (wasSelected) {
        selected.remove(clicked);
      } else {
        selected.add(clicked);
      }
    }
    // Keyboard mode, without the modifier key, is a simple single-select tap
    else {
      // On Mac, tapping a selected thing in Finder does nothing
      if ((UniversalPlatform.isMacOS) && wasSelected) {
        return selected;
      }
      // On Linux/Win clicking a thing will select it and de-select any others
      selected.clear();
      selected.add(clicked);
    }
    return selected;
  }
}
