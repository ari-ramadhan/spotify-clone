import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/sources/song/song_supabase_service.dart';
import 'package:spotify_clone/domain/repository/song/song.dart';
import 'package:spotify_clone/service_locator.dart';

class SongRepositoryImpl extends SongRepository {
  @override
  Future<Either> getNewsSongs() async {
    return await sl<SongSupabaseService>().getNewsSongs();
  }

  @override
  Future<Either> getPlaylist() async {
    return await sl<SongSupabaseService>().getPlaylist();
  }

  @override
  Future<Either> addOrRemoveFavoriteSong(int songId) async {
    return await sl<SongSupabaseService>().addOrRemoveFavoriteSong(songId);
  }
  @override

  Future<bool> isFavoriteSong(int songId) async {
    return await sl<SongSupabaseService>().isFavoriteSong(songId);
  }

  @override
  Future<Either> getUserFavoriteSongs() async {
    return await sl<SongSupabaseService>().getUserFavoriteSongs();
  }

  @override
  Future<Either> getArtistSongs(int artisId) async {
    return await sl<SongSupabaseService>().getArtistSongs(artisId);
  }

  @override
  Future<Either> getAlbumSongs(String albumId) async {
    return await sl<SongSupabaseService>().getAlbumSongs(albumId);
  }

  @override
  Future<Either> getPlaylistSongs(String playlistId) async {
    return await sl<SongSupabaseService>().getPlaylistSongs(playlistId);

  }
}
