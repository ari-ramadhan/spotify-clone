import 'package:dartz/dartz.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/data/models/playlist/playlist.dart';
import 'package:spotify_clone/domain/entity/playlist/playlist.dart';

abstract class PlaylistSupabaseService {
  Future<Either> getCurrentUserPlaylists();
  Future<Either> addNewPlaylist(
      String title, String description, bool isPublic, List selectedSongId);
}

class PlaylistSupabaseServiceImpl extends PlaylistSupabaseService {
  @override
  Future<Either> getCurrentUserPlaylists() async {
    try {
      List<PlaylistEntity> playlistEntities = [];

      var data = await supabase
          .from('playlists')
          .select('*')
          .match({'user_id': supabase.auth.currentUser!.id});

      final List<PlaylistModel> list = data.map((item) {
        return PlaylistModel.fromJson(item);
      }).toList();

      for (final playlistModel in list) {
        playlistEntities.add(playlistModel.toEntity());
      }

      return Right(playlistEntities);
    } catch (e) {
      return const Left('error occured when fetching user playlists');
    }
  }

  @override
  Future<Either> addNewPlaylist(String title, String description, bool isPublic,
    List selectedSongId) async {
  String message = '';

  try {
    // Menambahkan playlist ke tabel playlists
    final response = await supabase.from('playlists').insert({
      'user_id': supabase.auth.currentUser!.id,
      'is_public': isPublic,
      'name': title,
      'description': description
    }).select('id').single(); // Gunakan `select` untuk mengembalikan hanya kolom id

    if (response['id'] != null) {
      final playlistId = response['id']; // Ambil playlist ID

      // Jika selectedSongId tidak kosong, tambahkan lagu ke tabel playlist_songs
      if (selectedSongId.isNotEmpty) {
        for (var songId in selectedSongId) {
          await supabase.from('playlist_songs').insert({
            'playlist_id': playlistId,
            'song_id': songId,
          });
        }
        message = 'Songs added to the new playlist!';
      } else {
        message = 'A playlist added successfully';
      }
    } else {
      throw Exception('Failed to insert playlist or retrieve playlist ID');
    }

    return Right(message);
  } catch (e) {
    return const Left('Error occurred while adding a new playlist');
  }
}

}
