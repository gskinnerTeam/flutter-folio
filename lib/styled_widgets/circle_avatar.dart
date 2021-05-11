import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/app_image.dart';
import 'package:flutter_folio/_widgets/decorated_container.dart';
import 'package:flutter_folio/core_packages.dart';

class StyledCircleImage extends StatelessWidget {
  const StyledCircleImage({Key? key, required this.url, this.padding}) : super(key: key);

  final EdgeInsets? padding;
  final String url;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of(context);
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedContainer(
          clipChild: true,
          borderColor: theme.greyWeak,
          borderWidth: 2,
          borderRadius: 99,
          child: HostedImage(url, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
