import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _animationController.forward();

    // Navigate after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.pushReplacement('/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.height * 0.08;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/icons/logo.png',
                  height: imageSize,
                  width: imageSize,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome to Phoenix App!",
                style: textTheme.displayMedium,
              ),
              const SizedBox(height: 10),
              Text(
                "Health App",
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
