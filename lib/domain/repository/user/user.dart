import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either> followUnfollowUser(String userId);
  Future<Either> getFollowerAndFollowing(String userId);
  Future<bool> isFollowed(String userId);
}
