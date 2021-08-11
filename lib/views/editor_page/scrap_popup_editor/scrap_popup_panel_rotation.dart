import 'package:flutter/cupertino.dart';
import 'package:flutter_folio/core_packages.dart';

import 'scrap_popup_editor.dart';

class ScrapPopupPanelRotation extends StatelessWidget {
  final bool isOpen;
  final double degrees;
  final void Function(double value) onDegreesChanged;
  const ScrapPopupPanelRotation({Key? key, required this.isOpen, required this.degrees, required this.onDegreesChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        /// Closed State
        if (!isOpen) ...[
          const PopPanelIconBtn(),
        ] else ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: SizedBox(
                width: 300 - Insets.sm * 2,
                child: Column(
                  children: [
                    const PanelHeader(label: "Rotation", showBackArrow: false),
                    SizedBox(
                        width: 280,
                        child: CupertinoSlider(min: -180, max: 180, value: degrees, onChanged: onDegreesChanged)),
                    VSpace(Insets.sm),
                    Text("${degrees.round()}", style: TextStyles.body3),
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
