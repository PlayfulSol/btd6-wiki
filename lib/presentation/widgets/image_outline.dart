import 'package:flutter/material.dart';

class ImageOutliner extends StatelessWidget {
  final String imageName;
  final String imagePath;
  final double? width;
  const ImageOutliner(
      {super.key,
      required this.imageName,
      required this.imagePath,
      this.width});

  @override
  Widget build(BuildContext context) {
    double maxWidth = width ?? 65;
    double maxHeight = 90;
    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.loose,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(1), // Adjust opacity for contrast effect
              BlendMode.srcIn,
            ),
            child: Image(
              fit: BoxFit.fitWidth,
              semanticLabel: imageName,
              image: AssetImage(imagePath),
            ),
          ),
          Image(
            fit: BoxFit.contain,
            height: maxHeight * 0.606,
            semanticLabel: imageName,
            image: AssetImage(imagePath),
          ),
        ],
      ),
    );
  }
}
