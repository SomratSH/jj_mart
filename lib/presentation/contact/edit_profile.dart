import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jj_mart/provider/auth_provider/auth_provider.dart';
import 'package:jj_mart/provider/profile_provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController addressController;
  late TextEditingController
  emailController; // Added to support your API payload requirement

  String? selectedAreaName;
  dynamic
  selectedAreaId; // Tracks the selected area ID for your backend requirement
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Fetch current data from ProfileProvider immediately to avoid losing text input during recompositions
    final profileProvider = context.read<ProfileProvider>();
    final authProvider = context.read<AuthProvider>();
    final userProfile = profileProvider.profile;

    nameController = TextEditingController(
      text: userProfile?.customerName ?? '',
    );
    mobileController = TextEditingController(
      text: userProfile?.customerMobile ?? '',
    );
    addressController = TextEditingController(
      text: userProfile?.customerAddress ?? '',
    );
    emailController = TextEditingController(
      text: userProfile?.customerEmail ?? '',
    );

    authProvider.areas.forEach((e) {
      if (e.id == userProfile?.areaId) {
        selectedAreaName = e.name;
      }
    });

    selectedAreaId = userProfile?.areaId;
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // HTTP POST Profile Update Request Handler
  Future<void> _updateProfileData() async {
    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");
      const String baseUrl =
          "https://jmartbd.com/api"; // Replace with your central source Constants if available

      final response = await http.post(
        Uri.parse("$baseUrl/updateProfile"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "customer_name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "mobile": mobileController.text.trim(),
          "address": addressController.text.trim(),
          "area_id": selectedAreaId,
        }),
      );

      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && decodedResponse["status"] == true) {
        // Refresh local profile instance via its provider before closing screen context
        await context.read<ProfileProvider>().fetchProfile();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        throw Exception(
          decodedResponse["message"] ?? "Failed to save data adjustments.",
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileProvider>();
    final controllerAuth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Picture Placeholder Stack Frame
            Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // User Name Label display
            Text(
              controller.profile?.customerName ?? 'Guest User',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            // Profile Input Form Frame
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Name Input Field
                  _buildProfileTextField(
                    labelController: nameController,
                    hint: "Name",
                    inputType: TextInputType.name,
                  ),

                  const SizedBox(height: 16),

                  // Email Input Field
                  _buildProfileTextField(
                    labelController: emailController,
                    hint: "Email Address",
                    inputType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // Mobile Input Field
                  _buildProfileTextField(
                    labelController: mobileController,
                    hint: "Mobile Number",
                    inputType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  // Select Area Dropdown Picker
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedAreaName,
                      hint: Text(
                        'Select Area',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey.shade600,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      items: controllerAuth.areas.map((area) {
                        return DropdownMenuItem<String>(
                          value: area.name,
                          child: Text(
                            area.name ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        // Find matching ID element model inside the dropdown loop context
                        final selectedModel = controllerAuth.areas.firstWhere(
                          (element) => element.name == newValue,
                        );
                        setState(() {
                          selectedAreaName = newValue;
                          selectedAreaId = selectedModel
                              .id; // Correctly map area ID mapping requirement
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Address Input Field
                  _buildProfileTextField(
                    labelController: addressController,
                    hint: "Address",
                    inputType: TextInputType.streetAddress,
                  ),

                  const SizedBox(height: 24),

                  // Update Button Actions Frame
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSaving
                          ? null
                          : () {
                              // Execution Safety Validation Rules Checks
                              if (nameController.text.trim().isEmpty ||
                                  emailController.text.trim().isEmpty ||
                                  mobileController.text.trim().isEmpty ||
                                  addressController.text.trim().isEmpty ||
                                  selectedAreaId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please verify all parameters are filled.',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              _updateProfileData();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Update',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Refactored Modular Textfield Widget Extractor Function
  Widget _buildProfileTextField({
    required TextEditingController labelController,
    required String hint,
    required TextInputType inputType,
  }) {
    return TextField(
      controller: labelController,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
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
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
