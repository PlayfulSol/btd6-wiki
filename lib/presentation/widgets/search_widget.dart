import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/utilities/global_state.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 5, 25, 15),
      child: TextField(
        controller: searchController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search...',
        ),
        onChanged: (String text) {
          globalState.updateCurrentQuery(text);
        },
      ),
    );
  }
}
