import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/core/configs/constants/app_key_feature.dart';
import 'package:spotify_clone/data/models/album/album.dart';
import 'package:spotify_clone/data/models/artist/artist.dart';
import 'package:spotify_clone/data/models/playlist/playlist.dart';
import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/playlist/playlist.dart';
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

      List<PlaylistEntity> albums = (result as List).map((e) {
        PlaylistModel playlistModel = PlaylistModel.fromJson(e);
        playlistModel.songCount = 0;

        return playlistModel.toEntity();
      }).toList();

      return Right(albums);
    } catch (e) {
      return const Left('error occured while getting recent playlists');
    }
  }
}
