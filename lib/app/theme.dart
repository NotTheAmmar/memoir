import 'package:flutter/material.dart';

/// Default Font Family
const String _fontFamily = 'RobotoMono';

/// Default Padding
const EdgeInsets _padding = EdgeInsets.all(10);

/// Default Splash Factory
const InteractiveInkFeatureFactory _splashFactory = InkRipple.splashFactory;

/// Default Shape Border
final ShapeBorder _border = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
);

/// Base Color for Theme
const Color _mainColor = Color(0xFFFFCE54);

/// Created using [_mainColor]
final ColorScheme _lightScheme = ColorScheme.fromSeed(
  seedColor: _mainColor,
  error: Colors.red,
  onError: Colors.redAccent,
);

/// Created using [_mainColor] with [Brightness.dark]
final ColorScheme _darkScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: _mainColor,
  error: Colors.red,
  onError: Colors.redAccent,
);

/// Common Theme for Both [lightTheme] and [darkTheme]
final CardTheme _cardTheme = CardTheme(
  elevation: 10,
  margin: const EdgeInsets.all(5),
  shape: _border,
);

/// Common Theme for Both [lightTheme] and [darkTheme]
final ExpansionTileThemeData _expansionTileTheme = ExpansionTileThemeData(
  childrenPadding: _padding,
  tilePadding: _padding,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    side: BorderSide.none,
  ),
);

/// Common Theme for Both [lightTheme] and [darkTheme]
const FilledButtonThemeData _filledBtnTheme = FilledButtonThemeData(
  style: ButtonStyle(
    elevation: WidgetStatePropertyAll(10),
    enableFeedback: true,
    padding: WidgetStatePropertyAll(_padding),
    shape: WidgetStatePropertyAll(StadiumBorder()),
    splashFactory: _splashFactory,
  ),
);

/// Common Theme for Both [lightTheme] and [darkTheme]
const FloatingActionButtonThemeData _floatingBtnTheme =
    FloatingActionButtonThemeData(elevation: 10, enableFeedback: true);

/// Common Theme for Both [lightTheme] and [darkTheme]
const IconButtonThemeData _iconBtnTheme = IconButtonThemeData(
  style: ButtonStyle(
    elevation: WidgetStatePropertyAll(10),
    enableFeedback: true,
    padding: WidgetStatePropertyAll(_padding),
    splashFactory: _splashFactory,
  ),
);

/// Common Theme for Both [lightTheme] and [darkTheme]
final PopupMenuThemeData _popupMenuTheme = PopupMenuThemeData(
  elevation: 10,
  enableFeedback: true,
  position: PopupMenuPosition.under,
  shape: _border,
);

/// Common Theme for Both [lightTheme] and [darkTheme]
const TextButtonThemeData _textBtnTheme = TextButtonThemeData(
  style: ButtonStyle(
    enableFeedback: true,
    elevation: WidgetStatePropertyAll(10),
    padding: WidgetStatePropertyAll(_padding),
    splashFactory: _splashFactory,
  ),
);

/// For [ThemeMode.light] with font color [ColorScheme.onSurface]
final TextTheme _lightTextTheme = TextTheme(
  bodySmall: TextStyle(
    color: _lightScheme.onSurface,
    fontFamily: _fontFamily,
    fontSize: 12,
  ),
  bodyMedium: TextStyle(
    color: _lightScheme.onSurface,
    fontFamily: _fontFamily,
    fontSize: 14,
  ),
  bodyLarge: TextStyle(
    color: _lightScheme.onSurface,
    fontFamily: _fontFamily,
    fontSize: 16,
  ),
  titleSmall: TextStyle(
    color: _lightScheme.onSurface,
    fontFamily: _fontFamily,
    fontSize: 18,
  ),
  titleMedium: TextStyle(
    color: _lightScheme.onSurface,
    fontFamily: _fontFamily,
    fontSize: 20,
  ),
  titleLarge: TextStyle(
    color: _lightScheme.onSurface,
    fontFamily: _fontFamily,
    fontSize: 22,
  ),
);

/// For [ThemeMode.dark] with font color [ColorScheme.onSurface]
final TextTheme _darkTextTheme = TextTheme(
  bodySmall: TextStyle(
    color: _darkScheme.onSurface,
    fontFamily: _fontFamily,
    fontSize: 12,
  ),
  bodyMedium: TextStyle(
    color: _darkScheme.onSurface,
    fontFamily: _fontFamily,
    fontSize: 14,
  ),
  bodyLarge: TextStyle(
    color: _darkScheme.onSurface,
    fontFamily: _fontFamily,
    fontSize: 16,
  ),
  titleSmall: TextStyle(
    color: _darkScheme.onSurface,
    fontFamily: _fontFamily,
    fontSize: 18,
  ),
  titleMedium: TextStyle(
    color: _darkScheme.onSurface,
    fontFamily: _fontFamily,
    fontSize: 20,
  ),
  titleLarge: TextStyle(
    color: _darkScheme.onSurface,
    fontFamily: _fontFamily,
    fontSize: 22,
  ),
);

