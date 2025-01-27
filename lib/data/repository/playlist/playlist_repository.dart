import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/sources/playlist/playlist_supabase_service.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/domain/repository/playlist/playlist.dart';
import 'package:spotify_clone/service_locator.dart';

class PlaylistRepositoryImpl extends PlaylistRepository{
  @override
  Future<Either> getCurrentUserPlaylists(String userId) async {
    return await sl<PlaylistSupabaseService>().getCurrentUserPlaylists(userId);
  }

  @override
  Future<Either> addNewPlaylist(String title, String description, bool isPublic, List selectedSongId) async {
    return await sl<PlaylistSupabaseService>().addNewPlaylist(title, description, isPublic, selectedSongId);
  }

  @override
  Future<Either> updatePlaylistInfo(String playlistId, String title, String desc) async {
    return await sl<PlaylistSupabaseService>().updatePlaylistInfo(playlistId, title, desc);
  }

  @override
  Future<Either> addSongsToPlaylist(String playlistId, List selectedSongId) async {
    return await sl<PlaylistSupabaseService>().addSongsToPlaylist(playlistId, selectedSongId);
  }

  @override
  Future<Either> deletePlaylist(String playlistId) async {
    return await sl<PlaylistSupabaseService>().deletePlaylist(playlistId);
  }

  @override
  Future<Either> addSongByKeyword(String playlistId, String title) async {
    return await sl<PlaylistSupabaseService>().addSongByKeyword(playlistId, title);
  }

  @override
  Future<Either> deleteSongFromPlaylist(String playlistId, int songId) async {
    return await sl<PlaylistSupabaseService>().deleteSongFromPlaylist(playlistId, songId);
  }

  @override
  Future<Either> batchAddToPlaylist(String playlistId, List<SongWithFavorite> songList) async {
    return await sl<PlaylistSupabaseService>().batchAddToPlaylist(playlistId, songList);
  }



}
