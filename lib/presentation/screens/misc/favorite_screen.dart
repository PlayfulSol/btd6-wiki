import 'package:btd6wiki/presentation/widgets/misc/orderable_grid.dart';
import 'package:btd6wiki/utilities/favorite_state.dart';
import 'package:flutter/material.dart';
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
