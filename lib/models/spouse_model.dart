class SpouseModel {
  String name;
  String occupation;
  String dateOfBirth;
  int numberOfChildren;
  String education;

  SpouseModel({
    this.name = '',
    this.occupation = '',
    this.dateOfBirth = '',
    this.numberOfChildren = 0,
    this.education = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'occupation': occupation,
      'dateOfBirth': dateOfBirth,
      'numberOfChildren': numberOfChildren,
      'education': education,
    };
  }

  // Helper method to format date to ISO 8601 format
  String formatDateForApi(String dateString) {
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

  factory SpouseModel.fromJson(Map<String, dynamic> json) {
    return SpouseModel(
      name: json['name'] ?? '',
      occupation: json['occupation'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      numberOfChildren: json['numberOfChildren'] ?? 0,
      education: json['education'] ?? '',
    );
  }

  SpouseModel copyWith({
    String? name,
    String? occupation,
    String? dateOfBirth,
    int? numberOfChildren,
    String? education,
  }) {
    return SpouseModel(
      name: name ?? this.name,
      occupation: occupation ?? this.occupation,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      numberOfChildren: numberOfChildren ?? this.numberOfChildren,
      education: education ?? this.education,
    );
  }
}
