import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/container.dart' as my;
import 'package:memoir/screens/vault/widgets/containers_list.dart';

/// Encapsules SearchBar and ContainerList
///
/// Handles search functionality for [ContainerList]
class ContainersBuilder extends StatefulWidget {
  /// Full List of Containers
  final List<my.Container> containers;

  /// Callback to refresh the containers list
  final VoidCallback refreshContainers;

  const ContainersBuilder({
    super.key,
    required this.containers,
    required this.refreshContainers,
  });

  @override
  State<ContainersBuilder> createState() => _ContainersBuilderState();
}

class _ContainersBuilderState extends State<ContainersBuilder> {
  /// [TextEditingController] for [SearchBar]
  ///
  /// Created primarily to clear the search query
  final TextEditingController _searchCtrl = TextEditingController();

  /// To remove focus for [SearchBar] when tapped outside
  final FocusNode _searchFocusNode = FocusNode();

  /// List of Containers that match with the search query
  ///
  /// Initialized in [initState]
  late List<my.Container> filteredContainers;

  @override
  void initState() {
    super.initState();

    filteredContainers = widget.containers;
    
    _searchCtrl.addListener(_searchQueryListener);
  }

  @override
  void didUpdateWidget(covariant ContainersBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    filteredContainers = widget.containers;
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_searchQueryListener);

    _searchCtrl.dispose();
    _searchFocusNode.dispose();

    super.dispose();
  }

  /// Filters Containers based on search query
  ///
  /// If the query is empty, then all the containers are added to list
  void _searchQueryListener() {
    setState(() {
      if (_searchCtrl.text.isEmpty) {
        filteredContainers = widget.containers;
      } else {
        filteredContainers = widget.containers.where((container) {
          final String containerName = container.name.toLowerCase();

          return containerName.contains(_searchCtrl.text.toLowerCase());
        }).toList();
      }
    });
  }

  /// Clears the search query and adds all containers to list
  void _clearSearch() {
    _searchCtrl.text = "";
    setState(() {
      filteredContainers = widget.containers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: SearchBar(
            focusNode: _searchFocusNode,
            controller: _searchCtrl,
            hintText: "Search Container",
            leading: const FaIcon(FontAwesomeIcons.magnifyingGlass),
            // Removes focus when user clicks outside the search bar
            onTapOutside: (_) => _searchFocusNode.unfocus(),
            trailing: [
              if (_searchCtrl.text.isNotEmpty)
                IconButton(
                  onPressed: _clearSearch,
                  icon: const FaIcon(FontAwesomeIcons.xmark),
                )
            ],
          ),
        ),
        const Gap(10),
        Expanded(
          child: ContainerList(
            containers: filteredContainers,
            refreshList: widget.refreshContainers,
          ),
        ),
      ],
    );
  }
}
