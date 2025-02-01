class UserEntity {
  String? userId;
  String? fullName;
  String? email;
  String? avatarUrl;

  UserEntity({
    this.userId,
    this.fullName,
    this.email,
    this.avatarUrl,
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

  FollowersEntity({required this.userEntity, required this.count});

  FollowersEntity copyWith({int? count}) {
    return FollowersEntity(
      userEntity: userEntity,
      count: count ?? this.count,

    );
  }
}

class FollowerAndFollowing {
  FollowersEntity? follower;
  FollowersEntity? following;

  FollowerAndFollowing({
    this.follower,
    this.following,
  });
}
