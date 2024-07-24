import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/assets.dart';
import 'package:memoir/classes/local_authenticator.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/screens/settings/widgets/expansion_list_tile.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Security Settings
class SecuritySettings extends StatefulWidget {
  const SecuritySettings({super.key});

  @override
  State<SecuritySettings> createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<SecuritySettings> {
  /// To Control App Lock Tile Expansion
  final ExpansionTileController _ctrl = ExpansionTileController();

  /// Updates App Lock preference through [Switch] and expands or collapses the tile based on new value
  ///
  /// It authenticates first before enabling app lock
  void _toggleAppLock(bool value) async {
    if (value) {
      bool result = await LocalAuthenticator.authenticate();

      if (!result) return;
    }

    setState(() => UserPreferences.appLock = value);

    if (_ctrl.isExpanded) {
      _ctrl.collapse();
    } else {
      _ctrl.expand();
    }
  }

  /// Updates fingerprint only authentication preference
  void _toggleFingerprintOnly(bool value) {
    setState(() => UserPreferences.fingerprintOnly = value);
  }

  /// Copies Public Key to CLipboard
  void _copyPublicKey() {
    final Future<void> result = Clipboard.setData(
      ClipboardData(text: UserPreferences.publicKey),
    );

    result.then((_) {
      context.messenger.showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        showCloseIcon: true,
        content: Text("Copied to Clipboard"),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Security")),
      body: Column(
        children: [
          ExpansionTile(
            controller: _ctrl,
            enableFeedback: true,
            enabled: false,
            initiallyExpanded: UserPreferences.appLock,
            title: Text("App Lock", style: context.textTheme.bodyLarge),
            subtitle: Text(
              "Locks the App with device biometrics",
              style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            trailing: Switch(
              value: UserPreferences.appLock,
              // disables the switch when user can't authenticate
              onChanged:
                  LocalAuthenticator.canAuthenticate ? _toggleAppLock : null,
            ),
            children: [
              SwitchListTile(
                value: UserPreferences.fingerprintOnly,
                // disables the switch when user does not have fingerprint
                onChanged: LocalAuthenticator.hasFingerprint
                    ? _toggleFingerprintOnly
                    : null,
                title: const Text("Fingerprint Only"),
                subtitle: const Text("Only use Fingerprint to unlock the App"),
              )
            ],
          ),
          ExpansionListTile(
            title: "Public Key",
            subtitle:
                "Any exported passwords encrypted using your key, can be imported only be you",
            children: [
              Center(
                child: QrImageView(
                  data: UserPreferences.publicKey,
                  backgroundColor: context.colorScheme.onSurface,
                  dataModuleStyle: QrDataModuleStyle(
                    color: context.colorScheme.surface,
                    dataModuleShape: QrDataModuleShape.square,
                  ),
                  gapless: false,
                  size: context.mediaQuery.size.width * 0.8,
                  embeddedImage: const AssetImage(Assets.logo),
                ),
              ),
              const Gap(10),
              Center(
                child: FilledButton.icon(
                  onPressed: _copyPublicKey,
                  label: const Text("Copy to Clipboard"),
                  icon: const FaIcon(FontAwesomeIcons.solidCopy),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
