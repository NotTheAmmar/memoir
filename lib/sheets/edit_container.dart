import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/database.dart';
import 'package:memoir/classes/password_generator.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/sheets/widgets/password_tools.dart';
import 'package:memoir/sheets/widgets/sheet.dart';
import 'package:memoir/classes/container.dart' as my;

/// ModalBottomSheet for editing a [my.Container]
class EditContainerSheet extends StatefulWidget {
  /// [my.Container] to be edited
  final my.Container container;

  const EditContainerSheet({super.key, required this.container});

  @override
  State<EditContainerSheet> createState() => _EditContainerSheetState();
}

class _EditContainerSheetState extends State<EditContainerSheet> {
  /// Form Key for validation
  final GlobalKey<FormState> _key = GlobalKey();

  /// Controller for `Name` form field
  final TextEditingController _nameCtrl = TextEditingController();

  /// Controller for `Password` form field
  final TextEditingController _passwordCtrl = TextEditingController();

  /// Indicates the Password Strength
  String _passwordStatus = '';

  /// Color of the current Password Strength
  Color _passwordStatusColor = Colors.grey;

  /// Indicates if the `name` already exists for validation of the `name` field
  bool _isNameDuplicate = false;

  @override
  void initState() {
    super.initState();

    _passwordCtrl.addListener(_passwordListener);

    _nameCtrl.text = widget.container.name;
    _passwordCtrl.text = widget.container.password;
  }

  @override
  void dispose() {
    _passwordCtrl.removeListener(_passwordListener);

    _nameCtrl.dispose();
    _passwordCtrl.dispose();

    super.dispose();
  }

  /// Listener to update the password strength whenever the password is updated
  void _passwordListener() {
    final (status, color) = PasswordGenerator.instance.getStatus(
      _passwordCtrl.text,
    );

    setState(() {
      _passwordStatus = status;
      _passwordStatusColor = color;
    });
  }

  /// Closes the ModalBottomSheet
  void _closeSheet() => context.navigator.pop();

  /// Updates the [my.Container] and closes the ModalBottomSheet
  ///
  /// It first validates the form data
  void _updateContainer() {
    final Future<bool> result = SQLite.instance.doesNameExists(
      _nameCtrl.text,
      id: widget.container.id,
    );

    result.then((value) {
      _isNameDuplicate = value;

      if (!_key.currentState!.validate()) return;

      final Future<void> result = SQLite.instance.updateContainer(my.Container(
        id: widget.container.id,
        name: _nameCtrl.text,
        password: _passwordCtrl.text,
      ));

      // Popping `true` to show SnackBar message for updating container
      result.then((_) => context.navigator.pop(true));
    });
  }

  /// Validates the `Name` form Field
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return "Required";

    if (_isNameDuplicate) return "Name Already Exists";

    return null;
  }

  /// Validates the `Password` form field
  String? validatePassword(String? value) {
    return value == null || value.isEmpty ? "Required" : null;
  }

  /// Password setter for randomly generated password from [PasswordTools]
  void _passwordSetter(String password) => _passwordCtrl.text = password;

  @override
  Widget build(BuildContext context) {
    return Sheet(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Text("Edit Container", style: context.textTheme.titleSmall),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                tooltip: 'Cancel',
                onPressed: _closeSheet,
                icon: const FaIcon(FontAwesomeIcons.xmark),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: 'Save Changes',
                onPressed: _updateContainer,
                icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk),
              ),
            ),
          ],
        ),
        const Gap(40),
        Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                validator: _validateName,
                decoration: InputDecoration(
                  hintText: "Container's Name",
                  hintStyle: context.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                maxLines: 1,
              ),
              const Gap(20),
              TextFormField(
                controller: _passwordCtrl,
                validator: validatePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: context.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  suffixIcon: PasswordTools(
                    randomPasswordSetter: _passwordSetter,
                  ),
                  counterText: _passwordStatus,
                  counterStyle: context.textTheme.bodySmall?.copyWith(
                    color: _passwordStatusColor,
                  ),
                ),
                maxLength: 256,
                maxLines: 1,
              ),
            ],
          ),
        )
      ],
    );
  }
}
