import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../views/login_screen.dart';

class CustomDrawer extends StatelessWidget {
  final AuthController authController;

  const CustomDrawer({
    super.key,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Obx(
            () {
              // Decode Base64 image
              Uint8List? byteImage;
              if (authController.userData.value?.empImage != null &&
                  authController.userData.value!.empImage!.isNotEmpty) {
                try {
                  String filteredString =
                      authController.userData.value!.empImage!.replaceAll('"', '');
                  byteImage = const Base64Decoder().convert(filteredString);
                } catch (e) {
                  print('Error decoding image: $e');
                  byteImage = null;
                }
              }

              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade700, Colors.teal.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: byteImage != null
                      ? ClipOval(
                          child: Image.memory(
                            byteImage,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.teal.shade700,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.teal.shade700,
                        ),
                ),
                accountName: Text(
                  authController.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                accountEmail: Text(
                  authController.displayEmail,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            },
          ),

          // User Info Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Obx(
                    () => _buildInfoTile(
                      icon: Icons.badge,
                      title: 'User Code',
                      subtitle:
                          authController.userData.value?.userCode ?? 'N/A',
                    ),
                  ),
                  Obx(
                    () => _buildInfoTile(
                      icon: Icons.business,
                      title: 'Unit',
                      subtitle: authController.displayUnit,
                    ),
                  ),
                  Obx(
                    () => _buildInfoTile(
                      icon: Icons.work,
                      title: 'Designation',
                      subtitle: authController.displayDesignation,
                    ),
                  ),
                  Obx(
                    () => _buildInfoTile(
                      icon: Icons.apartment,
                      title: 'Department',
                      subtitle: authController.displayDepartment,
                    ),
                  ),
                  const Divider(height: 32, thickness: 1),

                  // Logout Button
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.red.shade700,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),

          // App Version
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.teal.shade700,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red.shade600, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await authController.logout();
              Get.offAll(() => LoginScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
