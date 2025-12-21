import 'package:flutter/material.dart';

class ImageOutliner extends StatelessWidget {
  final String imageName;
  final String imagePath;
  final double? width;
  final double? height;

  const ImageOutliner({
    super.key,
    required this.imageName,
    required this.imagePath,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    double maxWidth = width ?? 65;
    double maxHeight = height ?? 90;
    final bool isLargeImage = width != null && width! > 100;
    
    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: [
          if (!isLargeImage)
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
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
            width: isLargeImage ? maxWidth * 0.95 : null,
            height: isLargeImage ? maxHeight * 0.95 : maxHeight * 0.606,
            semanticLabel: imageName,
            image: AssetImage(imagePath),
          ),
        ],
      ),
    );
  }
}
