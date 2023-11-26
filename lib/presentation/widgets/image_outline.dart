import 'package:flutter/material.dart';

import '/utilities/images_url.dart';

class ImageOutliner extends StatelessWidget {
  final String imageName;
  const ImageOutliner({super.key, required this.imageName});

  @override
  Widget build(BuildContext context) {
    double maxWidth = 40;
    double maxHeight = 40;
    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(1), // Adjust opacity for contrast effect
              BlendMode.srcIn,
            ),
            child: Image(
              fit: BoxFit.fitWidth,
              semanticLabel: imageName,
              image: AssetImage(
                towerImage(imageName),
              ),
            ),
          ),
          Image(
            fit: BoxFit.contain,
            width: maxWidth * 0.8,
            height: maxHeight * 0.8,
            semanticLabel: imageName,
            image: AssetImage(
              towerImage(imageName),
            ),
          ),
        ],
      ),
    );
  }
}
