import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// Simple wrapper around CachedNetworkImage that provides any boilerplate we need for images in the app
class HostedImage extends StatelessWidget {
  const HostedImage(this.url, {Key? key, this.fit = BoxFit.cover}) : super(key: key);
  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    String secureUrl = url;
    if (url.contains("http://")) {
      secureUrl = secureUrl.replaceAll("http://", "https://");
    }
    return CachedNetworkImage(imageUrl: secureUrl, fit: fit);
  }
}
