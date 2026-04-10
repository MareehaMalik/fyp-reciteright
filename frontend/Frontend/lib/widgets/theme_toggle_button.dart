import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tajweed_corrector/services/theme_service.dart';

class ThemeToggleButton extends StatelessWidget {
  final Color? color;
  final double? size;

  const ThemeToggleButton({
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return IconButton(
          onPressed: () => themeService.toggleTheme(),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              themeService.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              key: ValueKey<bool>(themeService.isDarkMode),
              color: color,
              size: size,
            ),
          ),
          tooltip: themeService.isDarkMode ? 'Light Mode' : 'Dark Mode',
        );
      },
    );
  }
}
