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

  // API format with PascalCase keys
  Map<String, dynamic> toApiJson() {
    return {
      'DOB': _formatDateForApi(dateOfBirth),
      'Education': education,
      'Gender': gender,
    };
  }

  // Helper method to format date to ISO 8601 format
  String _formatDateForApi(String dateString) {
    if (dateString.isEmpty) return '';

    try {
      // Parse DD/MM/YYYY format
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$year-$month-${day}T00:00:00';
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
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
