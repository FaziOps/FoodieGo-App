import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/core/routes/app_router.dart';
import 'package:restaurant_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:restaurant_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:restaurant_app/features/auth/presentation/pages/signup_page.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedDemoRole = AppConstants.roleCustomer;
  bool _isDemoAttempt = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _quickLogin(BuildContext context, String role) {
    final email = '$role@demo.com';
    const password = 'password123';

    _selectedDemoRole = role;
    _isDemoAttempt = true;

    _emailController.text = email;
    _passwordController.text = password;

    context.read<AuthBloc>().add(LoginRequested(email: email, password: password));
  }

  void _handleAuthFailure(BuildContext context, String message) {
    if (_isDemoAttempt) {
      _isDemoAttempt = false;
      final role = _selectedDemoRole;
      final email = '$role@demo.com';
      const password = 'password123';
      final name = role == 'admin'
          ? 'Admin User'
          : role == 'rider'
              ? 'Rider Alex'
              : 'Customer Sam';

      // Auto create demo account in Firebase Auth + Firestore
      context.read<AuthBloc>().add(SignUpRequested(
            name: name,
            email: email,
            password: password,
            phone: '+15550199',
            role: role,
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFD35400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Custom Brand Palette defined in design guide
    const primaryColor = Color(0xFFD35400);   // Warm Burnt Orange
    const secondaryColor = Color(0xFFE67E22); // Vibrant Orange
    const tertiaryColor = Color(0xFFFDF5E6);  // Cream Off-White
    const neutralDark = Color(0xFF1A1614);    // Warm Dark Neutral

    return Scaffold(
      backgroundColor: neutralDark,
      body: Stack(
        children: [
          // 1. Full-bleed pizza background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/pizza_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [primaryColor, neutralDark],
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Dark vignette / gradient overlay tuned to neutral dark palette for maximum readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    neutralDark.withValues(alpha: 0.65),
                    neutralDark.withValues(alpha: 0.85),
                    neutralDark.withValues(alpha: 0.96),
                    neutralDark,
                  ],
                  stops: const [0.0, 0.35, 0.70, 1.0],
                ),
              ),
            ),
          ),

          // 3. Foreground content
          SafeArea(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  AppRouter.goToRoleHome(context, state.user.role);
                } else if (state is AuthFailureState) {
                  _handleAuthFailure(context, state.message);
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoading;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 170),

                      // FoodieGo Branding Header with exact user color palette & dark shadow for maximum legibility
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: secondaryColor,
                          height: 1.1,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.8),
                              offset: const Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'FoodieGo ',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: primaryColor,
                              height: 1.1,
                              letterSpacing: -0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.8),
                                  offset: const Offset(0, 2),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            '👋',
                            style: TextStyle(fontSize: 32),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Satisfy your cravings with just a few taps',
                        style: TextStyle(
                          fontSize: 15,
                          color: tertiaryColor.withValues(alpha: 0.90),
                          height: 1.4,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.7),
                              offset: const Offset(0, 1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Glassmorphic Login Form Container styled with neutral dark & orange accents
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: neutralDark.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: secondaryColor.withValues(alpha: 0.25),
                                width: 1,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Quick Demo Logins Header
                                  const Row(
                                    children: [
                                      Icon(Icons.bolt, color: secondaryColor, size: 18),
                                      SizedBox(width: 6),
                                      Text(
                                        'Quick Demo Accounts',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: secondaryColor,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      _buildDemoButton('Customer', AppConstants.roleCustomer, secondaryColor, tertiaryColor),
                                      const SizedBox(width: 8),
                                      _buildDemoButton('Admin', AppConstants.roleAdmin, secondaryColor, tertiaryColor),
                                      const SizedBox(width: 8),
                                      _buildDemoButton('Rider', AppConstants.roleRider, secondaryColor, tertiaryColor),
                                    ],
                                  ),
                                  const SizedBox(height: 18),

                                  AuthTextField(
                                    controller: _emailController,
                                    label: 'Email Address',
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: Icons.email_outlined,
                                    validator: (v) =>
                                        (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                                  ),
                                  AuthTextField(
                                    controller: _passwordController,
                                    label: 'Password',
                                    obscureText: true,
                                    prefixIcon: Icons.lock_outline_rounded,
                                    validator: (v) =>
                                        (v == null || v.length < 6) ? 'Min 6 characters' : null,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                                      ),
                                      child: Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                          color: tertiaryColor.withValues(alpha: 0.7),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [primaryColor, secondaryColor],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: primaryColor.withValues(alpha: 0.4),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              foregroundColor: tertiaryColor,
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (_formKey.currentState!.validate()) {
                                                _isDemoAttempt = false;
                                                context.read<AuthBloc>().add(LoginRequested(
                                                      email: _emailController.text.trim(),
                                                      password: _passwordController.text,
                                                    ));
                                              }
                                            },
                                            child: const Text(
                                              'Sign In',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account?",
                                        style: TextStyle(
                                          color: tertiaryColor.withValues(alpha: 0.7),
                                          fontSize: 13,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const SignUpPage()),
                                        ),
                                        child: const Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoButton(String label, String role, Color accentColor, Color textColor) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: accentColor.withValues(alpha: 0.1),
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 8),
          side: BorderSide(color: accentColor.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => _quickLogin(context, role),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
