import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/presentation/widgets/common/app_image.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> images;
  final String Function(String) pathBuilder;
  final CarouselSliderController controller;
  final int activeIndex;
  final double height;
  final double viewportFraction;
  final Color accentColor;
  final void Function(int) onPageChanged;
  final bool showIndicator;

  const ImageCarousel({
    super.key,
    required this.images,
    required this.pathBuilder,
    required this.controller,
    required this.activeIndex,
    required this.height,
    required this.viewportFraction,
    required this.accentColor,
    required this.onPageChanged,
    this.showIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          carouselController: controller,
          options: CarouselOptions(
            viewportFraction: viewportFraction,
            height: height,
            enableInfiniteScroll: false,
            onPageChanged: (i, _) => onPageChanged(i),
          ),
          itemCount: images.length,
          itemBuilder: (ctx, i, _) => AppImage(path: pathBuilder(images[i])),
        ),
        if (showIndicator && images.length > 1) ...[
          const SizedBox(height: 8),
          AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: images.length,
            onDotClicked: (i) => controller.jumpToPage(i),
            effect: ScrollingDotsEffect(
              activeDotScale: 1.25,
              spacing: 10,
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: accentColor,
              dotColor: dotColor,
            ),
          ),
        ],
      ],
    );
  }
}
