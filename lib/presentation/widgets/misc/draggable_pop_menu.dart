import 'package:context_menus/context_menus.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/hive/favorite_model.dart';
import '/utilities/favorite_state.dart';

class DraggablePopMenu extends StatelessWidget {
  const DraggablePopMenu({
    required this.items,
    required this.selectedItem,
    super.key,
  });
  final FavoriteModel selectedItem;
  final List<FavoriteModel> items;

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteState>(
      builder: (context, favoriteState, child) {
        return GenericContextMenu(
          buttonConfigs: [
            ContextMenuButtonConfig(
              "Remove",
              icon: const Icon(Icons.delete),
              onPressed: () {
                favoriteState.toggleFavoriteFunc(
                    context, favoriteState, selectedItem);
                items.removeWhere((item) => item.id == selectedItem.id);
              },
            ),
          ],
        );
      },
    );
  }
}
