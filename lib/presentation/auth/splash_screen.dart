import 'package:flutter/material.dart';
import 'dart:async';

import 'package:jj_mart/presentation/auth/login_page.dart';
import 'package:jj_mart/presentation/landing/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ==================== SPLASH SCREEN ====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    // 1. Wait for the 3-second timer
    await Future.delayed(const Duration(seconds: 3));

    // 2. Access SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 3. Get the token (replace 'user_token' with your actual key name)
    final String? token = prefs.getString('token');

    // 4. Check if the widget is still in the tree (best practice)
    if (!mounted) return;

    // 5. Conditional Navigation
    if (token != null && token.isNotEmpty) {
      // Token exists -> Go to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LandingPage(),
        ), // Replace with your Home Screen class
      );
    } else {
      // No token -> Go to Sign In
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const JMartSignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo/logo.png', // Replace with your logo
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                // Fallback logo
                return Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'J-MART',
                      style: TextStyle(
                        color: Color(0xFF1565C0),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            // Loading indicator
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
