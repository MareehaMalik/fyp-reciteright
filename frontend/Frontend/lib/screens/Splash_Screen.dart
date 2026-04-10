import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tajweed_corrector/screens/Splash_Screen1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  double _turns = 0.0;
  bool _isAnimating = false;

  void _autoRotate3Times() {
    if (_isAnimating) return;
    _isAnimating = true;

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 3.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _rotationAnimation.addListener(() {
      setState(() {
        _turns = _rotationAnimation.value;
      });
    });

    _rotationAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });

    _rotationController.forward();
  }

  void _navigateToNextScreen() {
    if (mounted) {
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen1()),
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 500), () {
      if (mounted) _autoRotate3Times();
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // 📌 Breakpoints
    final isTablet = width >= 600 && width < 1000;
    final isDesktop = width >= 1000;

    // 📌 Adapt sizes based on screen type
    double imageScale =
        width *
        (isDesktop
            ? 0.20
            : isTablet
            ? 0.35
            : 0.60);
    double logoScale =
        width *
        (isDesktop
            ? 0.13
            : isTablet
            ? 0.25
            : 0.38);
    double titleFont =
        height *
        (isDesktop
            ? 0.05
            : isTablet
            ? 0.042
            : 0.038);
    double footerFont =
        height *
        (isDesktop
            ? 0.024
            : isTablet
            ? 0.026
            : 0.028);

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
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Faint background image
              Positioned(
                top: height * 0.05,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    "assets/g4.png",
                    width: width,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),

              /// Central content
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Text image
                        Image.asset(
                          "assets/text.png",
                          width: imageScale,
                          fit: BoxFit.contain,
                        ),

                        SizedBox(height: height * 0.045),

                        /// Rotating logo
                        AnimatedRotation(
                          turns: _turns,
                          duration: const Duration(milliseconds: 50),
                          child: Image.asset(
                            "assets/logo.png",
                            width: logoScale,
                            fit: BoxFit.contain,
                          ),
                        ),

                        SizedBox(height: height * 0.05),

                        /// App name text
                        Text(
                          "Recite Right",
                          style: TextStyle(
                            fontSize: titleFont,
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.3,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// Bottom footer text
              Positioned(
                bottom: height * 0.035,
                child: Text(
                  "AI Tajweed Corrector",
                  style: TextStyle(
                    fontSize: footerFont,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
