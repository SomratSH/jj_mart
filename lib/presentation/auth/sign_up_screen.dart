import 'package:flutter/material.dart';
import 'package:jj_mart/model/areas_model.dart';
import 'package:jj_mart/provider/auth_provider/auth_provider.dart';
import 'package:provider/provider.dart';

class JMartCreateAccountScreen extends StatefulWidget {
  const JMartCreateAccountScreen({super.key});

  @override
  State<JMartCreateAccountScreen> createState() =>
      _JMartCreateAccountScreenState();
}

class _JMartCreateAccountScreenState extends State<JMartCreateAccountScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
              Color(0xFF64B5F6),
              Colors.white,
            ],
            stops: [0.0, 0.3, 0.6],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                // --- Logo ---
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Image.asset(
                    'assets/logo/logo.png',
                    height: 60,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.shopping_bag,
                      size: 60,
                      color: Color(0xFF1E60AA),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // --- Registration Card ---
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Join J-Mart',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E60AA),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Create an account to start shopping',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      const SizedBox(height: 25),

                      // Account Type Selection Header
                      _buildInputLabel("Account Type"),
                      Row(
                        children: [
                          Expanded(
                            child: _buildAccountTypeCard(
                              title: "Retail",
                              subtitle: "Individual Customer",
                              icon: Icons.person_pin_rounded,
                              isSelected: controller.customerType == "retail",
                              onTap: () => controller.setCustomerType("retail"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildAccountTypeCard(
                              title: "Wholesale",
                              subtitle: "Bulk Business Buyer",
                              icon: Icons.store_rounded,
                              isSelected: controller.customerType == "wholesale",
                              onTap: () => controller.setCustomerType("wholesale"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Name Field
                      _buildInputLabel("Full Name"),
                      _buildTextField(
                        controller: nameController,
                        hint: 'Enter your name',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 16),

                      // Mobile Field
                      _buildInputLabel("Mobile Number"),
                      _buildTextField(
                        controller: mobileController,
                        hint: '01XXXXXXXXX',
                        icon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Area Dropdown
                      _buildInputLabel("Delivery Area"),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: DropdownButtonFormField<AreaModel>(
                          value: controller.selectedArea,
                          hint: Text('Select your area',
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                          icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFF1E60AA)),
                          decoration: const InputDecoration(border: InputBorder.none,),
                          items: controller.areas.map((AreaModel area) {
                            return DropdownMenuItem<AreaModel>(
                              value: area,
                              child: Text(area.name, style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (newValue) => controller.setArea(newValue!),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Address Field
                      _buildInputLabel("Full Address"),
                      _buildTextField(
                        controller: addressController,
                        hint: 'House/Road/Block',
                        icon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      _buildInputLabel("Password"),
                      _buildTextField(
                        controller: passwordController,
                        hint: 'Minimum 6 characters',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        onToggleVisibility: () {
                          setState(() => _isPasswordVisible = !_isPasswordVisible);
                        },
                      ),
                      const SizedBox(height: 30),

                      // Continue Button
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : () => _handleRegister(controller),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E60AA),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF1E60AA).withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'CREATE ACCOUNT',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // --- Footer ---
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: TextStyle(color: Colors.grey.shade700)),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          color: Color(0xFF1E60AA),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  Widget _buildAccountTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E60AA).withOpacity(0.08) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E60AA) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF1E60AA) : Colors.grey.shade400,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF1E60AA) : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? const Color(0xFF1E60AA).withOpacity(0.8) : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(icon, color: const Color(0xFF1E60AA), size: 20),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        ),
      ),
    );
  }

  void _handleRegister(AuthProvider controller) async {
    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();
    final address = addressController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty ||
        mobile.isEmpty ||
        controller.selectedArea == null ||
        address.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20),
        ),
      );
      return;
    }

    await controller.register(
      name: name,
      mobile: mobile,
      password: password,
      address: address,
      areaId: controller.selectedArea!.id.toString(),
      context: context,
    );
  }
}