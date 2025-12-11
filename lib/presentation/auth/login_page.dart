import 'package:flutter/material.dart';
import 'package:jj_mart/presentation/auth/forgot_password_page.dart';
import 'package:jj_mart/presentation/auth/sign_up_screen.dart';
import 'package:jj_mart/presentation/home/home_page.dart';
import 'package:jj_mart/presentation/landing/landing_page.dart';


class JMartSignInScreen extends StatefulWidget {
  const JMartSignInScreen({super.key});

  @override
  State<JMartSignInScreen> createState() => _JMartSignInScreenState();
}

class _JMartSignInScreenState extends State<JMartSignInScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Logo
              Center(
                child: Image.asset(
                  'assets/logo/logo.png', // Replace with your logo asset
                  height: 120,
                  // errorBuilder: (context, error, stackTrace) {
                  //   // Fallback if image doesn't load
                  //   return Container(
                  //     height: 120,
                  //     width: 120,
                  //     decoration: BoxDecoration(
                  //       color: Colors.blue.shade700,
                  //       borderRadius: BorderRadius.circular(16),
                  //     ),
                  //     child: const Center(
                  //       child: Text(
                  //         'J-MART',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 24,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // },
                ),
              ),

              const SizedBox(height: 40),

              // Sign in Title
              const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 24),

              // Mobile Number TextField
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter Mobile Number',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> ForgotPasswordScreen()));
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password", style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.w600,
                        ),)),
              ),
              const SizedBox(height: 24),

              // Sign In Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle sign in
                    final mobile = mobileController.text;
                    final password = passwordController.text;
                    
                    if (mobile.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> LandingPage()));
                    }
                    
                    // Add your sign in logic here
                    print('Mobile: $mobile, Password: $password');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0), // Blue color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Create Account Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to create account screen
                      print('Navigate to Create Account');
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> JMartCreateAccountScreen()));
                    },
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1565C0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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