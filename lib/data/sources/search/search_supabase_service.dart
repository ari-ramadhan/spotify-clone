import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/core/configs/constants/app_key_feature.dart';
import 'package:spotify_clone/data/models/album/album.dart';
import 'package:spotify_clone/data/models/artist/artist.dart';
import 'package:spotify_clone/data/models/auth/user.dart';
import 'package:spotify_clone/data/models/playlist/playlist.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/auth/user.dart';
import 'package:spotify_clone/domain/entity/playlist/playlist.dart';
import 'package:spotify_clone/domain/usecases/user/check_following_status.dart';
import 'package:spotify_clone/domain/usecases/user/follow_user.dart';
import 'package:spotify_clone/presentation/home/bloc/top_album/top_album_state.dart';

abstract class SearchSupabaseService {
  Future<List<String>> getLocalRecentSearchKeyword();
  Future setLocalRecentSearchKeyword(String keyword);
  Future deleteRecentSearchKeyword(String keyword);
  Future deleteAllRecentSearchKeyword();
  Future<Either> getRecentArtists();
  Future<Either> getRecentAlbums();
  Future<Either> getRecentPlaylists();
}

class SearchSupabaseServiceImpl extends SearchSupabaseService {
  @override
  Future<List<String>> getLocalRecentSearchKeyword() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getStringList(AppKeysFeature.SF_RECENT_SEARCHS_KEYWORD) ?? [];
  }

  @override
  Future setLocalRecentSearchKeyword(String keyword) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    List<String> localSearchKeyword = await getLocalRecentSearchKeyword();
    localSearchKeyword.removeWhere(
        (element) => element.toLowerCase() == keyword.toLowerCase());
    localSearchKeyword.insert(0, keyword);
    if (localSearchKeyword.length > 5) {
      localSearchKeyword = localSearchKeyword.sublist(0, 5);
    }
    await sf.setStringList(
        AppKeysFeature.SF_RECENT_SEARCHS_KEYWORD, localSearchKeyword);
  }

  @override
  Future deleteRecentSearchKeyword(String keyword) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    List<String> localSearchKeyword = await getLocalRecentSearchKeyword();
    localSearchKeyword.removeWhere(
        (element) => element.toLowerCase() == keyword.toLowerCase());
    await sf.setStringList(
        AppKeysFeature.SF_RECENT_SEARCHS_KEYWORD, localSearchKeyword);
  }

  @override
  Future deleteAllRecentSearchKeyword() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    await sf.remove(AppKeysFeature.SF_RECENT_SEARCHS_KEYWORD);
  }

  @override
  Future<Either> getRecentArtists() async {
    try {
      var result = await supabase.from('artist').select('*').limit(6);

      List<ArtistEntity> artists = (result as List)
          .map((e) => ArtistModel.fromJson(e).toEntity())
          .toList();

      return Right(artists);
    } catch (e) {
      return const Left('error occured while getting recent artists');
    }
  }

  @override
  Future<Either> getRecentAlbums() async {
    try {
      final result = await supabase.from('album').select('*').limit(6);
      List<AlbumDetail> albumsDetail = [];

      for (var item in result) {
        var artist = await supabase
            .from('artist')
            .select()
            .eq('id', item['artist_id'])
            .single();

        // print(
        // '${AppURLs.supabaseAlbumStorage}${artist['name']} - ${item['name']}.jpg');

        AlbumModel album = AlbumModel.fromJson(item);
        ArtistEntity artistEntity = ArtistModel.fromJson(artist).toEntity();
        album.songTotal = 0;

        albumsDetail.add(AlbumDetail(
          albumEnitity: album.toEntity(),
          artistEntity: artistEntity,
        ));
      }

      return Right(albumsDetail);
    } catch (e) {
      if (e is PostgrestException) {
        return Left('Database Error: ${e.message}');
      } else {
        return Left('An unexpected error occurred: $e');
      }
    }
  }

  @override
  Future<Either> getRecentPlaylists() async {
    try {
      final result = await supabase.from('playlists').select('*').limit(6);

      List<PlaylistAndUser> playlistUser = [];

      // print(result);

      for (var data in result as List) {
        var user = await supabase
            .from('users')
            .select('*')
            .eq('user_id', data['user_id'])
            .single();
        bool isFollowed = supabase.auth.currentUser!.id == user['user_id']
            ? false
            : await sl<CheckFollowingStatusUseCase>()
                .call(params: data['user_id']);

        print("$user isFollowed ? $isFollowed");

        UserWithStatus userEntity = UserWithStatus(
            userEntity: UserModel.fromJson(user).toEntity(),
            isFollowed: isFollowed);

        PlaylistEntity playlistEntity = PlaylistModel(
                id: data['id'],
                createdAt: data['created_at'].toString(),
                isPublic: data['is_public'],
                userId: data['user_id'],
                name: data['name'],
                description: data['description'],
                songCount: 1)
            .toEntity();
        playlistEntity.songCount = playlistEntity.songCount ?? 1;

        playlistUser
            .add(PlaylistAndUser(playlist: playlistEntity, user: userEntity));
      }

      return Right(playlistUser);
    } catch (e) {
      print(e);
      return const Left('error occured while getting recent playlists');
    }
  }
}
