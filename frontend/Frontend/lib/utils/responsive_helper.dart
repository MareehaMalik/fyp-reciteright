import 'package:flutter/material.dart';

/// Responsive helper class for managing different screen sizes
class ResponsiveHelper {
  static const double mobileMaxWidth = 480;
  static const double tabletMinWidth = 600;
  static const double tabletMaxWidth = 1200;
  static const double desktopMinWidth = 1200;

  /// Get the screen type based on width
  static ScreenType getScreenType(double width) {
    if (width < tabletMinWidth) {
      return ScreenType.mobile;
    } else if (width < desktopMinWidth) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < tabletMinWidth;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletMinWidth && width < desktopMinWidth;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopMinWidth;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (isMobile(context)) {
      return EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.03,
      );
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(
        horizontal: width * 0.1,
        vertical: height * 0.04,
      );
    } else {
      return EdgeInsets.symmetric(
        horizontal: width * 0.2,
        vertical: height * 0.05,
      );
    }
  }

  /// Get responsive horizontal padding
  static double getResponsiveHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (isMobile(context)) {
      return width * 0.08;
    } else if (isTablet(context)) {
      return width * 0.15;
    } else {
      return width * 0.25;
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobileSize,
    double? tabletSize,
    double? desktopSize,
  }) {
    tabletSize ??= mobileSize * 1.2;
    desktopSize ??= mobileSize * 1.4;

    if (isMobile(context)) {
      return mobileSize;
    } else if (isTablet(context)) {
      return tabletSize;
    } else {
      return desktopSize;
    }
  }

  /// Get responsive button height
  static double getResponsiveButtonHeight(BuildContext context) {
    if (isMobile(context)) {
      return 48;
    } else if (isTablet(context)) {
      return 56;
    } else {
      return 60;
    }
  }

  /// Get responsive image width
  static double getResponsiveImageWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (isMobile(context)) {
      return width * 0.6;
    } else if (isTablet(context)) {
      return width * 0.5;
    } else {
      return width * 0.3;
    }
  }

  /// Get responsive container width
  static double getResponsiveContainerWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (isMobile(context)) {
      return width * 0.9;
    } else if (isTablet(context)) {
      return width * 0.75;
    } else {
      return 600;
    }
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(
    BuildContext context, {
    double mobileSpacing = 8,
    double? tabletSpacing,
    double? desktopSpacing,
  }) {
    tabletSpacing ??= mobileSpacing * 1.5;
    desktopSpacing ??= mobileSpacing * 2;

    if (isMobile(context)) {
      return mobileSpacing;
    } else if (isTablet(context)) {
      return tabletSpacing;
    } else {
      return desktopSpacing;
    }
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(BuildContext context) {
    if (isMobile(context)) {
      return 24;
    } else if (isTablet(context)) {
      return 28;
    } else {
      return 32;
    }
  }

  /// Get responsive border radius
  static double getResponsiveBorderRadius(BuildContext context) {
    if (isMobile(context)) {
      return 10;
    } else if (isTablet(context)) {
      return 12;
    } else {
      return 15;
    }
  }

  /// Get number of columns for grid layout
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }
}

enum ScreenType { mobile, tablet, desktop }

/// Responsive scaffold for building responsive layouts
class ResponsiveScaffold extends StatelessWidget {
  final Widget mobileBody;
  final Widget? tabletBody;
  final Widget? desktopBody;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;

  const ResponsiveScaffold({
    super.key,
    required this.mobileBody,
    this.tabletBody,
    this.desktopBody,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveHelper.getScreenType(
      MediaQuery.of(context).size.width,
    );

    Widget body;
    switch (screenType) {
      case ScreenType.mobile:
        body = mobileBody;
      case ScreenType.tablet:
        body = tabletBody ?? mobileBody;
      case ScreenType.desktop:
        body = desktopBody ?? tabletBody ?? mobileBody;
    }

    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: backgroundColor,
    );
  }
}

/// Builder widget for responsive layouts
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenType screenType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveHelper.getScreenType(
      MediaQuery.of(context).size.width,
    );
    return builder(context, screenType);
  }
}
