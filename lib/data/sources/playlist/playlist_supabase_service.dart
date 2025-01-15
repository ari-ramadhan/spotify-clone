import 'package:dartz/dartz.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/data/models/playlist/playlist.dart';
import 'package:spotify_clone/data/models/song/song.dart';
import 'package:spotify_clone/domain/entity/playlist/playlist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class PlaylistSupabaseService {
  Future<Either> getCurrentUserPlaylists();
  Future<Either> updatePlaylistInfo(String playlistId, String title, String desc);
  Future<Either> addNewPlaylist(String title, String description, bool isPublic, List selectedSongId);

  Future<Either> addSongsToPlaylist(String playlistId, List selectedSongId);
  Future<Either> deletePlaylist(String playlistId);
  Future<Either> addSongByKeyword(String playlistId, String title);
  Future<Either> deleteSongFromPlaylist(String playlistId, int songId);
}

class PlaylistSupabaseServiceImpl extends PlaylistSupabaseService {
  @override
  Future<Either> getCurrentUserPlaylists() async {
    try {
      List<PlaylistEntity> playlistEntities = [];

      var data = await supabase.from('playlists').select('*').match({'user_id': supabase.auth.currentUser!.id});

      final List<PlaylistModel> list = data.map((item) {
        return PlaylistModel.fromJson(item);
      }).toList();

      for (final playlistModel in list) {
        if (list.isNotEmpty) {
          var songCount = await supabase.from('playlist_songs').select('*').match({'playlist_id': playlistModel.id!}).count();

          playlistModel.songCount = songCount.count;

          playlistEntities.add(playlistModel.toEntity());
        } else {
          playlistEntities.add(playlistModel.toEntity());
        }
      }

      return Right(playlistEntities);
    } catch (e) {
      return const Left('error occured when fetching user playlists');
    }
  }

  @override
  Future<Either> addNewPlaylist(String title, String description, bool isPublic, List selectedSongId) async {
    String message = '';

    try {
      // Menambahkan playlist ke tabel playlists
      final response = await supabase
          .from('playlists')
          .insert({'user_id': supabase.auth.currentUser!.id, 'is_public': isPublic, 'name': title, 'description': description})
          .select('id')
          .single(); // Gunakan `select` untuk mengembalikan hanya kolom id

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

  @override
  Future<Either> updatePlaylistInfo(String playlistId, String title, String desc) async {
    if (playlistId.isEmpty) {
      return const Left('Semua field harus diisi');
    }

    try {
      await supabase.from('playlists').update({'name': title, 'description': desc}).eq('id', playlistId);
      return const Right('Berhasil memperbarui informasi playlist');
    } on Exception catch (e) {
      return Left('Terjadi kesalahan: ${e}');
    }
  }

  @override
  Future<Either> addSongsToPlaylist(String playlistId, List selectedSongId) async {
    String message = '';

    try {
      if (selectedSongId.isNotEmpty) {
        for (var songId in selectedSongId) {
          await supabase.from('playlist_songs').insert({'playlist_id': playlistId, 'song_id': songId});
        }
        message = 'Successfully added a few songs to playlist';
        print(message);
      } else {
        message = "U haven't selected any song";
        print(message);
      }
      print(message);
      return Right(message);
    } catch (e) {
      return const Left('failed to add a song to playlist');
    }
  }

  @override
  Future<Either> deletePlaylist(String playlistId) async {
    try {
      await supabase.from('playlists').delete().eq('id', playlistId);

      return const Right('Successfully deleted the playlist');
    } catch (e) {
      return const Left('error occured while deleting playlist');
    }
  }

  @override
  Future<Either> addSongByKeyword(String playlistId, String title) async {
    try {
      SongWithFavorite songEntity;
      var result = await supabase.from('songs').select().like('title', '%$title%').single();

      if (result.isNotEmpty) {
        songEntity = SongWithFavorite(SongModel.fromJson(result).toEntity(), true);

        print('founded song ${songEntity.song.title} by ${songEntity.song.artist}');

        await supabase.from('playlist_songs').insert({'playlist_id': playlistId, 'song_id': songEntity.song.id});

        return Right(songEntity);
      } else {
        print('song not found');
        return Left('Try another keyword');
      }
    } catch (e) {
      print('error');
      return Left('Error occured while searching for song');
    }
  }

  @override
  Future<Either> deleteSongFromPlaylist(String playlistId, int songId) async {
    try {
      await supabase.from('playlist_songs').delete().eq('playlist_id', playlistId).eq('song_id', songId);

      return Right('Successfull deleting song from this playlist');
    } catch (e) {
      return Left('error occured while deleting this song');
    }
  }
}
