import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_folio/_widgets/alignments.dart';
import 'package:flutter_folio/_widgets/decorated_container.dart';
import 'package:flutter_folio/_widgets/sized_and_translated.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/app_model.dart';

import 'animated_menu_panel.dart';
import 'scrap_popup_panel_alignment.dart';
import 'scrap_popup_panel_button_strip.dart';
import 'scrap_popup_panel_color.dart';
import 'scrap_popup_panel_fonts.dart';

/// A floating menu that contains multiple sub-panels. Some of these panels have open and closed states, others just contain some controls.
// TODO: Currently this widget used fixed sizing because it was quicker to build.
//    We should try to remove this. The solution could involve a stack + a floating AnimatedPanel that can open-close

class ScrapPopupEditor extends StatefulWidget {
  const ScrapPopupEditor({
    Key? key,
    required this.scrap,
    required this.onStyleChanged,
    required this.onRotChanged,
  }) : super(key: key);
  final PlacedScrapItem scrap;
  final void Function(BoxStyle boxStyle) onStyleChanged;
  final void Function(double rot) onRotChanged;

  static const double kWidth = 300;

  @override
  _ScrapPopupEditorState createState() => _ScrapPopupEditorState();
}

class _ScrapPopupEditorState extends State<ScrapPopupEditor> {
  int _btnIndex = -1;
  final BoxStyle _defaultStyle = BoxStyle();
  BoxStyle get scrapStyle => widget.scrap.boxStyle ?? _defaultStyle;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    bool isTouchMode = context.select((AppModel m) => m.enableTouchMode);
    timeDilation = 1;
    double row1Height = isTouchMode ? 70 : 60;
    double row2Height = isTouchMode ? 50 : 40;
    double row3Height = isTouchMode ? 40 : 25;
    bool isImage = widget.scrap.contentType == ContentType.Emoji || widget.scrap.contentType == ContentType.Photo;
    if (isImage) {
      row1Height = 0;
      row2Height = 0;
    }
    double allRowsHeight = row1Height + row2Height + row3Height;
    double width = ScrapPopupEditor.kWidth;

    if (allRowsHeight == 0) return Container();

