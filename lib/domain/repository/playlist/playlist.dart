import 'package:dartz/dartz.dart';

abstract class PlaylistRepository {
  Future<Either> getCurrentUserPlaylists();
  Future<Either> addNewPlaylist(
      String title, String description, bool isPublic, List selectedSongId);
}
