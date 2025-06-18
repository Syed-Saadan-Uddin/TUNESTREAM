import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../bloc/auth/auth_bloc.dart';
import '../../core/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.backgroundColor, AppTheme.primarySurface],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Title & Tagline...
                  Lottie.asset(
                    'assets/animations/music_icon.json',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 24),
                  Text('TuneStream', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 35, fontWeight: FontWeight.bold, letterSpacing: 4)),
                  const SizedBox(height: 8),
                  Text('Music Without Limits', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textColor.withOpacity(0.7))),
                  const SizedBox(height: 40),

                  
                  _buildTextField(_emailController, 'Email'),
                  const SizedBox(height: 16),
                  _buildTextField(_passwordController, 'Password', obscureText: true),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAuthButton('Sign In', isPrimary: true, onTap: () {
                        context.read<AuthBloc>().add(AuthSignInRequested(email: _emailController.text.trim(), password: _passwordController.text.trim()));
                      }),
                      _buildAuthButton('Sign Up', onTap: () {
                        context.read<AuthBloc>().add(AuthSignUpRequested(email: _emailController.text.trim(), password: _passwordController.text.trim()));
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: AppTheme.primarySurface)),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('OR')),
                      Expanded(child: Divider(color: AppTheme.primarySurface)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  
                  GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(AuthSignInWithGoogleRequested());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: AppTheme.neumorphicDecoration(brightness: Theme.of(context).brightness),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset('assets/animations/google_icon.json', height: 24),
                          const SizedBox(width: 15),
                          Text('Continue with Google', style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthGuestLoginRequested());
                    },
                    child: Text(
                      'Listen as a Guest',
                      style: TextStyle(
                        color: AppTheme.textColor.withOpacity(0.8),
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.textColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildTextField(TextEditingController controller, String hint, {bool obscureText = false, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildAuthButton(String text, {required VoidCallback onTap, bool isPrimary = false}) {
    final brightness = Theme.of(context).brightness;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        decoration: isPrimary
            ? AppTheme.neumorphicDecoration(brightness: brightness)
                .copyWith(color: Theme.of(context).colorScheme.primary)
            : AppTheme.neumorphicDecoration(brightness: brightness),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}