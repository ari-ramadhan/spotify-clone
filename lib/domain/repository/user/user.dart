import 'dart:io';

import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either> followUnfollowUser(String userId);
  Future<Either> getFollowerAndFollowing(String userId);
  Future<bool> isFollowed(String userId);
  Future<Either> uploadImageStorage(File imageFile);
  Future<Either> updateUsername(String username);
  Future<Either> updateFavoriteGenres(List selectedGenres);
}