/// Created using [_lightScheme]
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  cardTheme: _cardTheme,
  colorScheme: _lightScheme,
  dividerTheme: DividerThemeData(
    color: _lightScheme.secondary,
    indent: 10,
    endIndent: 10,
    space: 5,
    thickness: 0.625,
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: const InputDecorationTheme(contentPadding: _padding),
    menuStyle: const MenuStyle(
      elevation: WidgetStatePropertyAll(10),
      padding: WidgetStatePropertyAll(_padding),
    ),
    textStyle: _lightTextTheme.bodyMedium,
  ),
  expansionTileTheme: _expansionTileTheme,
  iconButtonTheme: _iconBtnTheme,
  inputDecorationTheme: InputDecorationTheme(
    border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
    contentPadding: _padding,
    hintStyle: _lightTextTheme.bodySmall?.copyWith(color: Colors.grey),
  ),
  filledButtonTheme: _filledBtnTheme,
  floatingActionButtonTheme: _floatingBtnTheme,
  fontFamily: _fontFamily,
  listTileTheme: ListTileThemeData(
    contentPadding: _padding,
    enableFeedback: true,
    style: ListTileStyle.list,
    subtitleTextStyle: _lightTextTheme.bodySmall?.copyWith(color: Colors.grey),
    titleTextStyle: _lightTextTheme.bodyLarge,
  ),
  popupMenuTheme: _popupMenuTheme,
  searchBarTheme: SearchBarThemeData(
    elevation: const WidgetStatePropertyAll(10),
    hintStyle: WidgetStatePropertyAll(_lightTextTheme.bodySmall?.copyWith(
      color: Colors.grey,
    )),
    padding: const WidgetStatePropertyAll(EdgeInsets.all(5)),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: _lightScheme.inverseSurface,
    behavior: SnackBarBehavior.floating,
    contentTextStyle: _lightTextTheme.bodyMedium?.copyWith(
      color: _lightScheme.onInverseSurface,
    ),
    dismissDirection: DismissDirection.down,
    elevation: 10,
    insetPadding: _padding,
    shape: _border,
    showCloseIcon: true,
  ),
  textButtonTheme: _textBtnTheme,
  textTheme: _lightTextTheme,
);

/// Created using [_darkScheme]
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  cardTheme: _cardTheme,
  colorScheme: _darkScheme,
  dividerTheme: DividerThemeData(
    color: _darkScheme.secondary,
    indent: 10,
    endIndent: 10,
    space: 10,
    thickness: 0.625,
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: const InputDecorationTheme(contentPadding: _padding),
    menuStyle: const MenuStyle(
      elevation: WidgetStatePropertyAll(10),
      padding: WidgetStatePropertyAll(_padding),
    ),
    textStyle: _darkTextTheme.bodyMedium,
  ),
  expansionTileTheme: _expansionTileTheme,
  iconButtonTheme: _iconBtnTheme,
  inputDecorationTheme: InputDecorationTheme(
    border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
    contentPadding: _padding,
    hintStyle: _darkTextTheme.bodySmall?.copyWith(color: Colors.grey),
  ),
  filledButtonTheme: _filledBtnTheme,
  floatingActionButtonTheme: _floatingBtnTheme,
  fontFamily: _fontFamily,
  listTileTheme: ListTileThemeData(
    contentPadding: const EdgeInsets.all(10),
    enableFeedback: true,
    style: ListTileStyle.list,
    subtitleTextStyle: _darkTextTheme.bodySmall?.copyWith(color: Colors.grey),
    titleTextStyle: _darkTextTheme.bodyLarge,
  ),
  popupMenuTheme: _popupMenuTheme,
  searchBarTheme: SearchBarThemeData(
    elevation: const WidgetStatePropertyAll(10),
    hintStyle: WidgetStatePropertyAll(_darkTextTheme.bodySmall?.copyWith(
      color: Colors.grey,
    )),
    padding: const WidgetStatePropertyAll(EdgeInsets.all(5)),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: _darkScheme.inverseSurface,
    behavior: SnackBarBehavior.floating,
    contentTextStyle: _darkTextTheme.bodyMedium?.copyWith(
      color: _darkScheme.onInverseSurface,
    ),
    dismissDirection: DismissDirection.down,
    elevation: 10,
    insetPadding: _padding,
    shape: _border,
    showCloseIcon: true,
  ),
  textButtonTheme: _textBtnTheme,
  textTheme: _darkTextTheme,
);
