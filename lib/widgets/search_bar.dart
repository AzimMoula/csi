import 'package:csi/admin/screens/registrations.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key, required this.values});
  final List<String> values;
  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildFloatingCustomSearchBar(widget.values),
    );
  }

  Widget buildFloatingCustomSearchBar(List<String> values) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    List<String> queryevents = values;
    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      clearQueryOnClose: true,
      onFocusChanged: (isFocused) {
        queryevents = values;
      },
      onSubmitted: (query) {
        List<String> matchQuery = [];
        for (var name in values) {
          if (name.toLowerCase().contains(query.toLowerCase())) {
            matchQuery.add(name);
          }
        }
        setState(() {
          queryevents = matchQuery;
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Theme.of(context).cardColor.withOpacity(0.75),
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: queryevents.map((doc) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Registrations(
                                  name: doc,
                                ))),
                    title: Center(child: Text(doc)),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    // return const Scaffold();
  }
}
