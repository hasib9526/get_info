import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ColorController extends GetxController {
  final _storage = GetStorage();

  // Observable for selected color index
  final selectedColorIndex = 0.obs;

  // List of 20+ beautiful colors
  final List<Map<String, dynamic>> appColors = [
    {'name': 'Teal', 'primary': const Color(0xFF00897B), 'dark': const Color(0xFF00695C)},
    {'name': 'Blue', 'primary': const Color(0xFF1976D2), 'dark': const Color(0xFF0D47A1)},
    {'name': 'Indigo', 'primary': const Color(0xFF303F9F), 'dark': const Color(0xFF1A237E)},
    {'name': 'Purple', 'primary': const Color(0xFF7B1FA2), 'dark': const Color(0xFF4A148C)},
    {'name': 'Deep Purple', 'primary': const Color(0xFF512DA8), 'dark': const Color(0xFF311B92)},
    {'name': 'Cyan', 'primary': const Color(0xFF0097A7), 'dark': const Color(0xFF00838F)},
    {'name': 'Light Blue', 'primary': const Color(0xFF0288D1), 'dark': const Color(0xFF01579B)},
    {'name': 'Green', 'primary': const Color(0xFF388E3C), 'dark': const Color(0xFF1B5E20)},
    {'name': 'Light Green', 'primary': const Color(0xFF689F38), 'dark': const Color(0xFF33691E)},
    {'name': 'Lime', 'primary': const Color(0xFFAFB42B), 'dark': const Color(0xFF827717)},
    {'name': 'Amber', 'primary': const Color(0xFFFFA000), 'dark': const Color(0xFFFF6F00)},
    {'name': 'Orange', 'primary': const Color(0xFFF57C00), 'dark': const Color(0xFFE65100)},
    {'name': 'Deep Orange', 'primary': const Color(0xFFE64A19), 'dark': const Color(0xFFBF360C)},
    {'name': 'Brown', 'primary': const Color(0xFF5D4037), 'dark': const Color(0xFF3E2723)},
    {'name': 'Blue Grey', 'primary': const Color(0xFF455A64), 'dark': const Color(0xFF263238)},
    {'name': 'Pink', 'primary': const Color(0xFFC2185B), 'dark': const Color(0xFF880E4F)},
    {'name': 'Red', 'primary': const Color(0xFFD32F2F), 'dark': const Color(0xFFB71C1C)},
    {'name': 'Rose', 'primary': const Color(0xFFAD1457), 'dark': const Color(0xFF880E4F)},
    {'name': 'Violet', 'primary': const Color(0xFF6A1B9A), 'dark': const Color(0xFF4A148C)},
    {'name': 'Navy', 'primary': const Color(0xFF1565C0), 'dark': const Color(0xFF0D47A1)},
    {'name': 'Emerald', 'primary': const Color(0xFF00796B), 'dark': const Color(0xFF004D40)},
    {'name': 'Crimson', 'primary': const Color(0xFFC62828), 'dark': const Color(0xFF8E0000)},
    {'name': 'Maroon', 'primary': const Color(0xFF6D1B7B), 'dark': const Color(0xFF38006B)},
    {'name': 'Slate', 'primary': const Color(0xFF37474F), 'dark': const Color(0xFF1C313A)},
  ];

  @override
  void onInit() {
    super.onInit();
    // Load saved color from storage
    final savedIndex = _storage.read('selectedColorIndex');
    if (savedIndex != null) {
      selectedColorIndex.value = savedIndex;
    }
  }

  // Get current primary color
  Color get primaryColor => appColors[selectedColorIndex.value]['primary'];

  // Get current dark color
  Color get darkColor => appColors[selectedColorIndex.value]['dark'];

  // Get light version of current color
  Color get lightColor => primaryColor.withOpacity(0.1);

  // Change color
  void changeColor(int index) {
    selectedColorIndex.value = index;
    _storage.write('selectedColorIndex', index);
  }
}
