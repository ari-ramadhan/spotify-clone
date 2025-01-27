class UserEntity {
  String ? userId;
  String ? fullName;
  String ? email;

  UserEntity({
    this.userId,
    this.fullName,
    this.email,
  });
}

class UserWithStatus {
  final UserEntity userEntity;
  final bool isFollowed;

  UserWithStatus({required this.userEntity, required this.isFollowed});
}

class FollowersEntity {
  final List<UserWithStatus> userEntity;
  final int count;

  FollowersEntity({
    required this.userEntity,
    required this.count
  });
}

class FollowerAndFollowing {
  FollowersEntity ? follower;
  FollowersEntity ? following;

  FollowerAndFollowing({
    this.follower,
    this.following,
  });
}
