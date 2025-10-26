import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/employee_model.dart';
import '../models/spouse_model.dart';
import '../models/child_model.dart';

class EmployeeController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Companies
  final List<String> companies = ['TAL', 'RHL', 'BGL', 'MGL'];
  final selectedCompany = ''.obs;

  // Employee basic info
  final employeeIdController = TextEditingController();
  final employeeNameController = TextEditingController();

  // Marital status
  final maritalStatuses = ['Married', 'Unmarried', 'Divorced', 'Widow','Separated'];
  final selectedMaritalStatus = ''.obs;

  // Spouse info
  final spouseNameController = TextEditingController();
  final spouseOccupationController = TextEditingController();
  final spouseDobController = TextEditingController();
  final numberOfChildren = 0.obs;

  // Employee info
  final selectedGender = ''.obs;
  final presentAddressController = TextEditingController();
  final permanentAddressController = TextEditingController();
  final educationController = TextEditingController();

  // Children info
  final RxList<Map<String, TextEditingController>> childrenControllers =
      <Map<String, TextEditingController>>[].obs;
  final RxList<String> childrenGenders = <String>[].obs;

  // Counter for total entries
  final totalEntries = 0.obs;

  // Saved employees list
  final RxList<EmployeeModel> savedEmployees = <EmployeeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to number of children changes
    numberOfChildren.listen((count) {
      updateChildrenForms(count);
    });

    // Listen to marital status changes
    selectedMaritalStatus.listen((status) {
      if (status != 'Married') {
        // Clear spouse and children information when not married
        spouseNameController.clear();
        spouseOccupationController.clear();
        spouseDobController.clear();
        numberOfChildren.value = 0;
      }
    });
  }

  @override
  void onClose() {
    disposeControllers();
    super.onClose();
  }

  void disposeControllers() {
    employeeIdController.dispose();
    employeeNameController.dispose();
    spouseNameController.dispose();
    spouseOccupationController.dispose();
    spouseDobController.dispose();
    presentAddressController.dispose();
    permanentAddressController.dispose();
    educationController.dispose();

    for (var controllers in childrenControllers) {
      controllers['dob']?.dispose();
      controllers['education']?.dispose();
    }
  }

  // Mock function to fetch employee name by ID
  Future<void> fetchEmployeeName(String employeeId) async {
    if (employeeId.isEmpty || selectedCompany.value.isEmpty) return;

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - replace with actual API call later
    final mockNames = {
      '001': 'John Doe',
      '002': 'Jane Smith',
      '003': 'Michael Johnson',
      '004': 'Sarah Williams',
      '005': 'David Brown',
    };

    employeeNameController.text = mockNames[employeeId] ?? 'Employee $employeeId';
  }

  void updateChildrenForms(int count) {
    // Clear existing controllers
    for (var controllers in childrenControllers) {
      controllers['dob']?.dispose();
      controllers['education']?.dispose();
    }

    childrenControllers.clear();
    childrenGenders.clear();

    // Create new controllers for each child
    for (int i = 0; i < count; i++) {
      childrenControllers.add({
        'dob': TextEditingController(),
        'education': TextEditingController(),
      });
      childrenGenders.add('');
    }
  }

  void updateChildGender(int index, String gender) {
    childrenGenders[index] = gender;
  }

  bool validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      // Additional validation for selected fields
      if (selectedCompany.value.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please select a company',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return false;
      }

      if (selectedMaritalStatus.value.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please select marital status',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return false;
      }

      if (selectedGender.value.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please select gender',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return false;
      }

      // Validate children genders if married with children
      if (selectedMaritalStatus.value == 'Married' && numberOfChildren.value > 0) {
        for (int i = 0; i < childrenGenders.length; i++) {
          if (childrenGenders[i].isEmpty) {
            Get.snackbar(
              'Validation Error',
              'Please select gender for Child ${i + 1}',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade100,
              colorText: Colors.red.shade900,
            );
            return false;
          }
        }
      }

      return true;
    }
    return false;
  }

  void saveEmployee() {
    if (!validateForm()) return;

    // Create spouse model if married
    SpouseModel? spouse;
    if (selectedMaritalStatus.value == 'Married') {
      spouse = SpouseModel(
        name: spouseNameController.text,
        occupation: spouseOccupationController.text,
        dateOfBirth: spouseDobController.text,
        numberOfChildren: numberOfChildren.value,
      );
    }

    // Create children models
    List<ChildModel> children = [];
    for (int i = 0; i < childrenControllers.length; i++) {
      children.add(ChildModel(
        dateOfBirth: childrenControllers[i]['dob']!.text,
        education: childrenControllers[i]['education']!.text,
        gender: childrenGenders[i],
      ));
    }

    // Create employee model
    final employee = EmployeeModel(
      company: selectedCompany.value,
      employeeId: employeeIdController.text,
      employeeName: employeeNameController.text,
      maritalStatus: selectedMaritalStatus.value,
      spouse: spouse,
      children: children,
      gender: selectedGender.value,
      presentAddress: presentAddressController.text,
      permanentAddress: permanentAddressController.text,
      education: educationController.text,
    );

    // Save employee
    savedEmployees.add(employee);
    totalEntries.value++;

    // Show success message
    Get.snackbar(
      'Success',
      'Employee information saved successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal.shade100,
      colorText: Colors.teal.shade900,
      duration: const Duration(seconds: 2),
    );

    // Reset form but keep company selected
    resetForm();
  }

  void resetForm() {
    final currentCompany = selectedCompany.value;

    // Clear text controllers
    employeeIdController.clear();
    employeeNameController.clear();
    spouseNameController.clear();
    spouseOccupationController.clear();
    spouseDobController.clear();
    presentAddressController.clear();
    permanentAddressController.clear();
    educationController.clear();

    // Clear children controllers
    for (var controllers in childrenControllers) {
      controllers['dob']?.dispose();
      controllers['education']?.dispose();
    }
    childrenControllers.clear();
    childrenGenders.clear();

    // Reset reactive variables (except company)
    selectedMaritalStatus.value = '';
    numberOfChildren.value = 0;
    selectedGender.value = '';

    // Keep company selected
    selectedCompany.value = currentCompany;

    // Reset form key
    formKey.currentState?.reset();
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validateEmployeeId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Employee ID is required';
    }
    return null;
  }

  String? validateNumberOfChildren(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Number of children is required';
    }
    final number = int.tryParse(value);
    if (number == null || number < 0) {
      return 'Please enter a valid number';
    }
    if (number > 99) {
      return 'Maximum 99 children allowed';
    }
    return null;
  }
}
