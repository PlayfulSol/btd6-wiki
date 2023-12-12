import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/utilities/global_state.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    searchController.addListener(() {
      Provider.of<GlobalState>(context, listen: false)
          .updateCurrentQuery(searchController.text);
      // logEvent('search', 'searching for map ${_searchController.text}');
      // setState(() {
      //   query = _searchController.text;
      // });
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Search...',
        ),
      ),
    );
  }
}
