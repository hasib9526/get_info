class SpouseModel {
  String name;
  String occupation;
  String dateOfBirth;
  int numberOfChildren;

  SpouseModel({
    this.name = '',
    this.occupation = '',
    this.dateOfBirth = '',
    this.numberOfChildren = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'occupation': occupation,
      'dateOfBirth': dateOfBirth,
      'numberOfChildren': numberOfChildren,
    };
  }

  factory SpouseModel.fromJson(Map<String, dynamic> json) {
    return SpouseModel(
      name: json['name'] ?? '',
      occupation: json['occupation'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      numberOfChildren: json['numberOfChildren'] ?? 0,
    );
  }

  SpouseModel copyWith({
    String? name,
    String? occupation,
    String? dateOfBirth,
    int? numberOfChildren,
  }) {
    return SpouseModel(
      name: name ?? this.name,
      occupation: occupation ?? this.occupation,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      numberOfChildren: numberOfChildren ?? this.numberOfChildren,
    );
  }
}
