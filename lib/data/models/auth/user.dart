import 'package:spotify_clone/domain/entity/auth/user.dart';

class UserModel {
  String? userId;
  String? fullName;
  String? email;
  // String? imageUrl;

  UserModel({
    this.email,
    this.userId,
    this.fullName,
    // this.imageUrl,
  });

  UserModel.fromJson(Map<String, dynamic> data) {
    userId = data['user_id'];
    fullName = data['name'];
    email = data['email'];
  }
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      email: email,
      fullName: fullName,
      // imageUrl: imageUrl,
    );
  }
}
