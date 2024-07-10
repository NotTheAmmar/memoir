import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/sheets/widgets/sheet.dart';

/// BottomSheet to confirm a decision
///
/// Pops `true` on confirm otherwise `false`
class ConfirmActionSheet extends StatelessWidget {
  /// Title aka action to confirm
  final String title;

  /// Subtitle, describes the result of the decision
  final String content;

  /// `No` button text
  final String declineText;

  /// `Yes` button text
  final String acceptText;

  const ConfirmActionSheet({
    super.key,
    required this.title,
    required this.content,
    required this.declineText,
    required this.acceptText,
  });

  @override
  Widget build(BuildContext context) {
    return Sheet(
      children: [
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              // Pops false to indicate No decision
              onPressed: () => context.navigator.pop(false),
              child: Text(declineText),
            ),
            TextButton(
              // Pops true to indicate No decision
              onPressed: () => context.navigator.pop(true),
              child: Text(acceptText),
            )
          ],
        ),
        const Gap(20),
        Text(
          title,
          style: context.textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
        const Gap(20),
        SizedBox(
          height: context.mediaQuery.size.height * 0.1,
          child: Text(
            content,
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
