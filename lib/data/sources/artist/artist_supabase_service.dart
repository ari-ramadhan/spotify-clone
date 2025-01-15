import 'package:dartz/dartz.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/data/models/artist/artist.dart';
// ignore: unused_import
import 'package:spotify_clone/data/models/song/song.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';

abstract class ArtistSupabaseService {
  Future<Either> getArtistInfo(int artistId);
  Future<Either> getAllArtist();
  Future<bool> isFollowed(int artistId);
  Future<Either> followUnfollowArtist(int artistId);
}

class ArtistSupabaseServiceImpl extends ArtistSupabaseService {
  @override
  Future<Either> getArtistInfo(int artistId) async {
    try {
      ArtistWithFollowing? artistEntity;

      var data = await supabase.from('artist').select('*').eq('id', artistId);

      ArtistModel artistModel = ArtistModel.fromJson(data.first);

      bool followStatus = await isFollowed(artistId);

      artistEntity = ArtistWithFollowing(artistModel.toEntity(), followStatus);

      return Right(artistEntity);
    } catch (e) {
      return const Left('error occured when ');
    }
  }
  // @override
  // Future<Either> getArtistInfo(int artistId) async {
  //   try {
  //     ArtistEntity? artistEntity;

  //     var data = await supabase.from('artist').select('*').eq('id', artistId);

  //     ArtistModel artistModel = ArtistModel.fromJson(data.first);

  //     artistEntity = artistModel.toEntity();

  //     return Right(artistEntity);
  //   } catch (e) {
  //     return const Left('error occured when ');
  //   }
  // }

  @override
  Future<Either> getAllArtist() async {
    try {
      List<ArtistWithFollowing> artistList = [];

      var result = await supabase.from('artist').select('*');

      final List<ArtistModel> data = result.map((item) {
        return ArtistModel.fromJson(item);
      }).toList();

      for (final artistModel in data) {

        bool followStatus = await isFollowed(artistModel.id!);

        artistList.add(ArtistWithFollowing(artistModel.toEntity(), followStatus));
      }

      return Right(artistList);
    } catch (e) {
      return const Left('error occured when fetching artist list');
    }
  }
  // @override
  // Future<Either> getAllArtist() async {
  //   try {
  //     List<ArtistEntity> artistList = [];

  //     var result = await supabase.from('artist').select('*');

  //     final List<ArtistModel> data = result.map((item) {
  //       return ArtistModel.fromJson(item);
  //     }).toList();

  //     for (final artistModel in data) {
  //       artistList.add(artistModel.toEntity());
  //     }

  //     return Right(artistList);
  //   } catch (e) {
  //     return const Left('error occured when fetching artist list');
  //   }
  // }

  @override
  Future<bool> isFollowed(int artistId) async {
    try {
      var result = await supabase.from('artist_follower').select('*').match({
        'artist_id': artistId,
        'user_id': supabase.auth.currentUser!.id,
      });

      if (result.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> followUnfollowArtist(int artistId) async {
    try {
      late bool followStatus;

      if (!await isFollowed(artistId)) {
        await supabase.from('artist_follower').insert(
            {'user_id': supabase.auth.currentUser!.id, 'artist_id': artistId});
        followStatus = true;
      } else {
        await supabase.from('artist_follower').delete().match(
            {'user_id': supabase.auth.currentUser!.id, 'artist_id': artistId});
        followStatus = false;
      }

      return Right(followStatus);
    } catch (e) {
      return Left('An error occured when following an artist');
    }
  }
}
