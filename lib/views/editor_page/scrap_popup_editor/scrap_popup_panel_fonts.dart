import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/decorated_container.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';

import 'scrap_popup_editor.dart';

class ScrapPopupPanelFonts extends StatelessWidget {
  final bool isOpen;
  final BoxFonts value;
  final void Function(BoxFonts value) onFamilyChanged;
  const ScrapPopupPanelFonts(
      {Key? key, required this.isOpen, this.value = BoxFonts.AlfaSlabOne, required this.onFamilyChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Stack(
      fit: StackFit.expand,
      children: [
        /// Closed State
        if (!isOpen) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Font", style: TextStyles.caption.copyWith(color: theme.grey, height: 1)),
                ],
              ),
              Expanded(
                child: Center(
                  child: AutoSizeText(boxFontToDisplay(value),
                      minFontSize: 10,
                      maxFontSize: 28,
                      maxLines: 1,
                      style: TextStyles.body3.copyWith(
                        fontSize: 32,
                        fontFamily: boxFontToFamily(value),
                        height: 1,
                      )),
                ),
              )
            ],
          )
        ] else ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: SizedBox(
                width: 300 - Insets.sm * 2,
                child: Column(
                  children: [
                    const PanelHeader(label: "Font"),
                    VSpace(Insets.sm),
                    Row(
                      children: [
                        Expanded(child: _FontBtn(value, font: BoxFonts.Caveat, onPressed: onFamilyChanged)),
                        HSpace(Insets.sm),
                        Expanded(
                            flex: 2,
                            child: _FontBtn(value, font: BoxFonts.PathwayGothicOne, onPressed: onFamilyChanged)),
                        HSpace(Insets.sm),
                        Expanded(child: _FontBtn(value, font: BoxFonts.Amiri, onPressed: onFamilyChanged)),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    VSpace(Insets.sm),
                    Row(
                      children: [
                        Expanded(child: _FontBtn(value, font: BoxFonts.Lato, onPressed: onFamilyChanged)),
                        HSpace(Insets.sm),
                        Expanded(child: _FontBtn(value, font: BoxFonts.Mali, onPressed: onFamilyChanged)),
                        HSpace(Insets.sm),
                        Expanded(
                            flex: 2, child: _FontBtn(value, font: BoxFonts.AlfaSlabOne, onPressed: onFamilyChanged)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }
}

class _FontBtn extends StatelessWidget {
  const _FontBtn(this.currentValue, {Key? key, required this.font, required this.onPressed}) : super(key: key);
  final BoxFonts font;
  final void Function(BoxFonts) onPressed;
  final BoxFonts currentValue;
  bool get isSelected => currentValue == font;
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return SimpleBtn(
      onPressed: () => onPressed(font),
      child: DecoratedContainer(
          width: double.infinity,
          height: 40,
          alignment: Alignment.center,
          color: isSelected ? theme.accent1.withOpacity(.15) : Colors.transparent,
          borderColor: isSelected ? theme.accent1 : theme.grey,
          borderRadius: Corners.med,
          child: Text(
            boxFontToDisplay(font),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: boxFontToFamily(font),
              color: isSelected ? theme.accent1 : theme.mainTextColor,
            ),
          )),
    );
  }
}
