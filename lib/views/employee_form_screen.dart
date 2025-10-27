import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/employee_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_drawer.dart';

class EmployeeFormScreen extends StatelessWidget {
  EmployeeFormScreen({super.key});

  final EmployeeController controller = Get.put(EmployeeController());
  final AuthController authController = Get.find<AuthController>();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: CustomDrawer(authController: authController),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Employee Information Entry',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 45,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade700, Colors.teal.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Total: ${controller.totalEntries.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside text fields
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    _buildCompanySelectionCard(),
                    const SizedBox(height: 10),
                    _buildEmployeeInfoCard(),
                    const SizedBox(height: 10),
                    _buildEmployeeDetailsCard(),
                    const SizedBox(height: 10),
                    _buildMaritalStatusCard(),
                    const SizedBox(height: 10),
                    Obx(() => controller.selectedMaritalStatus.value.isNotEmpty &&
                            controller.selectedMaritalStatus.value != 'Unmarried'
                        ? _buildSpouseInfoCard()
                        : const SizedBox.shrink()),
                    const SizedBox(height: 10),
                    Obx(() => controller.selectedMaritalStatus.value.isNotEmpty &&
                            controller.selectedMaritalStatus.value != 'Unmarried' &&
                            controller.numberOfChildren.value > 0
                        ? _buildChildrenFormsCard()
                        : const SizedBox.shrink()),

