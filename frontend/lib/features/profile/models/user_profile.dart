class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String? profilePhoto;
  final String currency;
  final String? upiId;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profilePhoto,
    required this.currency,
    required this.upiId,
  });

  factory UserProfile.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserProfile(
      id: json["id"],
      fullName: json["full_name"],
      email: json["email"],
      profilePhoto: json["profile_photo"],
      currency: json["currency"],
      upiId: json["upi_id"],
    );
  }
}