    /// Use this extraPadding as a hacky way to get even spacing around the btns.
    /// This is clunkier than it should be because we're manually positioning.
    double extraPadding = 4;
    return TopLeft(
      child: SizedBox(
        width: width + extraPadding * 2,
        height: double.infinity,
        child: Stack(fit: StackFit.expand, children: [
          /// Background Layer
          AnimatedOpacity(
              duration: Times.fast,
              opacity: _btnIndex >= 0 ? 0 : 1,
              child: GestureDetector(
                onTap: () {}, // Swallow any taps on the background so it won't cause the menu to close
                child: TopLeft(
                    child: DecoratedContainer(
                  height: allRowsHeight + extraPadding * 2,
                  color: theme.bg1,
                  borderRadius: Corners.med,
                )),
              )),

          /// Content,
          Transform.translate(
            // slightly shifted for aesthetics
            offset: Offset(extraPadding, extraPadding),

            /// A stack of AnimatedContainers that change their padding to open and close
            /// Manually assigned a starting offset and size
            child: Stack(
              children: [
                // Make sure the panel that is currently animating, is sorted on top of the others, by re-ordering the tree
                ..._sortChildrenWithSelectedOnTop([
                  /// TOP ROW
                  if (row1Height > 0) ...[
                    /// Text-Align
                    animatedPanel(
                      const Offset(0, 0), // Pos(row: 0, item: 0)
                      Size(width / 2, row1Height),
                      enableBgTap: false,
                      index: 0,
                      openHeight: 100,
                      childBuilder: (bool isOpen) => _MenuItem(
                          child: ScrapPopupPanelAlignment(
                            onAlignmentPressed: _handleAlignChanged,
                            value: scrapStyle.align,
                          ),
                          isOpen: isOpen),
                    ),

                    /// Font Family
                    animatedPanel(
                      Offset(width / 2, 0),
                      Size(width / 2, row1Height),
                      index: 1,
                      openHeight: 140,
                      childBuilder: (bool isOpen) => _MenuItem(
                        child: ScrapPopupPanelFonts(
                          isOpen: isOpen,
                          value: scrapStyle.font,
                          onFamilyChanged: _handleFamilyChanged,
                        ),
                        isOpen: isOpen,
                      ),
                    ),
                  ],

                  /// MIDDLE ROW
                  if (row2Height > 0) ...[
                    /// FgColor
                    animatedPanel(
                      Offset(0, row1Height),
                      Size(width / 2, row2Height),
                      index: 2,
                      openHeight: 166,
                      childBuilder: (bool isOpen) => _MenuItem(
                          child: ScrapPopupPanelColor(
                            swatchColors: fgColors,
                            isOpen: isOpen,
                            onColorPicked: _handleFgColorChanged,
                            value: scrapStyle.fgColor,
                            label: "Color",
                          ),
                          isOpen: isOpen),
                    ),

                    /// BgColor
                    animatedPanel(
                      Offset(width / 2, row1Height),
                      Size(width / 2, row2Height),
                      index: 3,
                      openHeight: 166,
                      childBuilder: (bool isOpen) => _MenuItem(
                          child: ScrapPopupPanelColor(
                            swatchColors: bgColors,
                            isOpen: isOpen,
                            onColorPicked: _handleBgColorChanged,
                            value: scrapStyle.bgColor,
                            label: "Background",
                          ),
                          isOpen: isOpen),
                    ),
                  ],
                  if (row3Height > 0) ...[
                    /// Button-Strip
                    AnimatedOpacity(
                      opacity: _btnIndex != -1 ? 0 : 1,
                      duration: Times.fast,
                      child: SizedAndTranslated(
                          size: Size(width, row3Height),
                          offset: Offset(width / 2, row1Height + row2Height + row3Height / 2),
                          child: ScrapPopupPanelButtonStrip(
                            scrap: widget.scrap,
                          )),
                    )
                  ]
                ]),
              ],
            ),
          )
        ]),
      ),
    );
  }

  AnimatedMenuPanel animatedPanel(Offset o, Size s,
      {required double openHeight,
      required int index,
      required Widget Function(bool isOpen) childBuilder,
      bool enableBgTap = true}) {
    return AnimatedMenuPanel(o, s,
        openHeight: openHeight,
        key: ValueKey(index),
        isOpen: _btnIndex == index,
        isVisible: _btnIndex == index || _btnIndex == -1,
        onPressed: enableBgTap ? () => _handlePanelPressed(index) : () {},
        childBuilder: childBuilder);
  }

  void _handlePanelPressed(int i) {
    setState(() {
      bool wasSelected = _btnIndex == i;
      _btnIndex = wasSelected ? -1 : i; //Deselect if it was selected
    });
  }

  List<Widget> _sortChildrenWithSelectedOnTop(List<Widget> list) {
    if (_btnIndex == -1) return list;
    final panel = list.removeAt(_btnIndex);
    return list..add(panel);
  }

  void _handleAlignChanged(TextAlign value) => widget.onStyleChanged(scrapStyle.copyWith(align: value));

  void _handleBgColorChanged(Color value) {
    _btnIndex = -1;
    widget.onStyleChanged(scrapStyle.copyWith(bgColor: value));
  }

  void _handleFgColorChanged(Color value) {
    _btnIndex = -1;
    widget.onStyleChanged(scrapStyle.copyWith(fgColor: value));
  }

  void _handleFamilyChanged(BoxFonts value) {
    _btnIndex = -1;
    widget.onStyleChanged(scrapStyle.copyWith(font: value));
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({Key? key, this.isOpen = false, required this.child}) : super(key: key);
  final bool isOpen;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Padding(
      padding: const EdgeInsets.all(4),
      child: AnimatedContainer(
          duration: Times.fast,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: Corners.smBorder,
            color: theme.surface1,
          ),
          child: AnimatedSwitcher(
              duration: Times.fast,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 2),
                child: child,
              ))),
    );
  }
}

class PanelHeader extends StatelessWidget {
  const PanelHeader({Key? key, required this.label, this.showBackArrow = true}) : super(key: key);
  final String label;
  final bool showBackArrow;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return SizedBox(
      height: 20,
      child: Stack(children: [
        if (showBackArrow) const MaterialIcon(Icons.chevron_left),
        Center(child: Text(label, style: TextStyles.caption.copyWith(color: theme.grey))),
      ]),
    );
  }
}

class PopPanelIconBtn extends StatelessWidget {
  const PopPanelIconBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleBtn(
      onPressed: null,
      child: Container(
        padding: EdgeInsets.all(Insets.sm),
        child: const MaterialIcon(Icons.rotate_right_outlined),
      ),
    );
  }
}
