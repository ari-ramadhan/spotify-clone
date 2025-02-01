import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/sources/user/user_supabase_service.dart';
import 'package:spotify_clone/domain/repository/user/user.dart';
import 'package:spotify_clone/service_locator.dart';

class UserRepositoryImpl extends UserRepository{
  @override
  Future<Either> followUnfollowUser(String userId) async {
    return await sl<UserSupabaseService>().followUnfollowUser(userId);
  }

  @override
  Future<Either> getFollowerAndFollowing(String userId) async {
    return await sl<UserSupabaseService>().getFollowerAndFollowing(userId);
  }

  @override
  Future<bool> isFollowed(String userId) async {
    return await sl<UserSupabaseService>().isFollowed(userId);
  }
  @override
  Future<Either> uploadImageStorage(File imageFile) async {
    return await sl<UserSupabaseService>().uploadImageStorage(imageFile);
  }
}
