import 'package:flutter/material.dart';
import 'package:jj_mart/presentation/auth/forgot_password_page.dart';
import 'package:jj_mart/presentation/auth/sign_up_screen.dart';
import 'package:jj_mart/provider/auth_provider/auth_provider.dart';
import 'package:provider/provider.dart';

class JMartSignInScreen extends StatefulWidget {
  const JMartSignInScreen({super.key});

  @override
  State<JMartSignInScreen> createState() => _JMartSignInScreenState();
}

class _JMartSignInScreenState extends State<JMartSignInScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthProvider>();
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E60AA), // Brand Blue
              Color(0xFF64B5F6), // Light Blue
              Colors.white,
            ],
            stops: [0.3, 0.4, 0.9],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                
                // --- Logo Section ---
                Hero(
                  tag: 'logo',
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Image.asset(
                      'assets/logo/logo.png',
                      height: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // --- Main Login Card ---
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Welcome Back!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E60AA),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Login to your account to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                      const SizedBox(height: 30),

                      // Mobile Field
                      _buildTextField(
                        controller: mobileController,
                        hint: 'Mobile Number',
                        icon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      _buildTextField(
                        controller: passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        onToggleVisibility: () {
                          setState(() => _isPasswordVisible = !_isPasswordVisible);
                        },
                      ),

                      // // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color(0xFF1E60AA),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Sign In Button
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: controller.isLoading 
                            ? null 
                            : () async {
                                final mobile = mobileController.text;
                                final password = passwordController.text;

                                if (mobile.isEmpty || password.isEmpty) {
                                  _showError('Please fill in all fields');
                                } else {
                                  await controller.login(
                                    context: context,
                                    password: password,
                                    phone: mobile,
                                  );
                                }
                              },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E60AA),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: controller.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'LOG IN',
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

                // --- Footer Section ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => JMartCreateAccountScreen()),
                        );
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Color(0xFF1E60AA),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Reusable Widget for Fields ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        keyboardType: keyboardType,
        style: const TextStyle(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF1E60AA), size: 22),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}