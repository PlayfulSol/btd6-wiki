import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/analytics/analytics.dart';
import '/presentation/widgets/misc/orderable_grid.dart';
import '/utilities/favorite_state.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key, required this.analyticsHelper});

  final AnalyticsHelper analyticsHelper;

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    FavoriteState favoriteState =
        Provider.of<FavoriteState>(context, listen: false);
    List<String> categories =
        List<String>.from(favoriteState.favoriteBox.keys.toList());
    final generatedChildren = List.generate(
      categories.length,
      (index) => OrderableGrid(
        gridKey: GlobalKey(),
        favoriteItems: favoriteState.getListOfType(categories[index]),
        typeName: categories[index],
        analyticsHelper: widget.analyticsHelper,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Favorites'),
        title: Text(MediaQuery.of(context).size.width.toString()),

        actions: [
          Consumer<FavoriteState>(
            builder: (context, favoriteState, child) {
              return IconButton(
                onPressed: () {
                  favoriteState.toggleMultiSelect();
                },
                icon: Icon(
                    !favoriteState.multiSelect ? Icons.delete : Icons.close),
              );
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: generatedChildren,
      ),
    );
  }
}
