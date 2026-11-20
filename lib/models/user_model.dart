class UserModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String image;

  UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
  });

  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
    );
  }
}