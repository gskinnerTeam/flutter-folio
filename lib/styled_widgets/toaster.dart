import 'package:flutter/material.dart';
import '../core_packages.dart';
import '../styles.dart';

class Toaster {
  static void showToast(BuildContext context, String content) {
    AppTheme theme = context.read<AppTheme>();
    TextStyle textStyle = TextStyles.body2.copyWith(color: theme.inverseTextColor);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1700),
        content: Container(
          padding: EdgeInsets.all(Insets.sm),
          child: Text(content, style: textStyle),
        ),
      ),
    );
  }
}
