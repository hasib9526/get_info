import 'child_model.dart';
import 'spouse_model.dart';
import '../config/api_config.dart';

class EmployeeModel {
  String company;
  String employeeId;
  String employeeName;
  String maritalStatus;
  SpouseModel? spouse;
  List<ChildModel> children;
  String gender;
  String presentAddress;
  String permanentAddress;
  String education;

  EmployeeModel({
    this.company = '',
    this.employeeId = '',
    this.employeeName = '',
    this.maritalStatus = '',
    this.spouse,
    this.children = const [],
    this.gender = '',
    this.presentAddress = '',
    this.permanentAddress = '',
    this.education = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'maritalStatus': maritalStatus,
      'spouse': spouse?.toJson(),
      'children': children.map((child) => child.toJson()).toList(),
      'gender': gender,
      'presentAddress': presentAddress,
      'permanentAddress': permanentAddress,
      'education': education,
    };
  }

  // API format with PascalCase keys and flattened spouse data
  Map<String, dynamic> toApiJson({
    required String addedBy,
    required String dateAdded,
  }) {
    final Map<String, dynamic> apiData = {
      'EmployeeID': employeeId,
      'Factory': ApiConfig.getFactoryCode(company),
      'Name': employeeName, // Employee Name field added
      'MaritalStatus': maritalStatus,
      'Gender': gender,
      'PresentAddress': presentAddress,
      'PermanentAddress': permanentAddress,
      'Education': education,
      'IsMobileUser': true,
      'AddedBy': addedBy,
      'DateAdded': dateAdded,
      'TotalNoofChildred': children.length,
    };

    // Add spouse information if married (send null for empty values)
    if (spouse != null) {
      apiData['SpouseName'] = spouse!.name.trim().isEmpty ? null : spouse!.name;
      apiData['SpouseOccupation'] = spouse!.occupation.trim().isEmpty ? null : spouse!.occupation;
      apiData['SpouseEducation'] = spouse!.education.trim().isEmpty ? null : spouse!.education;
      final formattedDate = spouse!.formatDateForApi(spouse!.dateOfBirth);
      apiData['SpouseDOB'] = formattedDate.isEmpty ? null : formattedDate;
    } else {
      apiData['SpouseName'] = null;
      apiData['SpouseOccupation'] = null;
      apiData['SpouseEducation'] = null;
      apiData['SpouseDOB'] = null;
    }

    // Add children information
    if (children.isNotEmpty) {
      apiData['Childs'] = children.map((child) => child.toApiJson()).toList();
    } else {
      apiData['Childs'] = [];
    }

    return apiData;
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      company: json['company'] ?? '',
      employeeId: json['employeeId'] ?? '',
      employeeName: json['employeeName'] ?? '',
      maritalStatus: json['maritalStatus'] ?? '',
      spouse: json['spouse'] != null
          ? SpouseModel.fromJson(json['spouse'])
          : null,
      children: json['children'] != null
          ? (json['children'] as List)
              .map((child) => ChildModel.fromJson(child))
              .toList()
          : [],
      gender: json['gender'] ?? '',
      presentAddress: json['presentAddress'] ?? '',
      permanentAddress: json['permanentAddress'] ?? '',
      education: json['education'] ?? '',
    );
  }

  EmployeeModel copyWith({
    String? company,
    String? employeeId,
    String? employeeName,
    String? maritalStatus,
    SpouseModel? spouse,
    List<ChildModel>? children,
    String? gender,
    String? presentAddress,
    String? permanentAddress,
    String? education,
  }) {
    return EmployeeModel(
      company: company ?? this.company,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      spouse: spouse ?? this.spouse,
      children: children ?? this.children,
      gender: gender ?? this.gender,
      presentAddress: presentAddress ?? this.presentAddress,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      education: education ?? this.education,
    );
  }
}
