import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatefulWidget {
  const ImageWidget({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return  CachedNetworkImage(
        imageUrl: widget.url.toString(),
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: Colors.grey,),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
  }
}
