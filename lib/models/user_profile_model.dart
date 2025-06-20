class UserProfileModel {
  final String? profilePicture;
  final String? coverPhoto;
  final String addressLine1;
  final String addressLine2;
  final String country;
  final String state;
  final String city;
  final String? pinCode;
  final double? longitude;
  final double? latitude;

  UserProfileModel({
    this.profilePicture,
    this.coverPhoto,
    required this.addressLine1,
    required this.addressLine2,
    required this.country,
    required this.state,
    required this.city,
    this.pinCode,
    this.longitude,
    this.latitude,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
    profilePicture: json['profile_picture'],
    coverPhoto: json['cover_photo'],
    addressLine1: json['address_line_1'] ?? '',
    addressLine2: json['address_line_2'] ?? '',
    country: json['country'] ?? '',
    state: json['state'] ?? '',
    city: json['city'] ?? '',
    pinCode: json['pin_code'],
    longitude: json['longitude']?.toDouble(),
    latitude: json['latitude']?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'profile_picture': profilePicture,
    'cover_photo': coverPhoto,
    'address_line_1': addressLine1,
    'address_line_2': addressLine2,
    'country': country,
    'state': state,
    'city': city,
    'pin_code': pinCode,
    'longitude': longitude,
    'latitude': latitude,
  };
}
