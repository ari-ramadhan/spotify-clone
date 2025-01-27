import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class PlaylistRepository {
  Future<Either> getCurrentUserPlaylists(String userId);
  Future<Either> deletePlaylist(String playlistId);
  Future<Either> addSongByKeyword(String playlistId, String title);
  Future<Either> addSongsToPlaylist(String playlistId, List selectedSongId);
  Future<Either> addNewPlaylist(String title, String description, bool isPublic, List selectedSongId);
  Future<Either> updatePlaylistInfo(String playlistId, String title, String desc);
  Future<Either> deleteSongFromPlaylist(String playlistId, int songId);
  Future<Either> batchAddToPlaylist(String playlistId, List<SongWithFavorite> songList);
}
