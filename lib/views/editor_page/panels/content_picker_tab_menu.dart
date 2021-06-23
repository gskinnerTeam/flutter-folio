import 'dart:ui';

import 'package:anchored_popups/anchored_popup_region.dart';
import 'package:anchored_popups/anchored_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/input_utils.dart';
import 'package:flutter_folio/_utils/notifications/close_notification.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_widgets/decorated_container.dart';
import 'package:flutter_folio/commands/books/create_placed_scraps_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';

import 'content_picker_emoji_panel.dart';
import 'content_picker_scraps_panel.dart';

class ContentPickerTabMenu extends StatefulWidget {
  const ContentPickerTabMenu({Key? key, required this.pageId, required this.bookId}) : super(key: key);
  final String bookId;
  final String? pageId;

  @override
  _ContentPickerTabMenuState createState() => _ContentPickerTabMenuState();
}

class _ContentPickerTabMenuState extends State<ContentPickerTabMenu> {
  ContentType? _currentMenuType;
  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (CloseNotification n) {
        _handleBgPressed();
        return true;
      },
      child: Stack(
        children: [
          // Underlay, blocks gestures when a picker is open, and closes current picker on tap
          if (_currentMenuType != null) ...[
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _handleBgPressed,
                onPanStart: (_) => _handleBgPressed(),
                child: Container(color: Colors.transparent)),
          ],

          /// A row that has the Tab Menu on the right side, and the ContentPicker to the left
          AlignAndPad(Alignment.centerRight, EdgeInsets.all(Insets.offset),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /// Current content picker (if any)
                  Stack(children: [
                    ContentPickerScrapsPanel(
                      bookId: widget.bookId,
                      pageId: widget.pageId,
                      isVisible: _currentMenuType == ContentType.Photo,
                    ),
                    //if (_currentMenuType == ContentType.Text) ContentPickerTextsPanel(),
                    ContentPickerEmojiPanel(
                      bookId: widget.bookId,
                      pageId: widget.pageId,
                      isVisible: _currentMenuType == ContentType.Emoji,
                    ),
                  ]),
                  HSpace.lg,

                  /// Tab Menu
                  _ContentPickerTabMenu(
                    contentType: _currentMenuType,
                    onPressed: _handleMenuPressed,
                    isPageSelected: StringUtils.isNotEmpty(widget.pageId),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  void _handleMenuPressed(ContentType? selectedContentTab) {
    if (selectedContentTab == _currentMenuType) {
      selectedContentTab = null;
    }
    // Text btn has no associated picker, just de-select the current btn and add a new Text element.
    if (selectedContentTab == ContentType.Text) {
      _addTextScrap();
      selectedContentTab = null;
    }
    setState(() => _currentMenuType = selectedContentTab);
    // If someone was editing text and clicks this menu, unfocus the keyboard
    InputUtils.unFocus();
  }

  // De-select current btn
  void _handleBgPressed() => _handleMenuPressed(_currentMenuType);

  void _addTextScrap() {
    if (widget.pageId == null) return;
    CreatePlacedScrapCommand().run(pageId: widget.pageId!, scraps: [
      ScrapItem(
        bookId: widget.bookId,
        contentType: ContentType.Text,
        data: "Type something",
        aspect: 3,
      )
    ]);
  }
}

class AlignAndPad extends StatelessWidget {
  const AlignAndPad(this.alignment, this.padding, {Key? key, required this.child}) : super(key: key);
  final Alignment alignment;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(alignment: alignment, child: Padding(padding: padding, child: child));
}

class _ContentPickerTabMenu extends StatefulWidget {
  const _ContentPickerTabMenu(
      {Key? key, required this.contentType, required this.onPressed, this.isPageSelected = false})
      : super(key: key);
  final ContentType? contentType;
  final bool isPageSelected;
  final void Function(ContentType type) onPressed;

  @override
  __ContentPickerTabMenuState createState() => __ContentPickerTabMenuState();
}

class __ContentPickerTabMenuState extends State<_ContentPickerTabMenu> {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Insets.med - 1, vertical: Insets.lg * 1.1),
          child: Column(children: [
            _TabMenuBtn(
              icon: AppIcons.scraps,
              tooltip: "Add photos",
              isSelected: widget.contentType == ContentType.Photo,
              onPressed: () => _handlePressed(ContentType.Photo),
            ),
            VSpace.med,
            _TabMenuBtn(
              icon: AppIcons.text,
              tooltip: "Create new textfield",
              isSelected: widget.contentType == ContentType.Text,
              onPressed: widget.isPageSelected ? () => _handlePressed(ContentType.Text) : null,
            ),
            VSpace.med,
            _TabMenuBtn(
              icon: AppIcons.emoji,
              tooltip: "Add emoji",
              isSelected: widget.contentType == ContentType.Emoji,
              onPressed: widget.isPageSelected ? () => _handlePressed(ContentType.Emoji) : null,
            ),
          ]),
        ),
      ),
    );
  }

  void _handlePressed(ContentType type) {
    AnchoredPopups.of(context)?.hide();
    widget.onPressed.call(type);
  }
}

class _TabMenuBtn extends StatelessWidget {
  const _TabMenuBtn({Key? key, required this.icon, this.onPressed, this.isSelected = false, this.tooltip})
      : super(key: key);
  final AppIcons icon;
  final VoidCallback? onPressed;
  final bool isSelected;
  final String? tooltip;

  static double kSize = 40;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return AnchoredPopUpRegion(
      popChild: StyledTooltip(tooltip ?? "", arrowAlignment: Alignment.centerRight),
      anchor: Alignment.centerLeft,
      popAnchor: Alignment.centerRight,
      delay: Duration.zero,
      child: SimpleBtn(
        onPressed: onPressed,
        cornerRadius: 99,
        ignoreDensity: false,
        child: DecoratedContainer(
          width: kSize,
          height: kSize,
          borderColor: isSelected ? theme.accent1.withOpacity(.15) : Colors.transparent,
          borderRadius: 99,
          child: AppIcon(icon, color: isSelected ? theme.accent1 : theme.greyStrong, size: 22),
        ),
      ),
    );
  }
}
