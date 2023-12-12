import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/utilities/global_state.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      Provider.of<GlobalState>(context, listen: false)
          .updateCurrentQuery(searchController.text);
    });
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
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Search...',
        ),
      ),
    );
  }
}
