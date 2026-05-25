import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// CarouselSlider + AnimatedSmoothIndicator in a Column.
/// Optional [label] is shown between the carousel and the indicator (e.g. "Normal / Elite" for bosses).
class CarouselWithIndicator extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final CarouselSliderController controller;
  final int activeIndex;
  final double height;
  final double viewportFraction;
  final Color activeDotColor;
  final Color dotColor;
  final void Function(int) onPageChanged;
  final Widget? label;

  const CarouselWithIndicator({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.controller,
    required this.activeIndex,
    required this.height,
    required this.viewportFraction,
    required this.activeDotColor,
    required this.dotColor,
    required this.onPageChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
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
          itemCount: itemCount,
          itemBuilder: (ctx, i, _) => itemBuilder(ctx, i),
        ),
        const SizedBox(height: 6),
        if (label != null) ...[
          label!,
          const SizedBox(height: 6),
        ],
        if (itemCount > 1)
          AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: itemCount,
            onDotClicked: (i) => controller.jumpToPage(i),
            effect: ScrollingDotsEffect(
              activeDotScale: 1.25,
              spacing: 10,
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: activeDotColor,
              dotColor: dotColor,
            ),
          ),
      ],
    );
  }
}
