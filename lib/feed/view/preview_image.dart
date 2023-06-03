import 'package:cached_network_image/cached_network_image.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';

class PreviewImage extends StatefulWidget {
  final String imageUrl;
  const PreviewImage({required this.imageUrl, super.key});

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.black,
      appBar: AppBar(
        backgroundColor: Palette.black,
        leading: IconButton(
            onPressed: () {
              RouteGenerator.navigatorKey.currentState!.pop();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(value: downloadProgress.progress)),
        // placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
