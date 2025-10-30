import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/employee_model.dart';
import '../models/spouse_model.dart';
import '../models/child_model.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';
import '../config/api_config.dart';
import 'color_controller.dart';

class EmployeeController extends GetxController {
  final ApiService _apiService = ApiService();
  final SessionService _sessionService = SessionService();
  final ColorController colorController = Get.find<ColorController>();
  final formKey = GlobalKey<FormState>();

  // Companies
  final List<String> companies = ['TAL', 'RHL', 'BGL', 'MGL'];
  final selectedCompany = ''.obs;

  // Employee basic info
  final employeeIdController = TextEditingController();
  final employeeNameController = TextEditingController();
  final employeeIdFocusNode = FocusNode();

  // Marital status
  final maritalStatuses = ['Married', 'Unmarried', 'Divorced', 'Widow','Separated'];
  final selectedMaritalStatus = ''.obs;

  // Spouse info
  final spouseNameController = TextEditingController();
  final spouseOccupationController = TextEditingController();
  final spouseDobController = TextEditingController();
  final numberOfChildren = 0.obs;

  // Employee info
  final List<String> genders = [
    'Male',
    'Female',
    'Transgender',
    'Non-binary',
    'Others'
  ];
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

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to number of children changes
    numberOfChildren.listen((count) {
      updateChildrenForms(count);
    });

    // Listen to marital status changes
    selectedMaritalStatus.listen((status) {
      if (status == 'Unmarried') {
        // Clear spouse and children information only when unmarried
        spouseNameController.clear();
        spouseOccupationController.clear();
        spouseDobController.clear();
        numberOfChildren.value = 0;
      }
    });

    // Listen to employee ID focus changes
    employeeIdFocusNode.addListener(() {
      if (!employeeIdFocusNode.hasFocus) {
        // When focus is lost, fetch employee name if ID is not empty
        final employeeId = employeeIdController.text.trim();
        if (employeeId.isNotEmpty && selectedCompany.value.isNotEmpty) {
          fetchEmployeeName(employeeId);
        }
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
    employeeIdFocusNode.dispose();
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

  // Fetch employee name by ID using API
  Future<void> fetchEmployeeName(String employeeId) async {
    if (employeeId.isEmpty || selectedCompany.value.isEmpty) return;

    try {
      // Get factory code from selected company
      final factoryCode = ApiConfig.getFactoryCode(selectedCompany.value);

      // Call API to get employee name
      final employeeName = await _apiService.getEmployee(
        employeeId: employeeId,
        factory: factoryCode,
      );

      if (employeeName != null && employeeName.isNotEmpty) {
        employeeNameController.text = employeeName;
      } else {
        employeeNameController.text = '';
        Get.snackbar(
          'Not Found',
          'Employee not found with ID: $employeeId',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
        );
      }
    } catch (e) {
      print('Error fetching employee name: $e');
      Get.snackbar(
        'Not Found',
        'Employee not found with ID: $employeeId',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
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

  Future<void> saveEmployee() async {
    if (!validateForm()) return;

    // Start loading
    isLoading.value = true;

    try {
      // Create spouse model if not unmarried (for Married, Divorced, Widow, Separated)
      SpouseModel? spouse;
      if (selectedMaritalStatus.value.isNotEmpty &&
          selectedMaritalStatus.value != 'Unmarried') {

        // Check if any spouse field has data
        bool hasSpouseData = spouseNameController.text.trim().isNotEmpty ||
                             spouseOccupationController.text.trim().isNotEmpty ||
                             spouseDobController.text.trim().isNotEmpty;

        // Only create spouse model if at least one field is filled
        // OR if marital status is Married (required)
        if (hasSpouseData || selectedMaritalStatus.value == 'Married') {
          spouse = SpouseModel(
            name: spouseNameController.text,
            occupation: spouseOccupationController.text,
            dateOfBirth: spouseDobController.text,
            numberOfChildren: numberOfChildren.value,
            education: '', // Spouse education not collected in UI, default to empty
          );
        }
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

      // Get AddedBy field - using Employee Name instead of logged-in user
      // Uncomment below lines to use logged-in user name again:
      // final addedBy = await _sessionService.getEmployeeName() ??
      //                 await _sessionService.getUserName() ??
      //                 'Unknown';

      // Using employee name from form as AddedBy
      final addedBy = employeeNameController.text.trim().isNotEmpty
                      ? employeeNameController.text.trim()
                      : 'Unknown';

      // Call API to save employee data
      final success = await _apiService.saveToBIS(
        employee: employee,
        addedBy: addedBy,
      );

      if (success) {
        // Save employee to local list
        savedEmployees.add(employee);
        totalEntries.value++;

        // Show success message in center
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: colorController.primaryColor, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Success',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: const Text(
              'Employee information saved successfully!',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorController.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'OK',
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

        // Reset form but keep company selected
        resetForm();
      }
    } catch (e) {
      print('Error saving employee: $e');
      Get.snackbar(
        'Error',
        'Failed to save employee information. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
      );
    } finally {
      // Stop loading
      isLoading.value = false;
    }
  }

  void resetForm() {
    final currentCompany = selectedCompany.value;
    final currentEmployeeId = employeeIdController.text;
    final currentEmployeeName = employeeNameController.text;

    // Reset reactive variables (except company)
    selectedMaritalStatus.value = '';
    numberOfChildren.value = 0;
    selectedGender.value = '';

    // Clear children controllers
    for (var controllers in childrenControllers) {
      controllers['dob']?.dispose();
      controllers['education']?.dispose();
    }
    childrenControllers.clear();
    childrenGenders.clear();

    // Clear text controllers (except employee ID and name)
    spouseNameController.clear();
    spouseOccupationController.clear();
    spouseDobController.clear();
    presentAddressController.clear();
    permanentAddressController.clear();
    educationController.clear();

    // Keep company, employee ID and name
    selectedCompany.value = currentCompany;
    employeeIdController.text = currentEmployeeId;
    employeeNameController.text = currentEmployeeName;
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
