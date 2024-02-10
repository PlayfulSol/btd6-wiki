import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/constants.dart';
import '/utilities/strings.dart';
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
    final constraintsValues = getPreset(
      MediaQuery.of(context).size,
    );
    return Consumer<FavoriteState>(
      builder: (context, favoriteState, child) {
        List<Widget> generatedChildren = generateGridChildren(
            widget.favoriteItems,
            widget.analyticsHelper,
            widget.typeName,
            constraintsValues);
        if (generatedChildren.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  capitalizeEveryWord(widget.typeName),
                  style: bigTitleStyle,
                ),
                ReorderableBuilder(
                  enableLongPress: false,
                  scrollController: _scrollController,
                  onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
                    for (final orderUpdateEntity in orderUpdateEntities) {
                      final favItem = widget.favoriteItems
                          .removeAt(orderUpdateEntity.oldIndex);
                      widget.favoriteItems
                          .insert(orderUpdateEntity.newIndex, favItem);
                    }
                    favoriteState.updateIndexes(
                        widget.typeName, widget.favoriteItems);
                  },
                  builder: (children) {
                    return GridView(
                      key: widget.gridKey,
                      controller: _scrollController,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraintsValues[favItemCrossCount],
                        childAspectRatio: constraintsValues[favItemAspectRatio],
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
        return Container();
      },
    );
  }
}
