import 'package:flutter/material.dart';

import '/utilities/images_url.dart';

class ImageOutliner extends StatelessWidget {
  final String imageName;
  const ImageOutliner({super.key, required this.imageName});

  @override
  Widget build(BuildContext context) {
    double maxWidth = 90;
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
              // Theme.of(context)
              //     .colorScheme
              //     .onBackground
              Colors.black
                  .withOpacity(0.9), // Adjust opacity for contrast effect
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
            height: maxHeight * 0.6,
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
