import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/input_utils.dart';
import 'package:flutter_folio/_utils/notifications/close_notification.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/commands/books/create_placed_scraps_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/app_model.dart';

import 'content_picker_emoji_panel.dart';
import 'content_picker_scraps_panel.dart';

class ContentPickerMenuPanel extends StatefulWidget {
  const ContentPickerMenuPanel({Key key, @required this.pageId, @required this.bookId}) : super(key: key);
  final String bookId;
  final String pageId;

  @override
  _ContentPickerMenuPanelState createState() => _ContentPickerMenuPanelState();
}

class _ContentPickerMenuPanelState extends State<ContentPickerMenuPanel> {
  ContentType _currentMenuType = null;
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

  void _handleMenuPressed(ContentType selectedContentTab) {
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
    CreatePlacedScrapCommand().run(pageId: widget.pageId, scraps: [
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
  const AlignAndPad(this.alignment, this.padding, {Key key, this.child}) : super(key: key);
  final Alignment alignment;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(alignment: alignment, child: Padding(padding: padding, child: child));
}

class _ContentPickerTabMenu extends StatelessWidget {
  const _ContentPickerTabMenu(
      {Key key, @required this.contentType, @required this.onPressed, this.isPageSelected = false})
      : super(key: key);
  final ContentType contentType;
  final bool isPageSelected;
  final void Function(ContentType type) onPressed;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Insets.med - 1, vertical: Insets.lg * 1.1),
          child: Column(children: [
            _TabMenuBtn(
              icon: AppIcons.scraps,
              isSelected: contentType == ContentType.Photo,
              onPressed: () => onPressed(ContentType.Photo),
            ),
            VSpace.med,
            _TabMenuBtn(
              icon: AppIcons.text,
              isSelected: contentType == ContentType.Text,
              onPressed: isPageSelected ? () => onPressed(ContentType.Text) : null,
            ),
            VSpace.med,
            _TabMenuBtn(
              icon: AppIcons.emoji,
              isSelected: contentType == ContentType.Emoji,
              onPressed: isPageSelected ? () => onPressed(ContentType.Emoji) : null,
            ),
          ]),
        ),
      ),
    );
  }
}

class _TabMenuBtn extends StatelessWidget {
  const _TabMenuBtn({Key key, this.icon, this.onPressed, this.isSelected = false}) : super(key: key);
  final AppIcons icon;
  final VoidCallback onPressed;
  final bool isSelected;

  static double kSize = 40;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    bool touchMode = context.select((AppModel m) => m.enableTouchMode);
    // Add some extra size for touch users
    double extraSize = touchMode ? 8 : 0;
    return SimpleBtn(
      onPressed: onPressed,
      cornerRadius: 99,
      child: AnimatedContainer(
        duration: Times.fast,
        curve: Curves.easeOut,
        width: kSize + extraSize,
        height: kSize + extraSize,
        decoration: BoxDecoration(
          color: isSelected ? theme.accent1.withOpacity(.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(99),
        ),
        child: TweenAnimationBuilder<double>(
          duration: Times.fast,
          curve: Curves.easeOut,
          tween: Tween(begin: 22, end: 22 + extraSize),
          builder: (_, value, __) => AppIcon(
            icon,
            color: isSelected ? theme.accent1 : theme.greyStrong,
            size: value,
          ),
        ),
        //child: Icon(icon, color: isSelected ? theme.accent1 : theme.greyStrong),
      ),
    );
  }
}
