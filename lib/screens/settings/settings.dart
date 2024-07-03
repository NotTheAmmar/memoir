import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/screens/settings/widgets/about_section.dart';
import 'package:memoir/screens/settings/widgets/accessibility_section.dart';
import 'package:memoir/screens/settings/widgets/general_section.dart';
import 'package:memoir/screens/settings/widgets/password_section.dart';

/// Settings Page
///
/// Provides lots of options for user to change according to their needs
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  /// Whether the user imported container or not
  bool _didImport = false;

  /// Pops the [Settings] page and returns to homepage
  ///
  /// Causes it to refresh if user imported containers
  void _returnToHomePage() => context.navigator.pop(_didImport);

  /// Gets Called when user imports containers successfully
  void _userImported() => _didImport = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: "Back to Vault",
          onPressed: _returnToHomePage,
          icon: const FaIcon(FontAwesomeIcons.arrowLeftLong),
        ),
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              GeneralSettingsSection(),
              const Gap(20),
              const PasswordSettingsSection(),
              const Gap(20),
              AccessibilitySection(importNotifier: _userImported),
              const Gap(20),
              const AboutSettingSection()
            ],
          ),
        ),
      ),
    );
  }
}
