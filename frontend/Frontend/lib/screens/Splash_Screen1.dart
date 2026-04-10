import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tajweed_corrector/screens/SignUpScreen.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();

    // Auto navigation after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // 📌 Breakpoints
    final isTablet = width >= 600 && width < 1000;
    final isDesktop = width >= 1000;

    // 📌 Scale values based on screen size
    double titleFont =
        height *
        (isDesktop
            ? 0.045
            : isTablet
            ? 0.048
            : 0.052);
    double subtitleFont =
        height *
        (isDesktop
            ? 0.028
            : isTablet
            ? 0.03
            : 0.032);
    double imageWidth =
        width *
        (isDesktop
            ? 0.22
            : isTablet
            ? 0.35
            : 0.48);
    double iconWidth =
        width *
        (isDesktop
            ? 0.09
            : isTablet
            ? 0.13
            : 0.2);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E4976), Color(0xFF0F2940)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 10),

                  /// Center Content
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Title Image
                          Image.asset(
                            "assets/text_two.png",
                            width: imageWidth,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: height * 0.05),

                          /// Main Title
                          Text(
                            "Recite Right",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: titleFont,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),

                          /// Subtitle
                          Text(
                            "AI Tajweed Corrector",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: subtitleFont,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Bottom Icon
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.05),
                    child: Image.asset(
                      "assets/icon.png",
                      width: iconWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