                     const SizedBox(height:2),
                    _buildSaveButton(),
                    const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanySelectionCard() {
    return Card(
      elevation: 2,color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Select Company',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.companies.map((company) {
                  final isSelected = controller.selectedCompany.value == company;
                  return ChoiceChip(
                    label: Text(
                      company,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.blue.shade600,
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (selected) {
                      controller.selectedCompany.value = company;
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeInfoCard() {
    return Card(
      elevation: 2,color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.badge, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Employee Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.employeeIdController,
              focusNode: controller.employeeIdFocusNode,
              decoration: InputDecoration(
                labelText: 'Employee ID *',
                hintText: 'Enter employee ID',
                prefixIcon: const Icon(Icons.numbers),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              validator: controller.validateEmployeeId,
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  controller.fetchEmployeeName(value);
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.employeeNameController,
              decoration: InputDecoration(
                labelText: 'Employee Name *',
                hintText: 'Auto-filled or enter manually',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.blue.shade50,
              ),
              validator: (value) =>
                  controller.validateRequired(value, 'Employee Name'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaritalStatusCard() {
    return Card(
      elevation: 2,color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Marital Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.maritalStatuses.map((status) {
                  final isSelected =
                      controller.selectedMaritalStatus.value == status;
                  return ChoiceChip(
                    label: Text(
                      status,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.pink.shade400,
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (selected) {
                      controller.selectedMaritalStatus.value = status;
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpouseInfoCard() {
    return Card(
      elevation: 2,color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people_alt, color: Colors.purple.shade700),
                const SizedBox(width: 8),
                Obx(
                  () => Text(
                    controller.selectedMaritalStatus.value == 'Married'
                        ? 'Spouse Information'
                        : 'Spouse Information (Optional)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => TextFormField(
                controller: controller.spouseNameController,
                decoration: InputDecoration(
                  labelText: controller.selectedMaritalStatus.value == 'Married'
                      ? 'Spouse Name *'
                      : 'Spouse Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                validator: (value) {
                  // Required only for Married status
                  if (controller.selectedMaritalStatus.value == 'Married') {
                    return controller.validateRequired(value, 'Spouse Name');
                  }
                  return null; // Optional for Divorced/Widow/Separated
                },
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => TextFormField(
                controller: controller.spouseOccupationController,
                decoration: InputDecoration(
                  labelText: controller.selectedMaritalStatus.value == 'Married'
                      ? 'Spouse Occupation *'
                      : 'Spouse Occupation',
                  prefixIcon: const Icon(Icons.work_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                validator: (value) {
                  // Required only for Married status
                  if (controller.selectedMaritalStatus.value == 'Married') {
                    return controller.validateRequired(value, 'Spouse Occupation');
                  }
                  return null; // Optional for Divorced/Widow/Separated
                },
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => TextFormField(
                controller: controller.spouseDobController,
                decoration: InputDecoration(
                  labelText: controller.selectedMaritalStatus.value == 'Married'
                      ? 'Spouse Date of Birth *'
                      : 'Spouse Date of Birth',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  hintText: 'DD/MM/YYYY',
                ),
                readOnly: true,
                onTap: () => _selectDate(controller.spouseDobController),
                validator: (value) {
                  // Required only for Married status
                  if (controller.selectedMaritalStatus.value == 'Married') {
                    return controller.validateRequired(value, 'Spouse Date of Birth');
                  }
                  return null; // Optional for Divorced/Widow/Separated
                },
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Number of Children *',
                prefixIcon: const Icon(Icons.child_care),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                hintText: '0-99',
              ),
              keyboardType: TextInputType.number,
              maxLength: 2,
              validator: controller.validateNumberOfChildren,
              onChanged: (value) {
                final number = int.tryParse(value) ?? 0;
                controller.numberOfChildren.value = number;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenFormsCard() {
    return Obx(
      () => Column(
        children: List.generate(
          controller.numberOfChildren.value,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              elevation: 2,color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.child_friendly,
                            color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Child ${index + 1} Information',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.childrenControllers[index]['dob'],
                      decoration: InputDecoration(
                        labelText: 'Date of Birth *',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        hintText: 'DD/MM/YYYY',
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(
                          controller.childrenControllers[index]['dob']!),
                      validator: (value) =>
                          controller.validateRequired(value, 'Date of Birth'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller:
                          controller.childrenControllers[index]['education'],
                      decoration: InputDecoration(
                        labelText: 'Education *',
                        prefixIcon: const Icon(Icons.school),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      validator: (value) =>
                          controller.validateRequired(value, 'Education'),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gender *',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.genders.map((gender) {
                              return ChoiceChip(
                                label: Text(
                                  gender,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                selected:
                                    controller.childrenGenders[index] == gender,
                                selectedColor: _getGenderColor(gender),
                                backgroundColor: Colors.grey.shade200,
                                onSelected: (selected) {
                                  controller.updateChildGender(index, gender);
                                },
                                labelStyle: TextStyle(
                                  color:
                                      controller.childrenGenders[index] == gender
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeDetailsCard() {
    return Card(
      elevation: 2,color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Employee Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gender *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.genders.map((gender) {
                      return ChoiceChip(
                        label: Text(
                          gender,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        selected: controller.selectedGender.value == gender,
                        selectedColor: _getGenderColor(gender),
                        backgroundColor: Colors.grey.shade200,
                        onSelected: (selected) {
                          controller.selectedGender.value = gender;
                        },
                        labelStyle: TextStyle(
                          color: controller.selectedGender.value == gender
                              ? Colors.white
                              : Colors.black87,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.presentAddressController,
              decoration: InputDecoration(
                labelText: 'Present Address *',
                prefixIcon: const Icon(Icons.home),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              maxLines: 1,
              validator: (value) =>
                  controller.validateRequired(value, 'Present Address'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.permanentAddressController,
              decoration: InputDecoration(
                labelText: 'Permanent Address *',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              maxLines: 1,
              validator: (value) =>
                  controller.validateRequired(value, 'Permanent Address'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.educationController,
              decoration: InputDecoration(
                labelText: 'Education *',
                prefixIcon: const Icon(Icons.school),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) =>
                  controller.validateRequired(value, 'Education'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : _showSaveConfirmationDialog,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.teal.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: controller.isLoading.value
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'SAVING...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'SAVE EMPLOYEE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showSaveConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue.shade600, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Confirm Save',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to save this employee information?',
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
              Get.back();
              await controller.saveEmployee();
              // Scroll to top after successful save
              if (scrollController.hasClients) {
                scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Confirm',
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

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade600,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Color _getGenderColor(String gender) {
    switch (gender) {
      case 'Male':
        return Colors.blue.shade400;
      case 'Female':
        return Colors.pink.shade400;
      case 'Transgender':
        return Colors.purple.shade400;
      case 'Non-binary':
        return Colors.teal.shade400;
      case 'Others':
        return Colors.orange.shade400;
      default:
        return Colors.grey.shade400;
    }
  }
}
