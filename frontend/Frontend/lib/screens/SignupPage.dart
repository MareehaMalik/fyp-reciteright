import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tajweed_corrector/screens/Loginpage.dart';
import 'package:tajweed_corrector/services/auth_service.dart';
import 'package:tajweed_corrector/widgets/index.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      print('🔄 Starting signup process...');

      User? user = await _authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        fullName: nameController.text.trim(),
      );

      if (user != null && mounted) {
        print('✅ Signup successful!');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please log in.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        setState(() => _isLoading = false);
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      print('❌ Signup error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorDialog(e.toString());
      }
    }
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isLoading = true);

    try {
      print('🔄 Starting Google Sign-Up');
      User? user = await _authService.signUpWithGoogle();

      if (user != null && mounted) {
        print('✅ Google Sign-Up successful: ${user.email}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome ${user.displayName ?? user.email}!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      print('❌ Google Sign-Up error: $e');
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Up Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Full name required';
    if (value.length < 2) return 'Min 2 characters';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Invalid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password required';
    if (value.length < 6) return 'Min 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirm password required';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;
    final isTablet = size.width > 600 && size.width < 1000;
    final isDesktop = size.width >= 1000;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade50, Colors.green.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Decorative Circles
          Positioned(
            top: isSmallScreen ? -40 : -80,
            left: isSmallScreen ? -40 : -60,
            child: _buildCircle(
              isSmallScreen ? 80 : 150,
              Colors.green.shade200.withValues(alpha: 0.15),
            ),
          ),
          Positioned(
            bottom: isSmallScreen ? -60 : -100,
            right: isSmallScreen ? -30 : -80,
            child: _buildCircle(
              isSmallScreen ? 100 : 200,
              Colors.green.shade100.withValues(alpha: 0.2),
            ),
          ),

          // Main Content - Centered
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop
                        ? size.width * 0.3
                        : isTablet
                        ? size.width * 0.15
                        : 16,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Card Container
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: isDesktop
                              ? 500
                              : isTablet
                              ? 450
                              : double.infinity,
                        ),
                        padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 20 : 30,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo
                            _buildLogoSection(isSmallScreen),
                            SizedBox(height: isSmallScreen ? 16 : 20),

                            // Heading
                            Text(
                              "Let's begin your journey!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isSmallScreen
                                    ? 22
                                    : isTablet
                                    ? 28
                                    : 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2E5F8F),
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 24 : 32),

                            // Form
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Full Name Field
                                  CustomTextField(
                                    label: "Full Name",
                                    hintText: "Enter your full name",
                                    controller: nameController,
                                    keyboardType: TextInputType.name,
                                    validator: _validateName,
                                    prefixIcon: const Icon(Icons.person_outline),
                                  ),
                                  const SizedBox(height: 16),

                                  // Email Input Field
                                  CustomTextField(
                                    label: "Email address",
                                    hintText: "Enter email here",
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: _validateEmail,
                                    prefixIcon: const Icon(Icons.email_outlined),
                                  ),
                                  const SizedBox(height: 16),

                                  // Password Input Field
                                  CustomTextField(
                                    label: "Password",
                                    hintText: "Enter Password here",
                                    controller: passwordController,
                                    obscureText: true,
                                    validator: _validatePassword,
                                    prefixIcon: const Icon(Icons.lock_outline),
                                  ),
                                  const SizedBox(height: 16),

                                  // Confirm Password Field
                                  CustomTextField(
                                    label: "Confirm Password",
                                    hintText: "Re-enter your password",
                                    controller: confirmPasswordController,
                                    obscureText: true,
                                    validator: _validateConfirmPassword,
                                    prefixIcon: const Icon(Icons.lock_outline),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 20 : 28),

                            // Sign Up Button
                            CustomButton(
                              label: "Sign Up",
                              onPressed: _handleSignUp,
                              isLoading: _isLoading,
                              isEnabled: !_isLoading,
                              height: isSmallScreen ? 48 : 52,
                              fontSize: isSmallScreen ? 16 : 18,
                            ),
                            SizedBox(height: isSmallScreen ? 18 : 22),

                            // Sign In Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 13 : 14,
                                    color: const Color(0xFF3B7CB8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 13 : 14,
                                      color: const Color(0xFF3B7CB8),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isSmallScreen ? 18 : 24),

                            // OR Divider
                            _buildOrDivider(),
                            SizedBox(height: isSmallScreen ? 18 : 24),

                            // Google Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _isLoading
                                    ? null
                                    : _handleGoogleSignUp,
                                icon: _isLoading
                                    ? SizedBox(
                                        height: isSmallScreen ? 20 : 24,
                                        width: isSmallScreen ? 20 : 24,
                                        child: const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color(0xFF1E4976),
                                              ),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/Google.png',
                                        height: isSmallScreen ? 20 : 24,
                                        width: isSmallScreen ? 20 : 24,
                                      ),
                                label: Text(
                                  "Continue with Google",
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                  disabledForegroundColor: Colors.grey.shade400,
                                  padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 12 : 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 20 : 28),

                            // Bottom Decorative Element
                            Center(
                              child: Icon(
                                Icons.graphic_eq_rounded,
                                color: Colors.grey.shade300,
                                size: isSmallScreen ? 32 : 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection(bool isSmallScreen) {
    return CircleAvatar(
      radius: isSmallScreen ? 40 : 50,
      backgroundColor: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/logo.png', fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildLabeledInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required bool isPassword,
    required bool isSmallScreen,
    VoidCallback? onVisibilityToggle,
    bool obscurePassword = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2E5F8F),
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? obscurePassword : false,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: isSmallScreen ? 13 : 14,
            ),
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: onVisibilityToggle,
                    child: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF2E5F8F),
                      size: isSmallScreen ? 20 : 22,
                    ),
                  )
                : null,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF2E5F8F), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 14 : 16,
              vertical: isSmallScreen ? 12 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "OR",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}


