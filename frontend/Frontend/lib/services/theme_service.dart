import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  bool _isDarkMode = false;
  late SharedPreferences _prefs;

  ThemeService() {
    _initializeTheme();
  }

  bool get isDarkMode => _isDarkMode;

  Future<void> _initializeTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    _isDarkMode = isDark;
    await _prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }
}

class AppThemes {
  // ============= LIGHT THEME COLORS =============
  
  // Backgrounds
  static const Color lightPrimaryBackground = Color(0xFFF5F7FB);
  static const Color lightSurfaceLow = Color(0xFFFAFBFC);
  static const Color lightSurfaceHigh = Colors.white;
  
  // Primary / Accent
  static const Color lightPrimary = Color(0xFF1E4976);
  static const Color lightPrimaryVariant = Color(0xFF1548B0);
  static const Color lightSecondary = Color(0xFF25B9A6);
  
  // Text
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF666666);
  static const Color lightTextMuted = Color(0xFF999999);
  
  // Borders / Dividers
  static const Color lightBorderSubtle = Color(0xFFE0E0E0);
  
  // States
  static const Color lightSuccess = Color(0xFF2ECC71);
  static const Color lightError = Color(0xFFE74C3C);
  static const Color lightWarning = Color(0xFFFFA500);
  static const Color lightDisabledText = Color(0xFFCCCCCC);
  static const Color lightDisabledBackground = Color(0xFFEEEEEE);
  
  // ============= DARK THEME COLORS =============
  
  // Backgrounds
  static const Color darkPrimaryBackground = Color(0xFF070B14);
  static const Color darkSurfaceLow = Color(0xFF0D1424);
  static const Color darkSurfaceHigh = Color(0xFF151D33);
  
  // Primary / Accent
  static const Color darkPrimary = Color(0xFF1D5FEA);
  static const Color darkPrimaryVariant = Color(0xFF1548B0);
  static const Color darkSecondary = Color(0xFF25B9A6);
  
  // Text
  static const Color darkTextPrimary = Color(0xFFE4E7F2);
  static const Color darkTextSecondary = Color(0xFFA4A9C0);
  static const Color darkTextMuted = Color(0xFF7A8099);
  
  // Borders / Dividers
  static const Color darkBorderSubtle = Color(0xFF232B40);
  
  // States
  static const Color darkSuccess = Color(0xFF2ECC71);
  static const Color darkError = Color(0xFFE74C3C);
  static const Color darkWarning = Color(0xFFFFA500);
  static const Color darkDisabledText = Color(0xFF5F6680);
  static const Color darkDisabledBackground = Color(0xFF151A28);
  
  // Overlay
  static const Color darkOverlay = Color(0xB3030814); // rgba(3, 8, 20, 0.7)

  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: lightPrimary,
      scaffoldBackgroundColor: lightPrimaryBackground,
      cardColor: lightSurfaceHigh,
      dividerColor: lightBorderSubtle,
      highlightColor: lightPrimary.withOpacity(0.1),
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        primaryContainer: lightPrimaryVariant,
        secondary: lightSecondary,
        tertiary: lightPrimaryBackground,
        surface: lightSurfaceHigh,
        background: lightPrimaryBackground,
        error: lightError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
        onBackground: lightTextPrimary,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: lightTextPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: lightTextPrimary, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: lightTextPrimary, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: lightTextPrimary, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: lightTextPrimary, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: lightTextPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: lightTextPrimary, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: lightTextPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: lightTextPrimary),
        bodyMedium: TextStyle(color: lightTextPrimary),
        bodySmall: TextStyle(color: lightTextSecondary),
        labelLarge: TextStyle(color: lightTextPrimary, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurfaceHigh,
        foregroundColor: lightTextPrimary,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightPrimary,
          side: const BorderSide(color: lightPrimary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightSurfaceLow,
        selectedColor: lightPrimary,
        labelStyle: const TextStyle(color: lightTextPrimary, fontWeight: FontWeight.w600),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        side: const BorderSide(color: lightBorderSubtle, width: 1.5),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceHigh,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: lightBorderSubtle),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightBorderSubtle, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightPrimary, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: const TextStyle(color: lightTextSecondary),
        hintStyle: const TextStyle(color: lightTextMuted),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: darkPrimary,
      scaffoldBackgroundColor: darkPrimaryBackground,
      cardColor: darkSurfaceHigh,
      dividerColor: darkBorderSubtle,
      highlightColor: darkPrimary.withOpacity(0.15),
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        primaryContainer: darkPrimaryVariant,
        secondary: darkSecondary,
        tertiary: darkSurfaceLow,
        surface: darkSurfaceHigh,
        background: darkPrimaryBackground,
        error: darkError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
        onBackground: darkTextPrimary,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: darkTextPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: darkTextPrimary, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: darkTextPrimary, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: darkTextPrimary, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: darkTextPrimary, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: darkTextPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: darkTextPrimary, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: darkTextPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: darkTextPrimary),
        bodyMedium: TextStyle(color: darkTextPrimary),
        bodySmall: TextStyle(color: darkTextSecondary),
        labelLarge: TextStyle(color: darkTextPrimary, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurfaceHigh,
        foregroundColor: darkTextPrimary,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: darkDisabledBackground,
          disabledForegroundColor: darkDisabledText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimary,
          side: const BorderSide(color: darkPrimary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceLow,
        selectedColor: darkPrimary,
        labelStyle: const TextStyle(color: darkTextPrimary, fontWeight: FontWeight.w600),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        side: const BorderSide(color: darkBorderSubtle, width: 1.5),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceHigh,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: darkBorderSubtle),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: darkBorderSubtle, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: darkPrimary, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: const TextStyle(color: darkTextSecondary),
        hintStyle: const TextStyle(color: darkTextMuted),
      ),
    );
  }
}
