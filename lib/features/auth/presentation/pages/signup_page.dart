import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/core/di/injection_container.dart';
import 'package:restaurant_app/core/routes/app_router.dart';
import 'package:restaurant_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/auth_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  String _role = AppConstants.roleCustomer;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const tertiaryColor = Color(0xFFFDF5E6);
    const neutralDark = Color(0xFF1A1614);

    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: neutralDark,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/pizza_bg.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: neutralDark),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      neutralDark.withValues(alpha: 0.65),
                      neutralDark.withValues(alpha: 0.85),
                      neutralDark,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    AppRouter.goToRoleHome(context, state.user.role);
                  } else if (state is AuthFailureState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: primaryOrange),
                    );
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
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: tertiaryColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: secondaryOrange,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Join FoodieGo for delicious food delivered fast.',
                          style: TextStyle(fontSize: 14, color: tertiaryColor.withValues(alpha: 0.8)),
                        ),
                        const SizedBox(height: 24),

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
                                  color: secondaryOrange.withValues(alpha: 0.25),
                                  width: 1,
                                ),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    AuthTextField(
                                      controller: _nameController,
                                      label: 'Full Name',
                                      prefixIcon: Icons.person_outline_rounded,
                                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                                    ),
                                    AuthTextField(
                                      controller: _emailController,
                                      label: 'Email Address',
                                      keyboardType: TextInputType.emailAddress,
                                      prefixIcon: Icons.email_outlined,
                                      validator: (v) =>
                                          (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                                    ),
                                    AuthTextField(
                                      controller: _phoneController,
                                      label: 'Phone Number',
                                      keyboardType: TextInputType.number,
                                      prefixIcon: Icons.phone_outlined,
                                      maxLength: 11,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) return 'Phone number required';
                                        if (v.trim().length != 11) return 'Must be exactly 11 digits';
                                        return null;
                                      },
                                    ),
                                    AuthTextField(
                                      controller: _passwordController,
                                      label: 'Password',
                                      obscureText: true,
                                      prefixIcon: Icons.lock_outline_rounded,
                                      validator: (v) =>
                                          (v == null || v.length < 6) ? 'Min 6 characters' : null,
                                    ),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      initialValue: _role,
                                      dropdownColor: const Color(0xFF241E1C),
                                      style: const TextStyle(color: tertiaryColor),
                                      decoration: InputDecoration(
                                        labelText: 'Role',
                                        labelStyle: TextStyle(color: tertiaryColor.withValues(alpha: 0.7)),
                                        filled: true,
                                        fillColor: neutralDark.withValues(alpha: 0.5),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: tertiaryColor.withValues(alpha: 0.2)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: tertiaryColor.withValues(alpha: 0.2)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: secondaryOrange, width: 1.8),
                                        ),
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                            value: AppConstants.roleCustomer, child: Text('Customer')),
                                        DropdownMenuItem(
                                            value: AppConstants.roleRider, child: Text('Rider')),
                                        DropdownMenuItem(
                                            value: AppConstants.roleAdmin, child: Text('Admin')),
                                      ],
                                      onChanged: (v) => setState(() => _role = v!),
                                    ),
                                    const SizedBox(height: 20),
                                    isLoading
                                        ? const Center(child: CircularProgressIndicator(color: primaryOrange))
                                        : Container(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [primaryOrange, secondaryOrange],
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: primaryOrange.withValues(alpha: 0.4),
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
                                                  context.read<AuthBloc>().add(SignUpRequested(
                                                        name: _nameController.text.trim(),
                                                        email: _emailController.text.trim(),
                                                        password: _passwordController.text,
                                                        phone: _phoneController.text.trim(),
                                                        role: _role,
                                                      ));
                                                }
                                              },
                                              child: const Text(
                                                'Create Account',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
