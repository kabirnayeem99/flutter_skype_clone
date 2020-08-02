import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachTheImage extends StatelessWidget {
  final String url;

  CachTheImage({@required this.url});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ClipRect(
        // prevents its child from painting outside its bounds,
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
