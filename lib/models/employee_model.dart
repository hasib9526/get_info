import 'child_model.dart';
import 'spouse_model.dart';

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
