import 'dart:typed_data';

class UserHistory {
  final String id;
  final String name;
  final String email;
  final String specialization;
  final Uint8List? avatar;
  final double? salary;
  final double? experience;
  final int status;

  UserHistory({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    this.avatar,
    this.salary,
    this.experience,
    required this.status,
  });

  factory UserHistory.fromJson(Map<String, dynamic> json) {
    Uint8List? convertAvatar(List<dynamic>? avatarData) {
      if (avatarData == null) {
        return null;
      }
      List<int> avatarBytes = avatarData.cast<int>();
      return Uint8List.fromList(avatarBytes);
    }

    return UserHistory(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      specialization: json['specialization'] as String,
      avatar: convertAvatar(json['avatar']?['data'] as List<dynamic>?),
      salary: json['salary'] as double?,
      experience: json['experience'] as double?,
      status: json['status'] as int,
    );
  }
}
