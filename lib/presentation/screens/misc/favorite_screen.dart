import 'package:btd6wiki/hive/favorite_model.dart';
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
      child: Consumer<FavoriteState>(
        builder: (context, favoriteState, child) {
          List<String> categories = favoriteState.getActiveCategories();
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (favoriteState.isMultiSelectMode) {
                    favoriteState.toggleMultiSelect(context);
                  }
                  Navigator.of(context).pop();
                },
              ),
              title: const Text('Favorites'),
              actions: [
                IconButton(
                  onPressed: () {
                    favoriteState.toggleMultiSelect(context);
                  },
                  icon: Icon(
                    !favoriteState.isMultiSelectMode
                        ? Icons.delete
                        : Icons.close,
                  ),
                ),
              ],
            ),
            body: Scrollbar(
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
                  List<FavoriteModel> items =
                      favoriteState.getListOfType(categories[index]);
                  if (items.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: OrderableGrid(
                        items: items,
                        categoryType: categories[index],
                        globalKeyGridView: GlobalKey(),
                        constraints: constraintsValues,
                        analyticsHelper: analyticsHelper,
                      ),
                    );
                  } else {
                    return null;
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
