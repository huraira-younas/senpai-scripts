import 'package:cached_network_image/cached_network_image.dart';
import 'package:glmpse/common_widget/custom_appbar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'dart:io' show File;

class ImagePreview extends StatelessWidget {
  final String url;
  const ImagePreview({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final isFile = !url.contains("http");
    return Stack(
      children: <Widget>[
        PhotoView(
          minScale: 0.1,
          maxScale: 1.0,
          imageProvider: isFile
              ? FileImage(File(url))
              : CachedNetworkImageProvider(url) as ImageProvider,
          loadingBuilder: (context, event) => Center(
            child: CircularProgressIndicator(
              value: (event?.cumulativeBytesLoaded ?? 0).toDouble(),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: BackIcon(color: Colors.white),
        ),
      ],
    );
  }
}
