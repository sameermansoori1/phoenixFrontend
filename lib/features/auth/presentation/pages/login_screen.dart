import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix_app/core/theme/app_colors.dart';
import 'package:phoenix_app/features/auth/presentation/bloc/loginBloc/login_bloc.dart';
import 'package:phoenix_app/features/auth/presentation/bloc/loginBloc/login_event.dart';
import 'package:phoenix_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:phoenix_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:phoenix_app/features/auth/presentation/widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _loginBloc,
      child: Scaffold(
        backgroundColor: AppColors.bgContainer,
        body: SafeArea(
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login successful!'),
                    backgroundColor: AppColors.success,
                  ),
                );
                // Navigate to home screen
                // Navigator.pushReplacementNamed(context, '/home');
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const SizedBox(height: 60),
                  _buildLoginForm(),
                  const SizedBox(height: 40),
                  _buildSocialLogin(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/heart.png',
              height: 30,
              width: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'Phoenix Labs',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          width: 100,
          height: 100, // Make height equal to width for perfect circle
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset(
              'assets/icons/appLogo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLoginForm() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final formState =
            state is LoginFormState ? state : const LoginFormState();
        final isLoading = state is LoginLoading;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              // Email Field
              CustomTextField(
                label: 'Email',
                hintText: 'your@email.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                onChanged: (value) {
                  context.read<LoginBloc>().add(LoginEmailChanged(value));
                },
              ),
              const SizedBox(height: 20),
              // Password Field
              CustomTextField(
                label: 'Password',
                hintText: '••••••••',
                controller: _passwordController,
                obscureText: !formState.isPasswordVisible,
                enabled: !isLoading,
                suffixIcon: IconButton(
                  icon: Icon(
                    formState.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.iconColor,
                  ),
                  onPressed: () {
                    context.read<LoginBloc>().add(
                          const LoginPasswordVisibilityToggled(),
                        );
                  },
                ),
                onChanged: (value) {
                  context.read<LoginBloc>().add(LoginPasswordChanged(value));
                },
              ),
              const SizedBox(height: 30),
              // Sign In Button
              CustomButton(
                text: 'Sign In',
                width: double.infinity,
                isLoading: isLoading,
                onPressed: formState.isFormValid
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
              ),
              const SizedBox(height: 20),
              // Forgot Password
              TextButton(
                onPressed: () {
                  // Navigate to forgot password screen
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        // Sign Up Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to sign up screen
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Divider
        const Row(
          children: [
            Expanded(child: Divider(color: AppColors.divider)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or continue with',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.divider)),
          ],
        ),
        const SizedBox(height: 20),
        // Social Login Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SocialLoginButton(
              iconPath: 'google',
              label: 'Google',
              onPressed: () {
                // Handle Google sign in
              },
            ),
            SocialLoginButton(
              iconPath: 'apple',
              label: 'Apple',
              onPressed: () {
                // Handle Apple sign in
              },
            ),
            SocialLoginButton(
              iconPath: 'facebook',
              label: 'Facebook',
              onPressed: () {
                // Handle Facebook sign in
              },
            ),
          ],
        ),
      ],
    );
  }
}
