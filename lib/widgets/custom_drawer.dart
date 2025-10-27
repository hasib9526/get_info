import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/color_controller.dart';
import '../views/login_screen.dart';

class CustomDrawer extends StatelessWidget {
  final AuthController authController;
  final ColorController colorController = Get.find<ColorController>();

  CustomDrawer({
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

              return Obx(
                () => UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorController.darkColor, colorController.primaryColor],
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
                                  color: colorController.primaryColor,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 50,
                            color: colorController.primaryColor,
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


                  // Color Selector Section
                  _buildColorSelector(),



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
    return Obx(
      () => ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorController.lightColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: colorController.primaryColor,
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
      ),
    );
  }

  Widget _buildColorSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: colorController.lightColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorController.primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Theme(
            data: ThemeData(
              splashColor: colorController.primaryColor.withOpacity(0.1),
              highlightColor: colorController.primaryColor.withOpacity(0.05),
            ),
            child: ExpansionTile(
              leading: Icon(
                Icons.palette,
                color: colorController.primaryColor,
                size: 20,
              ),
              title: Text(
                'Theme Color',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorController.primaryColor,
                ),
              ),
              subtitle: Text(
                colorController.appColors[colorController.selectedColorIndex.value]['name'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              trailing: Icon(
                Icons.arrow_drop_down,
                color: colorController.primaryColor,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: colorController.appColors.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => GestureDetector(
                          onTap: () => colorController.changeColor(index),
                          child: Tooltip(
                            message: colorController.appColors[index]['name'],
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorController.appColors[index]['primary'],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorController.selectedColorIndex.value == index
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  if (colorController.selectedColorIndex.value == index)
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: colorController.selectedColorIndex.value == index
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
