class UserToHome {
  final int userId;
  final int homeId;
  final int id;

  UserToHome({required this.id, required this.userId, required this.homeId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'home_id': homeId,
    };
  }

  factory UserToHome.fromMap(Map<String, dynamic> map) {
    return UserToHome(
      id: map['id'],
      userId: map['user_id'],
      homeId: map['home_id'],
    );
  }
}