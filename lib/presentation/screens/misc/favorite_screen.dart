import 'package:btd6wiki/presentation/widgets/misc/orderable_grid.dart';
import 'package:btd6wiki/utilities/favorite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    FavoriteState favoriteState =
        Provider.of<FavoriteState>(context, listen: false);
    print(favoriteState.favoriteBox.keys.toList());
    List<String> categories =
        List<String>.from(favoriteState.favoriteBox.keys.toList());
    final generatedChildren = List.generate(
      categories.length,
      (index) => OrderableGrid(
        gridKey: GlobalKey(),
        favoriteItems: favoriteState.getListOfType(categories[index]),
        typeName: categories[index],
      ),
    );
    print(categories);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<FavoriteState>(
        builder: (context, favoriteState, child) {
          return ListView(
            shrinkWrap: true,
            children: generatedChildren,
          );
        },
      ),
    );
  }
}
