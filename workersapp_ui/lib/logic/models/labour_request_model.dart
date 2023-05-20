import 'dart:convert';
import 'dart:typed_data';

class LabourRequestModel {
  late final UserModel user;
  final int status;

  LabourRequestModel({
    required this.user,
    required this.status,
  });

  factory LabourRequestModel.fromJson(Map<String, dynamic> json) {
    return LabourRequestModel(
      user: UserModel.fromJson(json['user']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'status': status,
      };
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final int phoneNo;
  final String street;
  final String address;
  final Uint8List avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.street,
    required this.address,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phoneNo: json['phoneNo'],
      street: json['street'],
      address: json['address'],
      avatar: base64Decode(json['avatar']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'phoneNo': phoneNo,
        'street': street,
        'address': address,
        'avatar': base64Encode(avatar),
      };
}
 