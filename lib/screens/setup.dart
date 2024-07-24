import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/assets.dart';
import 'package:memoir/classes/encryptor.dart';
import 'package:memoir/classes/routes.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';

/// Page to set master password for the vault
class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() {
    return _SetupPageState();
  }
}

class _SetupPageState extends State<SetupPage> {
  /// Whether the initialization is being done
  bool _loading = false;

  /// Master Password to be set
  String _masterPassword = "";

  /// Whether master password has validate length i.e. at least 8 characters
  bool _validateLength = false;

  /// Whether master password has at least 1 lowercase letter
  bool _validateLowercase = false;

  /// Whether master password has at least 1 uppercase letter
  bool _validateUppercase = false;

  /// Whether master password has at least 1 number
  bool _validateNumber = false;

  /// Whether master password has at least 1 special character
  bool _validateSpecialCharacter = false;

  /// Validates and updates master password whenever it changes on [TextField]
  void _onMasterPasswordChange(String password) {
    setState(() => _validateLength = password.length >= 8);

    bool hasLowercase = password.characters.any((letter) {
      int code = letter.codeUnitAt(0);
      return code >= 97 && code <= 122;
    });
    setState(() => _validateLowercase = hasLowercase);

    bool hasUppercase = password.characters.any((letter) {
      int code = letter.codeUnitAt(0);
      return code >= 65 && code <= 90;
    });
    setState(() => _validateUppercase = hasUppercase);

    bool hasNumber = password.characters.any((letter) {
      int code = letter.codeUnitAt(0);
      return code >= 48 && code <= 57;
    });
    setState(() => _validateNumber = hasNumber);

    bool hasSpecialCharacter = password.characters.any((letter) {
      int code = letter.codeUnitAt(0);
      return (code >= 33 && code <= 47) ||
          (code >= 58 && code <= 64) ||
          (code >= 91 && code <= 96) ||
          (code >= 123 && code <= 126);
    });
    setState(() => _validateSpecialCharacter = hasSpecialCharacter);

    _masterPassword = password;
  }

  /// Sets the master password and navigates to [HomePage]
  void _createMasterPassword() {
    UserPreferences.masterPassword = _masterPassword.trim();

    setState(() => _loading = true);

    Encryptor.initializeKeys().then((_) {
      context.messenger.showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        showCloseIcon: true,
        content: Text("Master Password Created"),
      ));

      context.navigator.pushReplacementNamed(Routes.vault);
    });
  }

  @override
  Widget build(BuildContext context) {
    // can create if the master password is valid
    bool canCreate = _validateLength &&
        _validateLowercase &&
        _validateUppercase &&
        _validateNumber &&
        _validateSpecialCharacter;

    return Scaffold(
      appBar: AppBar(
        leading: const Hero(
          // linked to Homepage
          tag: 'Logo',
          child: CircleAvatar(backgroundImage: AssetImage(Assets.logo)),
        ),
        title: const Text("Setup Master Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Master Password",
                hintStyle: context.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              onChanged: _onMasterPasswordChange,
              maxLines: 1,
            ),
            const Gap(20),
            const Text(
              "This Password will be used to access your Passwords, so don't forget it",
            ),
            const Gap(10),
            const Text("Master Password must be:"),
            Text(
              "  • At least 8 characters long",
              style: context.textTheme.bodyMedium?.copyWith(
                color: _validateLength ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
            Text(
              "  • Have at least 1 lowercase letter",
              style: context.textTheme.bodyMedium?.copyWith(
                color:
                    _validateLowercase ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
            Text(
              "  • Have at least 1 uppercase letter",
              style: context.textTheme.bodyMedium?.copyWith(
                color:
                    _validateUppercase ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
            Text(
              "  • Have at least 1 number",
              style: context.textTheme.bodyMedium?.copyWith(
                color: _validateNumber ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
            Text(
              "  • Have at least 1 special character",
              style: context.textTheme.bodyMedium?.copyWith(
                color: _validateSpecialCharacter
                    ? Colors.greenAccent
                    : Colors.redAccent,
              ),
            ),
            const Gap(20),
            Center(
              child: FilledButton.icon(
                onPressed: canCreate ? _createMasterPassword : null,
                icon: _loading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: context.colorScheme.surface,
                        ),
                      )
                    : const FaIcon(FontAwesomeIcons.key),
                label: Text(
                  _loading ? "Setting up..." : "Create Master Password",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
