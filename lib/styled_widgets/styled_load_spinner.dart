import 'package:flutter/material.dart';
import '../core_packages.dart';

class StyledLoadSpinner extends StatelessWidget {
  const StyledLoadSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          backgroundColor: theme.greyWeak,
          valueColor: AlwaysStoppedAnimation<Color>(theme.greyStrong),
        ));
  }
}
