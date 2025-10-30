import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/employee_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/color_controller.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_text_field.dart';

class EmployeeFormScreen extends StatelessWidget {
  EmployeeFormScreen({super.key});

  final EmployeeController controller = Get.put(EmployeeController());
  final AuthController authController = Get.find<AuthController>();
  final ColorController colorController = Get.find<ColorController>();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
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
                colors: [colorController.darkColor, colorController.primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        // actions: [
        //   Obx(
        //     () => Container(
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //       margin: const EdgeInsets.only(right: 16),
        //       decoration: BoxDecoration(
        //         color: Colors.white.withOpacity(0.2),
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //       child: Row(
        //         children: [
        //           const Icon(
        //             Icons.people,
        //             color: Colors.white,
        //             size: 20,
        //           ),
        //           const SizedBox(width: 6),
        //           Text(
        //             'Total: ${controller.totalEntries.value}',
        //             style: const TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.bold,
        //               fontSize: 14,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ],
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
                Icon(Icons.business, color: colorController.darkColor),
                const SizedBox(width: 8),
                Text(
                  'Select Company',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorController.darkColor,
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
                    selectedColor: colorController.darkColor,
                    backgroundColor: Colors.grey.shade200,
                    checkmarkColor: Colors.white,
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
                Icon(Icons.badge, color: colorController.darkColor),
                const SizedBox(width: 8),
                Text(
                  'Employee Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorController.darkColor
                  ),
                ),
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: controller.employeeIdController,
              focusNode: controller.employeeIdFocusNode,
              labelText: 'Employee ID *',
              hintText: 'Enter employee ID',
              prefixIcon: Icons.numbers,
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
            CustomTextField(
              controller: controller.employeeNameController,
              labelText: 'Employee Name *',
              hintText: 'Auto-filled or enter manually',
              prefixIcon: Icons.person,
              fillColor: Colors.blue.shade50,
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
                Icon(Icons.favorite, color: colorController.darkColor),
                const SizedBox(width: 8),
                 Text(
                  'Marital Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorController.darkColor
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
                    selectedColor: colorController.darkColor,
                    backgroundColor: Colors.grey.shade200,
                    checkmarkColor: Colors.white,
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
                Icon(Icons.people_alt, color: colorController.darkColor),
                const SizedBox(width: 8),
                Obx(
                  () => Text(
                    controller.selectedMaritalStatus.value == 'Married'
                        ? 'Spouse Information'
                        : 'Spouse Information (Optional)',
                    style:  TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorController.darkColor
                    ),
                  ),

                ),
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomTextField(
                controller: controller.spouseNameController,
                labelText: controller.selectedMaritalStatus.value == 'Married'
                    ? 'Spouse Name *'
                    : 'Spouse Name',
                prefixIcon: Icons.person_outline,
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
              () => CustomTextField(
                controller: controller.spouseOccupationController,
                labelText: controller.selectedMaritalStatus.value == 'Married'
                    ? 'Spouse Occupation *'
                    : 'Spouse Occupation',
                prefixIcon: Icons.work_outline,
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
              () => CustomTextField(
                controller: controller.spouseDobController,
                labelText: controller.selectedMaritalStatus.value == 'Married'
                    ? 'Spouse Date of Birth *'
                    : 'Spouse Date of Birth',
                hintText: 'DD/MM/YYYY',
                prefixIcon: Icons.calendar_today,
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
            CustomTextField(
              labelText: 'Number of Children *',
              hintText: '0-99',
              prefixIcon: Icons.child_care,
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
                        Icon(Icons.child_care_outlined,
                            color:colorController.darkColor),
                        const SizedBox(width: 8),
                        Text(
                          'Child ${index + 1} Information',
                          style:  TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorController.darkColor
                          ),
                        ),
                        const Text(
                          ' *',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: controller.childrenControllers[index]['dob'],
                      labelText: 'Date of Birth *',
                      hintText: 'DD/MM/YYYY',
                      prefixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(
                          controller.childrenControllers[index]['dob']!),
                      validator: (value) =>
                          controller.validateRequired(value, 'Date of Birth'),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.childrenEducations[index].isEmpty
                            ? null
                            : controller.childrenEducations[index],
                        decoration: InputDecoration(
                          labelText: 'Education *',
                          prefixIcon: Icon(Icons.school, color: colorController.primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        hint: const Text('Select education level'),
                        items: controller.childEducationOptions.map((education) {
                          return DropdownMenuItem<String>(
                            value: education,
                            child: Text(education),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.updateChildEducation(index, value);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select education';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: 'Gender ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
                                checkmarkColor: Colors.white,
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
                Icon(Icons.info_outline, color: colorController.darkColor),
                const SizedBox(width: 8),
                Text(
                  'Employee Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorController.darkColor
                  ),
                ),
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'Gender ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ],
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
                        checkmarkColor: Colors.white,
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
            CustomTextField(
              controller: controller.presentAddressController,
              labelText: 'Present Address *',
              hintText: 'Enter your present address',
              prefixIcon: Icons.home,
              validator: (value) =>
                  controller.validateRequired(value, 'Present Address'),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: controller.permanentAddressController,
              labelText: 'Permanent Address *',
              hintText: 'Enter your permanent address',
              prefixIcon: Icons.location_on,
              validator: (value) =>
                  controller.validateRequired(value, 'Permanent Address'),
            ),
            const SizedBox(height: 12),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.selectedEducation.value.isEmpty
                    ? null
                    : controller.selectedEducation.value,
                decoration: InputDecoration(
                  labelText: 'Education *',
                  prefixIcon: Icon(Icons.school, color: colorController.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                hint: const Text('Select education level'),
                items: controller.employeeEducationOptions.map((education) {
                  return DropdownMenuItem<String>(
                    value: education,
                    child: Text(education),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedEducation.value = value;
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select education';
                  }
                  return null;
                },
              ),
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
          backgroundColor: colorController.primaryColor,
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
            Icon(Icons.info_outline, color: colorController.primaryColor, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Confirm Employee Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Please verify the information before saving:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoSection('Company & Employee', [
                  _buildInfoRow('Company', controller.selectedCompany.value),
                  _buildInfoRow('Employee ID', controller.employeeIdController.text),
                  _buildInfoRow('Employee Name', controller.employeeNameController.text),
                ]),
                const Divider(height: 24),
                _buildInfoSection('Personal Details', [
                  _buildInfoRow('Marital Status', controller.selectedMaritalStatus.value),
                  _buildInfoRow('Gender', controller.selectedGender.value),
                  _buildInfoRow('Present Address', controller.presentAddressController.text),
                  _buildInfoRow('Permanent Address', controller.permanentAddressController.text),
                  _buildInfoRow('Education', controller.selectedEducation.value),
                ]),
                if (controller.selectedMaritalStatus.value.isNotEmpty &&
                    controller.selectedMaritalStatus.value != 'Unmarried') ...[
                  const Divider(height: 24),
                  _buildInfoSection('Spouse Information', [
                    _buildInfoRow('Spouse Name',
                        controller.spouseNameController.text.isEmpty
                            ? 'Not provided'
                            : controller.spouseNameController.text),
                    _buildInfoRow('Spouse Occupation',
                        controller.spouseOccupationController.text.isEmpty
                            ? 'Not provided'
                            : controller.spouseOccupationController.text),
                    _buildInfoRow('Spouse DOB',
                        controller.spouseDobController.text.isEmpty
                            ? 'Not provided'
                            : controller.spouseDobController.text),
                    _buildInfoRow('Number of Children',
                        controller.numberOfChildren.value.toString()),
                  ]),
                ],
                if (controller.numberOfChildren.value > 0) ...[
                  const Divider(height: 24),
                  _buildInfoSection('Children Information',
                      List.generate(controller.numberOfChildren.value, (index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index > 0) const SizedBox(height: 12),
                            Text(
                              'Child ${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorController.darkColor,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildInfoRow('Date of Birth',
                                controller.childrenControllers[index]['dob']!.text),
                            _buildInfoRow('Education',
                                controller.childrenEducations[index]),
                            _buildInfoRow('Gender',
                                controller.childrenGenders[index]),
                          ],
                        );
                      }),
                  ),
                ],
              ],
            ),
          ),
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
              backgroundColor: colorController.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Confirm & Save',
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

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: colorController.darkColor,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final displayValue = value.trim().isEmpty ? 'Not provided' : value;
    final isNotProvided = value.trim().isEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: TextStyle(
                fontSize: 13,
                color: isNotProvided ? Colors.grey.shade500 : Colors.black87,
                fontStyle: isNotProvided ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
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
              primary: colorController.darkColor,
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
        return colorController.darkColor;
      case 'Female':
        return colorController.darkColor;
      case 'Transgender':
        return colorController.darkColor;
      case 'Non-binary':
        return colorController.darkColor;
      case 'Others':
        return colorController.darkColor;
      default:
        return colorController.darkColor;
    }
  }
}
