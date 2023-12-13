import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/utilities/global_state.dart';

class SearchBarWidget extends StatefulWidget {
  final String queryText;

  const SearchBarWidget({super.key, required this.queryText});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.queryText);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 5, 25, 15),
      child: Consumer<GlobalState>(
        builder: (context, globalState, child) {
          return TextField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: globalState.currentQuery.isEmpty ? 'Search...' : null,
            ),
            onChanged: (String text) {
              globalState.updateCurrentQuery(text);
            },
          );
        },
      ),
    );
  }
}
