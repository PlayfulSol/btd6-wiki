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
  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();
  final _fruits = <String>["apple", "banana", "strawberry"];

  @override
  Widget build(BuildContext context) {
    final generatedChildren = List.generate(
      _fruits.length,
      (index) => Container(
        key: Key(_fruits.elementAt(index)),
        color: Colors.lightBlue,
        child: Text(
          _fruits.elementAt(index),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<FavoriteState>(
        builder: (context, favoriteState, child) {
          List<String> categories =
              List<String>.from(favoriteState.favoriteBox.keys.toList());
          return ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return categories[index].isNotEmpty
                  ? OrderableGrid(
                      gridKey: GlobalKey(),
                      favoriteItems:
                          favoriteState.getListOfType(categories[index]),
                    )
                  : Container();
            },
          );
        },
      ),
    );
  }
}
