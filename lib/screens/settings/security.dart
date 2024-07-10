import 'package:flutter/material.dart';
import 'package:memoir/classes/local_authenticator.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';

/// Security Settings
class SecuritySettings extends StatefulWidget {
  const SecuritySettings({super.key});

  @override
  State<SecuritySettings> createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<SecuritySettings> {
  /// To Control App Lock Tile Expansion
  final ExpansionTileController _expansionCtrl = ExpansionTileController();

  /// Updates App Lock preference through [Switch] and expands or collapses the tile based on new value
  ///
  /// It authenticates first when enabling app lock
  void _updateAuthenticateOnLaunch(bool value) async {
    if (value) {
      bool result = await LocalAuthenticator.instance.authenticate();

      if (!result) return;
    }

    setState(() => UserPreferences.instance.appLock = value);

    if (_expansionCtrl.isExpanded) {
      _expansionCtrl.collapse();
    } else {
      _expansionCtrl.expand();
    }
  }

  /// Updates fingerprint only authentication preference
  void _updateFingerprintOnlyAuthentication(bool value) {
    setState(() => UserPreferences.instance.fingerprintOnly = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Security")),
      body: Column(
        children: [
          ExpansionTile(
            controller: _expansionCtrl,
            enableFeedback: true,
            enabled: false,
            initiallyExpanded: UserPreferences.instance.appLock,
            title: Text("App Lock", style: context.textTheme.bodyLarge),
            subtitle: Text(
              "Locks the App with device biometrics",
              style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            trailing: Switch(
              value: UserPreferences.instance.appLock,
              // disables the switch when user can't authenticate
              onChanged: LocalAuthenticator.instance.canAuthenticate
                  ? _updateAuthenticateOnLaunch
                  : null,
            ),
            children: [
              SwitchListTile(
                value: UserPreferences.instance.fingerprintOnly,
                // disables the switch when user does not have fingerprint
                onChanged: LocalAuthenticator.instance.hasFingerprint
                    ? _updateFingerprintOnlyAuthentication
                    : null,
                title: const Text("Fingerprint Only"),
                subtitle: const Text("Only use Fingerprint to unlock the App"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
