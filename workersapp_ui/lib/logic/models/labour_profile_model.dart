class LabourProfileModel {
  final String id;
  final String name;
  final String email;
  final int phoneNo;
  final String specialization;
  final int experience;
  final String workerJobId;
  final int salary;

  LabourProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.specialization,
    required this.experience,
    required this.workerJobId,
    required this.salary,
  });

  factory LabourProfileModel.fromJson(Map<String, dynamic> json) {
    return LabourProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNo: json['phoneN'] as int? ?? 0,
      specialization: json['specialization'] as String? ?? '',
      experience: json['experience'] as int? ?? 0,
      workerJobId: json['workerJobId'] as String? ?? '',
      salary: json['salary'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phoneN': phoneNo,
        'specialization': specialization,
        'experience': experience,
        'workerJobId': workerJobId,
        'salary': salary,
      };
}
