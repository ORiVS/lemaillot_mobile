class UserModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String username;
  final String email;
  final int? role;
  final bool isVerified;

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.username,
    required this.email,
    this.role,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    phoneNumber: json['phone_number'] ?? '',
    username: json['username'],
    email: json['email'],
    role: json['role'],
    isVerified: json['is_verified'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'phone_number': phoneNumber,
    'username': username,
    'email': email,
    'role': role,
    'is_verified': isVerified,
  };
}
