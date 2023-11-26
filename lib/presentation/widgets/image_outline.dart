import 'package:flutter/material.dart';

class ImageOutliner extends StatelessWidget {
  final String imageName;
  final String imagePath;
  const ImageOutliner(
      {super.key, required this.imageName, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    double maxWidth = 65;
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
