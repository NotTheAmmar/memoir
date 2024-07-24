import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/assets.dart';
import 'package:memoir/classes/routes.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/extensions.dart';

/// Page to have the user access the vault by master password
class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  /// To Focus master password TextField on screen launch
  final FocusNode _focusNode = FocusNode();

  /// Master Password
  String _masterPassword = "";

  /// Error Message for [TextField]
  String _error = "";

  /// Whether their is an error with master password
  bool _hasError = false;

  /// Whether the master password is visible or not
  bool _visibility = false;

  @override
  void initState() {
    super.initState();

    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  /// Changes visibility of text in [TextField]
  void _changePasswordVisibility() {
    setState(() => _visibility = !_visibility);
  }

  /// Updates the master password according to [TextField]
  ///
  /// Raises error for [TextField] when master password is empty
  void _onMasterPasswordChanged(String password) {
    _masterPassword = password;

    setState(() {
      _hasError = _masterPassword.isEmpty;
      _error = "Required";
    });
  }

  /// Opens vault i.e. navigates to [HomePage] if the master password is valid
  void _openVault() {
    if (UserPreferences.masterPassword == _masterPassword.trim()) {
      setState(() => _hasError = false);

      context.navigator.pushReplacementNamed(Routes.vault);
    } else {
      setState(() {
        _hasError = true;
        _error = "Invalid";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                // Linked to Homepage
                tag: 'Logo',
                child: Image.asset(
                  Assets.logo,
                  width: context.mediaQuery.size.width * 0.5,
                ),
              ),
              const Gap(20),
              Text("Access Vault", style: context.textTheme.titleLarge),
              const Gap(20),
              TextField(
                autofocus: true,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: "Master Password",
                  hintStyle: context.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  error: _hasError
                      ? Text(_error, style: context.textTheme.bodySmall)
                      : null,
                  suffixIcon: IconButton(
                    tooltip: _visibility ? "Hide Password" : "Show Password",
                    onPressed: _changePasswordVisibility,
                    icon: FaIcon(
                      _visibility
                          ? FontAwesomeIcons.solidEye
                          : FontAwesomeIcons.solidEyeSlash,
                    ),
                  ),
                ),
                maxLines: 1,
                obscureText: !_visibility,
                obscuringCharacter: '*',
                onChanged: _onMasterPasswordChanged,
              ),
              const Gap(20),
              FilledButton(
                onPressed: _openVault,
                child: const Text("Open Vault"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
