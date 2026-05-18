class UserModel {
  final String uid;
  final String? email;

  UserModel({required this.uid, this.email});

  // 從 Firebase User 轉換
  factory UserModel.fromFirebase(dynamic user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
    );
  }
}
