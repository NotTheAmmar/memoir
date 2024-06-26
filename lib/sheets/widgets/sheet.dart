import 'package:flutter/material.dart';
import 'package:memoir/extensions.dart';

/// Wrapper for using Widgets in ModalBottomSheet
///
/// Provides Padding appropriate for using keyboard and Column layout with [MainAxisSize.min]
class Sheet extends StatelessWidget {
  /// Children Widgets in ModalBottomSheet
  final List<Widget> children;

  const Sheet({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // viewInsets padding for Keyboard
      padding: context.mediaQuery.viewInsets + const EdgeInsets.all(10),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
