import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Custom implementation of [ExpansionTile]
///
/// Created to have different functionality for tile tap event
class ExpansionListTile extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget? leading;
  final String title;
  final String subtitle;
  final List<Widget> children;

  const ExpansionListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.onTap,
    this.leading,
  });

  @override
  State<ExpansionListTile> createState() => _ExpansionListTileState();
}

class _ExpansionListTileState extends State<ExpansionListTile>
    with SingleTickerProviderStateMixin {
  /// Whether the tile is expanded or not
  bool isExpanded = false;

  /// Animation Controller for expanding children of the tile
  late AnimationController _ctrl;

  /// Animation value for the expanding animation for children
  ///
  /// Uses [_ctrl] as parent
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();

    super.dispose();
  }

  /// Expands and Collapses the tile
  void _onExpansionChanged() {
    setState(() => isExpanded = !isExpanded);

    if (isExpanded) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          enableFeedback: true,
          onTap: widget.onTap,
          leading: widget.leading,
          title: Text(widget.title),
          subtitle: Text(widget.subtitle),
          trailing: IconButton(
            onPressed: _onExpansionChanged,
            icon: FaIcon(
              isExpanded
                  ? FontAwesomeIcons.angleUp
                  : FontAwesomeIcons.angleDown,
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          axisAlignment: 1.0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.children,
            ),
          ),
        ),
      ],
    );
  }
}
