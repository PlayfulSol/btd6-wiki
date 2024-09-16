import 'package:context_menus/context_menus.dart';
import 'package:reorderables/reorderables.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/hive/favorite_model.dart';
import '/analytics/analytics.dart';
import '/presentation/widgets/misc/favorite_card.dart';
import '/utilities/favorite_state.dart';

import 'draggable_pop_menu.dart';

class OrderableGrid extends StatefulWidget {
  const OrderableGrid({
    super.key,
    required this.items,
    required this.categoryType,
    required this.globalKeyGridView,
    required this.constraints,
    required this.analyticsHelper,
  });
  final List<FavoriteModel> items;
  final AnalyticsHelper analyticsHelper;

  final String categoryType;
  final GlobalKey globalKeyGridView;
  final Map<String, dynamic> constraints;

  @override
  State<OrderableGrid> createState() => _OrderableGridState();
}

class _OrderableGridState extends State<OrderableGrid> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<Widget> orderedItems = List.generate(
      widget.items.length,
      (index) => SizedBox(
        width: 120,
        height: 185,
        child: FavoriteCard(
          favItem: widget.items[index],
          favoriteItems: widget.items,
          analyticsHelper: widget.analyticsHelper,
          typeName: widget.categoryType,
          constraintsValues: widget.constraints,
        ),
      ),
    );
    return Consumer<FavoriteState>(
      builder: (context, favoriteState, child) {
        if (orderedItems.isNotEmpty) {
          return ReorderableWrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            spacing: MediaQuery.of(context).size.width * 0.02,
            runSpacing: MediaQuery.of(context).size.width * 0.02,
            reorderAnimationDuration: const Duration(milliseconds: 0),
            scrollAnimationDuration: const Duration(milliseconds: 200),
            controller: scrollController,
            padding: const EdgeInsets.all(12),
            onNoReorder: (index) {
              context.contextMenuOverlay.show(
                DraggablePopMenu(
                  items: widget.items,
                  selectedItem: widget.items[index],
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              setState(() {
                final favItem = widget.items.removeAt(oldIndex);
                widget.items.insert(newIndex, favItem);
              });
              favoriteState.updateIndexes(widget.categoryType, widget.items);
            },
            children: orderedItems,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
