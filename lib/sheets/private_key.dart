import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/sheets/widgets/sheet.dart';

/// Prompts the user for private key when restoring containers
/// 
/// Give two choices
/// 1. Use Private Key from device
/// 2. Paste Private Key from clipboard
class PrivateKeySheet extends StatelessWidget {
  const PrivateKeySheet({super.key});

  /// Extracts Private Key from Clipboard and pops it to parent
  Future<void> _pasteFromClipboard(BuildContext context) async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    if (!context.mounted) return;
    context.messenger.showSnackBar(const SnackBar(
      duration: Duration(milliseconds: 300),
      showCloseIcon: true,
      content: Text("Pasted"),
    ));

    context.navigator.pop(data?.text);
  }

  @override
  Widget build(BuildContext context) {
    return Sheet(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Text("Private Key", style: context.textTheme.titleSmall),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: context.navigator.pop,
                icon: const FaIcon(FontAwesomeIcons.xmark),
              ),
            )
          ],
        ),
        const Gap(20),
        GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 100,
            crossAxisSpacing: 10,
          ),
          shrinkWrap: true,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10),
              // Pops null to indicate that device private key is to be used
              onTap: context.navigator.pop,
              child: const Column(
                children: [
                  Gap(10),
                  FaIcon(FontAwesomeIcons.database),
                  Gap(10),
                  Text("Use from\ncurrent Device", textAlign: TextAlign.center)
                ],
              ),
            ),
            FutureBuilder(
              future: Clipboard.hasStrings(),
              initialData: false,
              builder: (context, snapshot) {
                final bool hasStrings = snapshot.data ?? false;

                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: hasStrings ? () => _pasteFromClipboard(context) : null,
                  child: Column(
                    children: [
                      const Gap(10),
                      FaIcon(
                        hasStrings
                            ? FontAwesomeIcons.solidPaste
                            : FontAwesomeIcons.paste,
                      ),
                      const Gap(10),
                      Text(
                        "Paste from\nClipboard",
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: hasStrings
                              ? context.colorScheme.onSurface
                              : Colors.grey,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
