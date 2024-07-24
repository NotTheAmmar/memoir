import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/database.dart';
import 'package:memoir/classes/password_generator.dart';
import 'package:memoir/extensions.dart';
import 'package:memoir/sheets/widgets/password_tools.dart';
import 'package:memoir/sheets/widgets/sheet.dart';

/// ModalBottomSheet Widget for Adding a new Container aka Password
class NewContainerSheet extends StatefulWidget {
  const NewContainerSheet({super.key});

  @override
  State<NewContainerSheet> createState() => _NewContainerSheetState();
}

class _NewContainerSheetState extends State<NewContainerSheet> {
  /// Form Key for validation
  final GlobalKey<FormState> _key = GlobalKey();

  /// Controller for inputting `name`
  final TextEditingController _nameCtrl = TextEditingController();

  /// Controller for inputting `password`
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

    SQLite.getDefaultContainerName().then((name) {
      _nameCtrl.text = name;
    });

    _passwordCtrl.addListener(_passwordListener);
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
    final (status, color) = PasswordGenerator.getStatus(_passwordCtrl.text);

    setState(() {
      _passwordStatus = status;
      _passwordStatusColor = color;
    });
  }

  /// Validates the `Name` form field
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return "Required";

    if (_isNameDuplicate) return "Name Already Exists";

    // All good
    return null;
  }

  /// Validates the `Password` form field
  String? _validatePassword(String? value) {
    return value == null || value.isEmpty ? "Required" : null;
  }

  /// Creates a new Password Entry and closes the ModalBottomSheet
  ///
  /// It first validates the form fields
  void _addContainer() {
    SQLite.doesNameExists(_nameCtrl.text).then((value) {
      _isNameDuplicate = value;

      if (!_key.currentState!.validate()) return;

      Future<void> result = SQLite.addContainer(
        _nameCtrl.text,
        _passwordCtrl.text,
      );

      // Popped true to refresh the Containers List
      result.then((_) => context.navigator.pop(true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sheet(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Text("New Container", style: context.textTheme.titleSmall),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: "Save",
                onPressed: _addContainer,
                icon: const FaIcon(FontAwesomeIcons.check),
              ),
            ),
          ],
        ),
        const Gap(20),
        Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                validator: _validateName,
                decoration: const InputDecoration(hintText: "Container's Name"),
                maxLines: 1,
              ),
              const Gap(10),
              TextFormField(
                controller: _passwordCtrl,
                validator: _validatePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: context.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  suffixIcon: PasswordTools(
                    randomPasswordSetter: (value) => _passwordCtrl.text = value,
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
        ),
      ],
    );
  }
}
