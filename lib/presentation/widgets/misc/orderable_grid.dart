import 'package:btd6wiki/analytics/analytics.dart';
import 'package:btd6wiki/analytics/analytics_constants.dart';
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
    required this.analyticsHelper,
  });

  final GlobalKey gridKey;
  final String typeName;
  final List<dynamic> favoriteItems;
  final AnalyticsHelper analyticsHelper;

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
          onTap: () {
            navigateToPage(
              context,
              favItem,
              widget.analyticsHelper,
              kFavoritesClass,
              card,
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Image(
                      image: AssetImage(
                          assetImagePath(widget.typeName, favItem.image)),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                        child: Text(
                      favItem.name,
                      textAlign: TextAlign.center,
                    )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(widget.typeName),
          ReorderableBuilder(
            scrollController: _scrollController,
            onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
              for (final orderUpdateEntity in orderUpdateEntities) {
                final favItem =
                    widget.favoriteItems.removeAt(orderUpdateEntity.oldIndex);
                widget.favoriteItems
                    .insert(orderUpdateEntity.newIndex, favItem);
              }
              Provider.of<FavoriteState>(context, listen: false)
                  .updateIndexes(widget.typeName, widget.favoriteItems);
            },
            builder: (children) {
              return GridView(
                key: widget.gridKey,
                controller: _scrollController,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 10,
                  crossAxisCount: 3,
                  childAspectRatio: 0.70,
                ),
                children: children,
              );
            },
            children: generatedChildren,
          ),
        ],
      ),
    );
  }
}
