class ChildModel {
  String dateOfBirth;
  String education;
  String gender;

  ChildModel({
    this.dateOfBirth = '',
    this.education = '',
    this.gender = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'dateOfBirth': dateOfBirth,
      'education': education,
      'gender': gender,
    };
  }

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      dateOfBirth: json['dateOfBirth'] ?? '',
      education: json['education'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  ChildModel copyWith({
    String? dateOfBirth,
    String? education,
    String? gender,
  }) {
    return ChildModel(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      education: education ?? this.education,
      gender: gender ?? this.gender,
    );
  }
}
