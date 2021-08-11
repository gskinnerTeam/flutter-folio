import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:context_menus/context_menus.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_widgets/app_image.dart';
import 'package:flutter_folio/commands/books/update_placed_scrap_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/styled_widgets/emoji.dart';
import 'package:flutter_folio/views/editor_page/placed_scrap_keyboard_listener.dart';

import '../../_utils/timed/debouncer.dart';

class PlacedScrapRenderer extends StatelessWidget {
  const PlacedScrapRenderer(
    this.item, {
    Key? key,
    required this.isSelected,
    required this.onEditStarted,
    required this.onEditEnded,
  }) : super(key: key);
  final PlacedScrapItem item;
  final bool isSelected;
  final VoidCallback onEditStarted;
  final VoidCallback onEditEnded;

  @override
  Widget build(BuildContext context) {
    Widget? scrapBox;
    // Figure out what type of renderer to use for this srap
    if (item.isPhoto) scrapBox = _PhotoBox(item);
    if (item.isEmoji) scrapBox = _EmojiBox(item);
    if (item.isText) {
      scrapBox = _TextBox(
        item,
        isSelected: isSelected,
        onEditStarted: onEditStarted,
        onEditEnded: onEditEnded,
      );
    }
    // Couldn't find a renderer, fail gracefully but make sure we hide the invalid content
    if (scrapBox == null) {
      debugPrint("[PlacedScrapRenderer] Warning: Unknown scrap type found: ${item.contentType}");
      return const SizedBox(width: 0, height: 0);
    }

    return PlacedScrapKeyboardListener(
      item: item,
      enableKeyListener: isSelected,
      child: ContextMenuRegion(
        contextMenu: ScrapContextMenu(scrap: item),
        child: Container(
          color: Colors.transparent,
          child: scrapBox,
        ),
      ),
    );
  }
}

class _EmojiBox extends StatelessWidget {
  const _EmojiBox(this.item, {Key? key}) : super(key: key);
  final PlacedScrapItem item;

  @override
  Widget build(BuildContext context) {
    // If emoji is length of 1, this is legacy data, have a beer!
    if (StringUtils.isEmpty(item.data) || item.data.length <= 2) {
      return const Emoji(Emojis.beers);
    }
    return Emoji(EnumToString.fromString(Emojis.values, item.data));
  }
}

class _PhotoBox extends StatelessWidget {
  const _PhotoBox(this.item, {Key? key}) : super(key: key);
  final PlacedScrapItem item;

  @override
  Widget build(BuildContext context) => HostedImage(item.data, fit: BoxFit.cover);
}

class _TextBox extends StatefulWidget {
  const _TextBox(this.item, {Key? key, this.isSelected = false, this.onEditStarted, this.onEditEnded})
      : super(key: key);
  final PlacedScrapItem item;
  final bool isSelected;
  final VoidCallback? onEditStarted;
  final VoidCallback? onEditEnded;

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<_TextBox> {
  Debouncer textChangedDebounce = Debouncer(const Duration(milliseconds: 150));
  String? _txtValue;

  @override
  void initState() {
    super.initState();
    _txtValue = widget.item.data;
  }

  @override
  Widget build(BuildContext context) {
    // Write the text to
    void _handleTextChanged(String value) {
      // Update local data immediately, but debounce the firebase call
      PlacedScrapItem newItem = widget.item.copyWith(data: value);
      UpdatePageScrapCommand().run(newItem, localOnly: true);
      // Debounce db update
      textChangedDebounce.run(() => UpdatePageScrapCommand().run(newItem));
      setState(() => _txtValue = value);
    }

    String promptText = "Type something...";
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: widget.item.boxStyle?.bgColor ?? Colors.transparent,
      child: LayoutBuilder(builder: (_, constraints) {
        return AutoSizeText(
          StringUtils.defaultOnEmpty(_txtValue, promptText),
          minFontSize: 10,
          maxFontSize: 999,
          textBuilder: (size, style, numLines) {
            style = style.copyWith(color: widget.item.boxStyle?.fgColor ?? Colors.black);
            TextAlign textAlign = widget.item.boxStyle?.align ?? TextAlign.left;
            return widget.isSelected
                ? InlineTextEditor(
                    widget.item.data,
                    autoFocus: false,
                    alignVertical: TextAlignVertical.center,
                    align: textAlign,
                    width: constraints.maxWidth,
                    promptText: promptText,
                    maxLines: 99,
                    enableContextMenu: false,
                    onFocusOut: _handleTextChanged,
                    // SB: Due to a bug in Flutter where we were missing focusOut events, we're saving on every keystroke for this editor.// TODO: Try and get reproduction steps for this...
                    onChanged: _handleTextChanged,
                    style: style.copyWith(fontSize: size, fontFamily: boxFontToFamily(widget.item.boxStyle?.font)),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(StringUtils.defaultOnEmpty(widget.item.data, promptText),
                          style:
                              style.copyWith(fontSize: size, fontFamily: boxFontToFamily(widget.item.boxStyle?.font)),
                          maxLines: 99,
                          textAlign: textAlign),
                    ),
                  );
          },
          style: const TextStyle(fontSize: 999, letterSpacing: 0, height: 1.25),
        );
      }),
    );
  }
}
