import 'package:context_menus/context_menus.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/analytics/analytics.dart';
import '/presentation/widgets/misc/orderable_grid.dart';
import '/utilities/favorite_state.dart';
import '/utilities/utils.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key, required this.analyticsHelper});
  final AnalyticsHelper analyticsHelper;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final constraintsValues = getPreset(MediaQuery.of(context).size);
    return ContextMenuOverlay(
      cardBuilder: (context, children) => Card(
        elevation: 10,
        child: Column(children: children),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
        ),
        body: Consumer<FavoriteState>(
          builder: (context, favoriteState, child) {
            List<String> categories =
                List<String>.from(favoriteState.favoriteBox.keys.toList());

            return Scrollbar(
              thumbVisibility: true,
              thickness: 10,
              scrollbarOrientation: ScrollbarOrientation.top,
              radius: const Radius.circular(20),
              controller: pageController,
              child: PageView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                controller: pageController,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: OrderableGrid(
                      items: favoriteState.getListOfType(categories[index]),
                      categoryType: categories[index],
                      globalKeyGridView: GlobalKey(),
                      constraints: constraintsValues,
                      analyticsHelper: analyticsHelper,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
