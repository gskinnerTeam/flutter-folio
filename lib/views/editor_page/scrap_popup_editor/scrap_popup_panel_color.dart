import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/decorated_container.dart';
import 'package:flutter_folio/core_packages.dart';

import 'scrap_popup_editor.dart';

class ScrapPopupPanelColor extends StatelessWidget {
  const ScrapPopupPanelColor({
    Key? key,
    required this.label,
    required this.value,
    required this.onColorPicked,
    required this.isOpen,
    required this.swatchColors,
  }) : super(key: key);
  final String label;
  final Color value;
  final void Function(Color value) onColorPicked;
  final bool isOpen;
  final List<Color> swatchColors;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Stack(
      children: [
        if (isOpen) ...[
          Column(
            children: [
              PanelHeader(label: label),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12, right: 12, bottom: 8),
                  child: GridView.count(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    children: List.generate(
                      21,
                      (index) => SimpleBtn(
                          onPressed: () => onColorPicked(swatchColors[index]),
                          child: Padding(
                            padding: EdgeInsets.all(Insets.xs),
                            child: _ColorSwatch(swatchColors[index],
                                size: double.infinity, isSelected: swatchColors[index] == value),
                          )),
                    ),
                  ),
                ),
              )
            ],
          )
        ] else ...[
          SizedBox(
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Text(label, style: TextStyles.caption.copyWith(color: theme.grey)),
                  const MaterialIcon(Icons.chevron_right, size: 16),
                  const Spacer(),
                  _ColorSwatch(value, isSelected: false)
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            ),
          )
        ]
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(this.color, {Key? key, this.size, required this.isSelected}) : super(key: key);
  final Color color;
  final double? size;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    double finalSize = size ?? 16;
    return Stack(
      children: [
        DecoratedContainer(
          width: finalSize,
          height: finalSize,
          color: color,
          borderColor: isSelected ? theme.focus : theme.greyMedium,
          borderWidth: isSelected ? 2 : 1,
        ),
        if (color == Colors.transparent) ...[
          Positioned.fill(
              child: Center(
            child: Transform.rotate(angle: pi / 4, child: Container(width: size, height: 2, color: theme.grey)),
          )),
        ]
      ],
    );
  }
}

final List<Color> fgColors = [
  0xFFFFFFFF,
  0xFFCCCCCC,
  0xFF999999,
  0xFF666666,
  0xFF333333,
  0xFF000000,
  0xFF353E89,
  0xFFFD0A1B,
  0xFFFD9826,
  0xFFFFE127,
  0xFF29FD2E,
  0xFF4C88E5,
  0xFF9824FB,
  0xFFFF4B8A,
  0xFFF4C0C0,
  0xFFDBB29A,
  0xFFD6A8D1,
  0xFFE0DFCC,
  0xFF9EB6BA,
  0xFF6D8879,
  0xFF908169,
].map((e) => Color(e)).toList();
final List<Color> bgColors = [
  0x00000000,
  0xFFFFFFFF,
  0xFFCCCCCC,
  0xFF999999,
  0xFF666666,
  0xFF333333,
  0xFF000000,
  0xFF6F2D2D,
  0xFFAA4E2C,
  0xFFA6A308,
  0xFF2AB57F,
  0xFF2564CA,
  0xFF54128C,
  0xFF9A2F55,
  0xFFEF6E6E,
  0xFFEDAE0C,
  0xFFA7F49F,
  0xFF6CDDDF,
  0xFFA6AFEA,
  0xFFDEA4D3,
  0xFFE26F2C,
].map((e) => Color(e)).toList();
