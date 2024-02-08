import 'package:btd6wiki/hive/favorite_model.dart';
import 'package:btd6wiki/utilities/images_url.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/utilities/favorite_state.dart';

class OrderableGrid extends StatefulWidget {
  const OrderableGrid({
    super.key,
    required this.gridKey,
    required this.favoriteItems,
  });
  final GlobalKey gridKey;
  final List<FavoriteModel> favoriteItems;

  @override
  State<OrderableGrid> createState() => _OrderableGridState();
}

class _OrderableGridState extends State<OrderableGrid> {
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final generatedChildren = List.generate(
      widget.favoriteItems.length,
      (index) {
        FavoriteModel favItem = widget.favoriteItems.elementAt(index);
        return InkWell(
          key: Key(favItem.id),
          child: Card(
            color: Colors.lightBlue,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(image: AssetImage(towerImage(favItem.image))),
                Text(favItem.name),
              ],
            ),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(),
      body: Consumer<FavoriteState>(
        builder: (context, favoriteState, child) {
          List<String> categories =
              List<String>.from(favoriteState.favoriteBox.keys.toList());
          return ReorderableBuilder(
            children: generatedChildren,
            scrollController: _scrollController,
            onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
              for (final orderUpdateEntity in orderUpdateEntities) {
                final fruit =
                    widget.favoriteItems.removeAt(orderUpdateEntity.oldIndex);
                widget.favoriteItems.insert(orderUpdateEntity.newIndex, fruit);
              }
            },
            builder: (children) {
              return GridView(
                key: widget.gridKey,
                controller: _scrollController,
                shrinkWrap: true,
                children: children,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 8,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
