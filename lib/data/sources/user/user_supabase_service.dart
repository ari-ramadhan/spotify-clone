import 'package:dartz/dartz.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/data/models/auth/user.dart';
import 'package:spotify_clone/domain/entity/auth/user.dart';

abstract class UserSupabaseService {
  Future<Either> followUnfollowUser(String userId);
  Future<Either> getFollowerAndFollowing(String userId);
  // Future<Either> getFollowing(String userId);
  Future<bool> isFollowed(String userId);
}

class UserSupabaseServiceImpl implements UserSupabaseService {
  @override
  Future<Either> followUnfollowUser(String userId) async {
    try {
      late bool followStatus;

      if (!await isFollowed(userId)) {
        // Menambahkan pengguna sebagai yang diikuti
        await supabase.from('user_follower').insert({
          'follower': supabase.auth.currentUser!.id, // Current user sebagai pengikut
          'following': userId, // Target user sebagai yang diikuti
        });
        followStatus = true;
      } else {
        // Menghapus hubungan mengikuti
        await supabase.from('user_follower').delete().match({
          'follower': supabase.auth.currentUser!.id, // Current user sebagai pengikut
          'following': userId, // Target user sebagai yang diikuti
        });
        followStatus = false;
      }

      return Right(followStatus);
    } catch (e) {
      return const Left('An error occurred when following/unfollowing a user');
    }
  }

  @override
  Future<bool> isFollowed(String userId) async {
    try {
      // Memeriksa apakah current user mengikuti userId
      var result = await supabase.from('user_follower').select('*').match({
        'follower': supabase.auth.currentUser!.id,
        'following': userId,
      });

      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<FollowersEntity> getFollower(String userId) async {
    FollowersEntity followersEntity = FollowersEntity(userEntity: [], count: 0);

    try {
      // Mendapatkan semua pengikut dari userId
      var result = await supabase.from('user_follower').select().eq('following', userId).count();

      if (result.data.isEmpty) {
        return followersEntity;
      } else {
        List<UserWithStatus> users = [];

        for (var user in result.data) {
          var userResult = await supabase.from('users').select().eq('user_id', user['following']).single();
          bool isFollowing = await isFollowed(user['following']);

          users.add(UserWithStatus(userEntity: UserModel.fromJson(userResult).toEntity(), isFollowed: isFollowing));
        }

        return FollowersEntity(userEntity: users, count: result.count);
      }
    } catch (e) {
      return followersEntity;
    }
  }

  Future<FollowersEntity> getFollowing(String userId) async {
    FollowersEntity followersEntity = FollowersEntity(userEntity: [], count: 0);

    try {
      // Mendapatkan semua pengikut dari userId
      var result = await supabase.from('user_follower').select().eq('follower', userId).count();

      if (result.data.isEmpty) {
        return followersEntity;
      } else {
        List<UserWithStatus> users = [];

        for (var user in result.data) {
          var userResult = await supabase.from('users').select().eq('user_id', user['follower']).single();
          bool isFollowing = await isFollowed(user['follower']);

          users.add(UserWithStatus(userEntity: UserModel.fromJson(userResult).toEntity(), isFollowed: isFollowing));
        }

        return FollowersEntity(userEntity: users, count: result.count);
      }
    } catch (e) {
      return followersEntity;
    }
  }

  @override
  Future<Either> getFollowerAndFollowing(String userId) async {
    try {
      var follower = await getFollower(userId);
      var following = await getFollowing(userId);
      return Right(FollowerAndFollowing(follower: follower, following: following)) ;
    } catch (e) {
      return Left('error while getting follower and following list');
    }
  }
}
