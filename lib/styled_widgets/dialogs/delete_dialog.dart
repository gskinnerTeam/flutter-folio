import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:universal_platform/universal_platform.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key? key, required this.title, required this.desc1, this.desc2}) : super(key: key);
  final String title;
  final String desc1;
  final String? desc2;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    // Windows dialog buttons run a different direction then others
    TextDirection btnDirection = UniversalPlatform.isWindows ? TextDirection.rtl : TextDirection.ltr;
    return BaseStyledDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                UiText(text: title, style: TextStyles.body3.copyWith(color: theme.accent1)),
                VSpace.sm,
                UiText(text: desc1, style: TextStyles.body2),
                if (StringUtils.isNotEmpty(desc2)) ...[
                  VSpace.sm,
                  UiText(text: desc2, style: TextStyles.body3),
                ]
              ],
            ),
          ),
          Divider(color: theme.greyWeak),
          VSpace.sm,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              Row(
                textDirection: btnDirection,
                children: [
                  SecondaryBtn(label: "CANCEL", isCompact: true, onPressed: () => Navigator.of(context).pop(false)),
                  HSpace.sm,
                  PrimaryBtn(label: "DELETE", isCompact: true, onPressed: () => Navigator.of(context).pop(true)),
                ],
              ),
              HSpace.lg,
            ],
          ),
        ],
      ),
    );
  }
}
