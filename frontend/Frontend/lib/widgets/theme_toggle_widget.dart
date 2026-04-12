import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tajweed_corrector/services/theme_service.dart';

/// Theme Toggle Widget for AppBar
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return IconButton(
          icon: Icon(
            themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          tooltip: themeService.isDarkMode ? 'Light Mode' : 'Dark Mode',
          onPressed: () => themeService.toggleTheme(),
        );
      },
    );
  }
}

/// Full Theme Toggle Settings Tile
class ThemeToggleSettingsTile extends StatelessWidget {
  const ThemeToggleSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final theme = Theme.of(context);
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.brightness == Brightness.dark
                  ? AppThemes.darkBorderSubtle
                  : AppThemes.lightBorderSubtle,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: theme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      themeService.isDarkMode ? 'Dark Mode' : 'Light Mode',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: themeService.isDarkMode,
                onChanged: (_) => themeService.toggleTheme(),
                activeColor: theme.primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Compact Theme Toggle Switch
class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final theme = Theme.of(context);
        
        return Row(
          children: [
            Icon(
              Icons.light_mode,
              size: 20,
              color: !themeService.isDarkMode ? theme.primaryColor : Colors.grey,
            ),
            const SizedBox(width: 8),
            Switch.adaptive(
              value: themeService.isDarkMode,
              onChanged: (_) => themeService.toggleTheme(),
              activeColor: theme.primaryColor,
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.dark_mode,
              size: 20,
              color: themeService.isDarkMode ? theme.primaryColor : Colors.grey,
            ),
          ],
        );
      },
    );
  }
}

