class GroupMember {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String role;

  GroupMember({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json["id"],
      userId: json["user_id"],
      fullName: json["full_name"],
      email: json["email"],
      role: json["role"],
    );
  }
}