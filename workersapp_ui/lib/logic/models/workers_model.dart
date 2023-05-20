import 'dart:typed_data';

class ReviewModel {
  String comment;
  String name;
  String email;
  double rating;

  ReviewModel({
    required this.comment,
    required this.name,
    required this.email,
    required this.rating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      comment: json['comment'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() =>
      {'comment': comment, 'name': name, 'email': email, 'rating': rating};
}

class WorkersModel {
  String id;
  String name;
  String email;
  String specialization;
  int phoneNo;
  int salary;
  int experience;
  List<ReviewModel>? reviews;
  double avgRating;
  Uint8List? avatar;

  WorkersModel({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.phoneNo,
    required this.salary,
    required this.experience,
    this.reviews,
    required this.avgRating,
    this.avatar,
  });

  factory WorkersModel.fromJson(Map<String, dynamic> json) {
    var reviewsJson = json['reviews'] as List<dynamic>?;

    List<ReviewModel>? reviews = reviewsJson
        ?.map((reviewJson) => ReviewModel.fromJson(reviewJson))
        .toList();

    Uint8List? avatar;
    if (json['avatar'] != null && json['avatar']['data'] != null) {
      List<int> avatarData = List<int>.from(json['avatar']['data']);
      avatar = Uint8List.fromList(avatarData);
    }

    return WorkersModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      specialization: json['specialization'] ?? '',
      phoneNo: json['phoneNo'] ?? 0,
      salary: json['salary'] ?? 0,
      experience: json['experience'] ?? 0,
      reviews: reviews,
      avgRating: (json['avgRating'] ?? 0).toDouble(),
      avatar: avatar,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'specialization': specialization,
        'phoneNo': phoneNo,
        'salary': salary,
        'experience': experience,
        'reviews': reviews?.map((review) => review.toJson()).toList(),
        'avgRating': double.parse(avgRating.toStringAsFixed(3)),
        'avatar': avatar != null ? {'type': 'Buffer', 'data': avatar!.toList()} : null,
      };
}
