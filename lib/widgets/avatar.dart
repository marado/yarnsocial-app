import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    required this.imageUrl,
    this.radius = 20,
  }) : super(key: key);

  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return CircleAvatar(radius: radius);
    }

    // Treat image as FileImage if imageURL does not contain a scheme
    if (!Uri.parse(imageUrl!).hasScheme) {
      return CircleAvatar(
        backgroundImage: FileImage(File(imageUrl!)),
        radius: radius,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      httpHeaders: {HttpHeaders.acceptHeader: "image/png"},
      imageBuilder: (context, imageProvider) {
        return CircleAvatar(backgroundImage: imageProvider, radius: radius);
      },
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

class AvatarWithBorder extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color? borderColor;
  final double borderThickness;

  const AvatarWithBorder({
    Key? key,
    required this.imageUrl,
    this.borderColor,
    this.borderThickness = 1,
    this.radius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor:
          this.borderColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Avatar(
        imageUrl: imageUrl,
        radius: radius - this.borderThickness,
      ),
    );
  }
}
