import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/routes.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/sheets/widgets/sheet.dart';

/// Gives user two ways to give a Public Key via
/// 1. QR Code
/// 2. Clipboard
/// 
/// Pops the received key from the chosen method
class PublicKeyScannerSheet extends StatelessWidget {
  const PublicKeyScannerSheet({super.key});

  /// Pushes [QRScannerPage] onto screen and Pops the received key 
  void _scanFromQRCode(BuildContext context) {
    context.navigator.pushNamed(Routes.qrScanner).then((value) {
      context.navigator.pop(value);
    });
  }

  /// Pops the data from clipboard
  Future<void> _pasteFromClipboard(BuildContext context) async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    if (!context.mounted) return;
    context.messenger.showSnackBar(const SnackBar(
      duration: Duration(seconds: 1),
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
            Text("Public Key", style: context.textTheme.titleSmall),
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
              onTap: () => _scanFromQRCode(context),
              child: const Column(
                children: [
                  Gap(10),
                  FaIcon(FontAwesomeIcons.qrcode),
                  Gap(10),
                  Text("Scan from\nQRcode", textAlign: TextAlign.center)
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
