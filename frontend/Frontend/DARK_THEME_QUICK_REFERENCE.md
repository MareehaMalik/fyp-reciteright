# Dark Theme Quick Reference

## 🚀 Quick Start

### 1. Add Theme Toggle to Your Screen
```dart
import 'package:tajweed_corrector/widgets/theme_toggle_widget.dart';

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('My Screen'),
      actions: [ThemeToggleButton()],  // Add this!
    ),
    body: YourContent(),
  );
}
```

### 2. Use Theme Colors in Any Widget
```dart
final theme = Theme.of(context);

Container(
  color: theme.cardColor,  // Adapts to light/dark
  child: Text(
    'Hello',
    style: TextStyle(
      color: theme.textTheme.bodyLarge?.color,  // Proper contrast
    ),
  ),
)
```

## 🎨 Common Color Uses

| Purpose | Light | Dark |
|---------|-------|------|
| Main Background | #F5F7FB | #070B14 |
| Cards/Surfaces | #FFFFFF | #151D33 |
| Primary Buttons | #1E4976 | #1D5FEA |
| Main Text | #1A1A1A | #E4E7F2 |
| Secondary Text | #666666 | #A4A9C0 |
| Borders | #E0E0E0 | #232B40 |
| Disabled State | #EEEEEE | #151A28 |

## 📋 Reference Calls

```dart
// Get current theme
final theme = Theme.of(context);

// Check if dark mode
final isDark = theme.brightness == Brightness.dark;

// Use theme colors
theme.primaryColor           // Main color
theme.scaffoldBackgroundColor // Background
theme.cardColor              // Card/surface color
theme.dividerColor           // Borders/dividers
theme.textTheme.bodyLarge?.color      // Main text
theme.textTheme.bodySmall?.color      // Secondary text

// Use constants
AppThemes.darkPrimary        // Dark mode primary
AppThemes.lightBorderSubtle  // Light mode border
```

## 🎯 Common Patterns

### Pattern 1: Adaptive Container
```dart
Container(
  color: theme.cardColor,
  border: Border.all(color: theme.dividerColor),
  child: Text('Content', style: theme.textTheme.bodyLarge),
)
```

### Pattern 2: Adaptive Button
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Click me'),
)
// Colors come from theme automatically!
```

### Pattern 3: Adaptive Border
```dart
final borderColor = theme.brightness == Brightness.dark
    ? AppThemes.darkBorderSubtle
    : AppThemes.lightBorderSubtle;

Container(
  decoration: BoxDecoration(
    border: Border.all(color: borderColor),
  ),
)
```

### Pattern 4: Settings Toggle
```dart
// In settings page
Column(
  children: [
    ThemeToggleSettingsTile(),  // Full settings tile
    // Other settings...
  ],
)
```

## 🔍 Debugging

### Theme not changing?
```dart
// Ensure ThemeService is in the widget tree
// Check main.dart has this wrapper:
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ThemeService()),
  ],
  child: MyApp(),
)
```

### Can't see text?
```dart
// Use theme text colors
❌ Text('Hello', style: TextStyle(color: Color(0xFF000000)))
✅ Text('Hello', style: TextStyle(color: theme.textTheme.bodyLarge?.color))
```

### Colors not updating?
```dart
// Make sure widgets rebuild when theme changes
// Wrap with Consumer<ThemeService>:
Consumer<ThemeService>(
  builder: (context, themeService, _) {
    return YourWidget();
  },
)
```

## 📚 More Info

- Full Guide: See `DARK_THEME_GUIDE.md`
- Implementation: `services/theme_service.dart`
- Widgets: `widgets/theme_toggle_widget.dart`
- Summary: `DARK_THEME_IMPLEMENTATION_SUMMARY.md`

## 💡 Pro Tips

1. **Always use theme colors** - Never hardcode colors in new features
2. **Test both modes** - Toggle theme while developing
3. **Check contrast** - Ensure text is readable on backgrounds
4. **Use constants** - Access `AppThemes.darkPrimary` for explicit control
5. **Build once** - Use `Theme.of(context)` instead of multiple calls

## 🎪 Theme Toggle Options

```dart
// Option 1: Icon Button (AppBar)
ThemeToggleButton()

// Option 2: Settings Tile (Full featured)
ThemeToggleSettingsTile()

// Option 3: Compact Switch (Inline)
ThemeToggleSwitch()

// Option 4: Manual toggle
Consumer<ThemeService>(
  builder: (context, themeService, _) {
    return IconButton(
      icon: Icon(themeService.isDarkMode 
        ? Icons.light_mode 
        : Icons.dark_mode),
      onPressed: () => themeService.toggleTheme(),
    );
  },
)
```

## ✅ Checklist for New Screens

- [ ] Import `theme_service.dart`
- [ ] Use `theme.primaryColor` for buttons
- [ ] Use `theme.cardColor` for surfaces
- [ ] Use `theme.scaffoldBackgroundColor` for background
- [ ] Use `theme.textTheme.bodyLarge?.color` for main text
- [ ] Use `theme.textTheme.bodySmall?.color` for secondary
- [ ] Remove all hardcoded colors
- [ ] Test in both light and dark modes
- [ ] Verify text contrast (especially dark mode)

---

**Ready to add dark theme support? Copy a pattern above and customize!** 🎨

