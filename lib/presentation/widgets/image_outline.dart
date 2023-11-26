import 'package:flutter/material.dart';

import '/utilities/images_url.dart';

class ImageOutliner extends StatelessWidget {
  final String imageName;
  const ImageOutliner({super.key, required this.imageName});

  @override
  Widget build(BuildContext context) {
    double maxSize = 40;
    double minSize = 35;
    return Container(
      width: 150,
      height: 150,
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
              semanticLabel: imageName,
              image: AssetImage(
                towerImage(imageName),
              ),
            ),
          ),
          Image(
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
