class LoginResponse {
  final String? userCode;
  final String? userName;
  final String? employeeName;
  final String? email;
  final String? unit;
  final String? department;
  final String? designation;
  final String? empImage;
  final String? leaveApproval;
  final String? leaveRecommend;
  final int? versionCode;
  final bool? isOtpSend;
  final bool? isAutoUser;
  final String? comId;
  final List<dynamic>? approvalList;

  const LoginResponse({
    this.userCode,
    this.userName,
    this.employeeName,
    this.email,
    this.unit,
    this.department,
    this.designation,
    this.empImage,
    this.leaveApproval,
    this.leaveRecommend,
    this.versionCode,
    this.isOtpSend,
    this.isAutoUser,
    this.comId,
    this.approvalList,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userCode: json['UserCode'] as String?,
      userName: json['UserName'] as String?,
      employeeName: json['EmployeeName'] as String?,
      email: json['Email'] as String?,
      unit: json['Unit'] as String?,
      department: json['Department'] as String?,
      designation: json['Designation'] as String?,
      empImage: json['EmpImage'] as String?,
      leaveApproval: json['LeaveApproval'] as String?,
      leaveRecommend: json['LeaveRecommend'] as String?,
      versionCode: json['VersionCode'] as int?,
      isOtpSend: json['isOtpSend'] as bool?,
      isAutoUser: json['IsAutoUser'] as bool?,
      comId: json['ComID'] as String?,
      approvalList: json['ApprovalList'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserCode': userCode,
      'UserName': userName,
      'EmployeeName': employeeName,
      'Email': email,
      'Unit': unit,
      'Department': department,
      'Designation': designation,
      'EmpImage': empImage,
      'LeaveApproval': leaveApproval,
      'LeaveRecommend': leaveRecommend,
      'VersionCode': versionCode,
      'isOtpSend': isOtpSend,
      'IsAutoUser': isAutoUser,
      'ComID': comId,
      'ApprovalList': approvalList,
    };
  }
}
