import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key, this.size = 30}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Text(
          "Fetching data, please wait...",
          style: TextStyles.caption,
        )
        //child: SizedBox(width: size, height: size, child: CircularProgressIndicator()),
        );
  }
}
