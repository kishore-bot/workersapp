class UserModel {
  final String id;
  final String name;
  final String email;
  final int phoneN;
  final String street;
  final String address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneN,
    required this.street,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneN: json['phoneN'],
      street: json['street'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phoneN': phoneN,
        'street': street,
        'address': address,
      };
}
