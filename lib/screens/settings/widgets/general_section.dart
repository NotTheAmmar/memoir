import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/classes/local_authenticator.dart';
import 'package:memoir/extensions.dart';

/// General Settings
class GeneralSettingsSection extends StatefulWidget {
  const GeneralSettingsSection({super.key});

  @override
  State<GeneralSettingsSection> createState() => _GeneralSettingsSectionState();
}

class _GeneralSettingsSectionState extends State<GeneralSettingsSection> {
  /// To Control Authenticate on Launch Tile Expansion
  final ExpansionTileController _expansionCtrl = ExpansionTileController();

  /// Updates ThemeMode when value changes for [DropdownButton]
  void _updateThemeMode(ThemeMode? value) {
    if (value == null) return;

    UserPreferences.instance.themeMode = value;
  }

  /// Updates Authentication preference through [Switch] and expands or collapses the tile based on new value
  void _updateAuthenticateOnLaunch(bool value) {
    setState(() => UserPreferences.instance.authenticateOnLaunch = value);

    if (_expansionCtrl.isExpanded) {
      _expansionCtrl.collapse();
    } else {
      _expansionCtrl.expand();
    }
  }

  /// Updates Authentication preference through [ExpansionTile]
  void _onExpansion(bool value) {
    setState(() => UserPreferences.instance.authenticateOnLaunch = value);
  }

  /// Updates fingerprint only authentication preference
  void _updateFingerprintOnlyAuthentication(bool value) {
    setState(() => UserPreferences.instance.fingerprintOnly = value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "General",
          style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const Gap(10),
        ListTile(
          title: const Text("Theme"),
          trailing: DropdownButton<ThemeMode>(
            enableFeedback: true,
            style: context.textTheme.bodySmall,
            value: UserPreferences.instance.themeMode,
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text("System"),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text("Light"),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text("Dark"),
              ),
            ],
            onChanged: _updateThemeMode,
          ),
        ),
        const Gap(10),
        ExpansionTile(
          controller: _expansionCtrl,
          enableFeedback: true,
          enabled: LocalAuthenticator.instance.canAuthenticate,
          initiallyExpanded: UserPreferences.instance.authenticateOnLaunch,
          onExpansionChanged: _onExpansion,
          title: const Text("Authenticate on Launch"),
          trailing: Switch(
            value: UserPreferences.instance.authenticateOnLaunch,
            // for disabling the switch when user can't authenticate
            onChanged: LocalAuthenticator.instance.canAuthenticate
                ? _updateAuthenticateOnLaunch
                : null,
          ),
          children: [
            SwitchListTile(
              value: UserPreferences.instance.fingerprintOnly,
              onChanged: _updateFingerprintOnlyAuthentication,
              title: const Text("Only Fingerprint Authentication"),
            )
          ],
        ),
      ],
    );
  }
}
