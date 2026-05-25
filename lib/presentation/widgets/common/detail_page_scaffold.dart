import 'package:flutter/material.dart';
import '/utilities/constants.dart';

/// Shared scaffold for all detail pages (tower, hero, bloon, boss, map).
///
/// Owns the [SliverAppBar] frame, the header background Stack (accent-tinted
/// box → [headerContent] → bottom fade), the optional favourite button, and
/// the content [SliverToBoxAdapter] with [fromLTRB(16, 8, 16, 24)] padding.
///
/// [headerOverlay] — widget rendered on top of the fade inside the header Stack.
///   Use for the hero page's dot indicator ([Positioned] at bottom: 12).
///
/// [belowHeader] — widget rendered in a [SliverToBoxAdapter] between the
///   [SliverAppBar] and the content column.  Use for the boss dot indicator.
///
/// [fadeHeight] — hero uses 80, all others use the default 60.
class DetailPageScaffold extends StatelessWidget {
  const DetailPageScaffold({
    super.key,
    required this.title,
    required this.accentColor,
    required this.headerContent,
    this.body = const [],
    this.sliverBody,
    this.isFavorite,
    this.onFavoriteToggle,
    this.headerOverlay,
    this.belowHeader,
    this.fadeHeight = 60.0,
  });

  final String title;
  final Color accentColor;
  final Widget headerContent;
  final Widget? headerOverlay;
  final Widget? belowHeader;
  final List<Widget> body;
  final List<Widget>? sliverBody;
  final bool? isFavorite;
  final VoidCallback? onFavoriteToggle;
  final double fadeHeight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgAlpha =
        Theme.of(context).brightness == Brightness.dark ? 0.28 : 0.15;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            title: Text(title, style: sliverTitleStyle),
            actions: [
              if (isFavorite != null && onFavoriteToggle != null)
                IconButton(
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    isFavorite! ? Icons.star : Icons.star_border_outlined,
                    color: isFavorite! ? GameColors.favourite : null,
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: accentColor.withValues(alpha: bgAlpha)),
                  headerContent,
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: fadeHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            accentColor.withValues(alpha: 0),
                            colorScheme.surface,
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (headerOverlay != null) headerOverlay!,
                ],
              ),
            ),
          ),
          if (belowHeader != null) SliverToBoxAdapter(child: belowHeader!),
          if (sliverBody != null) ...[
            ...sliverBody!,
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.viewPaddingOf(context).bottom,
              ),
            ),
          ] else
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  24 + MediaQuery.viewPaddingOf(context).bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: body,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
