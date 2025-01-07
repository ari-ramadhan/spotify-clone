import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/sources/playlist/playlist_supabase_service.dart';
import 'package:spotify_clone/domain/repository/playlist/playlist.dart';
import 'package:spotify_clone/service_locator.dart';

class PlaylistRepositoryImpl extends PlaylistRepository{
  @override
  Future<Either> getCurrentUserPlaylists() async {
    return await sl<PlaylistSupabaseService>().getCurrentUserPlaylists();
  }

  @override
  Future<Either> addNewPlaylist(String title, String description, bool isPublic, List selectedSongId) async {
    return await sl<PlaylistSupabaseService>().addNewPlaylist(title, description, isPublic, selectedSongId);
  }


}
