class LabourReviewModel {
  int rating;
  String comment;
  String name;
  String email;

  LabourReviewModel({
    required this.rating,
    required this.comment,
    required this.name,
    required this.email,
  });

  factory LabourReviewModel.fromJson(Map<String, dynamic> json) {
    return LabourReviewModel(
      rating: json['rating'],
      comment: json['comment'],
      name: json['name'],
      email: json['email'],
    );
  }

  static List<LabourReviewModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LabourReviewModel.fromJson(json)).toList();
  }
}

