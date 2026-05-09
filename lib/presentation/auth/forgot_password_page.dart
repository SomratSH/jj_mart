import 'package:flutter/material.dart';
import 'package:jj_mart/presentation/auth/otp_verification_page.dart';
import 'package:jj_mart/provider/auth_provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent AppBar to show the background gradient
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E60AA), // Brand Blue
              Color(0xFF64B5F6),
              Colors.white,
            ],
            stops: [0.0, 0.4, 0.7],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // --- Visual Header ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // --- Input Card ---
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Forgot Password?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E60AA),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Enter your registered mobile number to receive an OTP verification code.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Mobile Field Label
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          "Mobile Number",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      // Mobile TextField
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextField(
                          controller: mobileController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: '01XXXXXXXXX',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.phone_android_rounded,
                              color: Color(0xFF1E60AA),
                              size: 22,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Continue Button
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          // Disable button while loading to prevent multiple API calls
                          onPressed: context.watch<AuthProvider>().isLoading
                              ? null
                              : () {
                                  final mobile = mobileController.text.trim();

                                  if (mobile.isEmpty) {
                                    _showError(
                                      context,
                                      'Please enter mobile number',
                                    );
                                  } else {
                                    // --- CALL FORGOT PASSWORD API ---
                                    context
                                        .read<AuthProvider>()
                                        .sendForgotPasswordOTP(
                                          mobile: mobile,
                                          context: context,
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E60AA),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // Style for disabled state
                            disabledBackgroundColor: Colors.grey.shade400,
                          ),
                          child: context.watch<AuthProvider>().isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'SEND OTP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // --- Simple Footer Help ---
                Text(
                  "Remembered your password?",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(
                      color: Color(0xFF1E60AA),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }
}
