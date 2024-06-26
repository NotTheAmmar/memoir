import 'package:flutter/material.dart';
import 'package:memoir/extensions.dart';

/// AlertDialog to confirm a decision
///
/// Pops `true` on confirm otherwise `false`
class ConfirmDialog extends StatelessWidget {
  /// Title aka action to confirm
  final String title;

  const ConfirmDialog({super.key, required this.title});

  /// Closes the dialog with a `No` answer
  ///
  /// Return `false` to caller
  void _decline(BuildContext context) => context.navigator.pop(false);

  /// Closes the dialog with a `Yes` answer
  ///
  /// Return `true` to caller
  void _accept(BuildContext context) => context.navigator.pop(true);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: const Text("Are You Sure?"),
      actions: [
        TextButton(
          onPressed: () => _decline(context),
          child: Text(
            "No",
            style: context.textTheme.bodyLarge?.copyWith(
              color: Colors.greenAccent,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _accept(context),
          child: Text(
            "Yes",
            style: context.textTheme.bodyLarge?.copyWith(
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}
