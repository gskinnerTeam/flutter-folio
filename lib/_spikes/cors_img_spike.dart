import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CorsImageSpike extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (_, __) => Column(
        children: [
          Flexible(
            child: CachedNetworkImage(
              imageUrl:
                  "https://res.cloudinary.com/gskinner/image/upload/v1614066383/photo-1561909364-1690892d91a2_-_Copy_2_w7py5h.jpg",
            ),
          ),
          Flexible(
            child: Image.network(
                "https://res.cloudinary.com/gskinner/image/upload/v1614066383/photo-1561909364-1690892d91a2_-_Copy_2_w7py5h.jpg"),
          )
        ],
      ),
    );
  }
}
