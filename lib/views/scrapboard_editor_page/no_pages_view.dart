import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/flexibles/seperated_flexibles.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/styled_widgets/styled_spacers.dart';

class NoPagesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text("Hi, here are some instructions for scrapfolio.", style: TextStyles.title1),
        VSpace.xl,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: SeparatedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            separatorBuilder: () => VSpace.med,
            children: [
              _FeatureRow(
                icon: "📱",
                label: "Use your phone to take photos and upload them to the app",
              ),
              _FeatureRow(
                icon: "💻",
                label: "Design your scrapbooks on larger screen devices like desktop, laptop  and tablet.",
              ),
              _FeatureRow(
                icon: "🔗",
                label: "Share them with family and friends  with a web link!",
              )
            ],
          ),
        )
      ]),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String label;
  final String icon;

  const _FeatureRow({Key key, this.label, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: TextStyles.title2),
        HSpace.lg,
        Flexible(child: Text(label, style: TextStyles.title2)),
      ],
    );
  }
}
