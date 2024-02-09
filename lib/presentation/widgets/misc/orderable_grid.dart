import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/hive/favorite_model.dart';
import '/utilities/favorite_state.dart';
import '/utilities/utils.dart';

class OrderableGrid extends StatefulWidget {
  const OrderableGrid({
    super.key,
    required this.gridKey,
    required this.typeName,
    required this.favoriteItems,
  });

  final GlobalKey gridKey;
  final String typeName;
  final List<dynamic> favoriteItems;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Image(
                    image: AssetImage(
                        assetImagePath(widget.typeName, favItem.image)),
                  ),
                ),
                Text(favItem.name),
              ],
            ),
          ),
        );
      },
    );

    return Column(
      children: [
        Text(widget.typeName),
        ReorderableBuilder(
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
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 8,
              ),
            );
          },
        ),
      ],
    );
  }
}
