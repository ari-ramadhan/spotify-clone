import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/models/song/song.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/main.dart';

abstract class SongSupabaseService {
  Future<Either> getNewsSongs();
  Future<Either> getPlaylist();
  Future<Either> addOrRemoveFavoriteSong(int songId);
  Future<bool> isFavoriteSong(int songId);
  Future<Either> getUserFavoriteSongs();
  Future<Either> getArtistSongs(int artistId);
  Future<Either> getAlbumSongs(String albumId);
  Future<Either> getPlaylistSongs(String playlistId);
}

class SongSupabaseServiceImpl extends SongSupabaseService {
  @override
  Future<Either> getNewsSongs() async {
    try {
      List<SongWithFavorite> songs = [];

      var item = await supabase
          .from('songs')
          .select('*')
          .order('release_date', ascending: false)
          .limit(5);

      final List<SongModel> data = item.map((item) {
        return SongModel.fromJson(item);
      }).toList();

      for (final songModel in data) {
        final isFavorite = await isFavoriteSong(songModel.id!);

        songs.add(SongWithFavorite(songModel.toEntity(), isFavorite));
      }

      return Right(songs);
    } catch (e) {
      return const Left('An error occured, Please try again');
    }
  }

  @override
  Future<Either> getPlaylist() async {
    try {
      List<SongWithFavorite> songs = [];

      var item = await supabase
          .from('songs')
          .select('*')
          .order('release_date', ascending: true).limit(7);

      final List<SongModel> data = item.map((item) {
        return SongModel.fromJson(item);
      }).toList();

      for (final songModel in data) {
        final isFavorite = await isFavoriteSong(songModel.id!);

        songs.add(SongWithFavorite(songModel.toEntity(), isFavorite));
      }

      return Right(songs);
    } catch (e) {
      return const Left('An error occured, Please try again');
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteSong(int songId) async {
    try {
      late bool isFavorite;
      // Cek apakah lagu sudah ada di daftar favorit
      final existingFavorite = await supabase
          .from('favorites')
          .select()
          .match({'user_id': supabase.auth.currentUser!.id, 'song_id': songId});

      if (existingFavorite.isNotEmpty) {
        // Jika sudah ada, hapus
        await supabase.from('favorites').delete().match(
          {
            'user_id': supabase.auth.currentUser!.id,
            'song_id': songId,
          },
        );

        isFavorite = false;
      } else {
        // Jika belum ada, tambahkan
        await supabase.from('favorites').insert(
          [
            {
              'user_id': supabase.auth.currentUser!.id,
              'song_id': songId,
            },
          ],
        );

        isFavorite = true;
      }

      return Right(isFavorite);
    } catch (e) {
      return const Left('An error has occured');
    }
  }

  @override
  Future<bool> isFavoriteSong(int songId) async {
    try {
      // Cek apakah lagu sudah ada di daftar favorit
      final existingFavorite = await supabase
          .from('favorites')
          .select()
          .match({'user_id': supabase.auth.currentUser!.id, 'song_id': songId});

      if (existingFavorite.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> getUserFavoriteSongs() async {
    try {
      List<SongWithFavorite> anotherSong = [];

      var songIdQuery = await supabase
          .from('favorites')
          .select('*')
          .eq('user_id', supabase.auth.currentUser!.id);

      for (final element in songIdQuery) {
        var songItem = await supabase
            .from('songs')
            .select('*')
            .eq('id', element['song_id'])
            .single();

        SongModel songModel = SongModel.fromJson(songItem);

        anotherSong.add(SongWithFavorite(songModel.toEntity(), true));
      }
      return Right(anotherSong);
    } catch (e) {
      return const Left('An error occured while fetching your favorite songs');
    }
  }

  @override
  Future<Either> getArtistSongs(int artistId) async {
    try {
      List<SongWithFavorite> songs = [];

      var item = await supabase
          .from('songs')
          .select('*')
          .match({'artist_id': artistId});

      final List<SongModel> data = item.map((item) {
        return SongModel.fromJson(item);
      }).toList();

      for (final songModel in data) {
        final isFavorite = await isFavoriteSong(songModel.id!);

        songs.add(SongWithFavorite(songModel.toEntity(), isFavorite));
      }

      return Right(songs);
    } catch (e) {
      return const Left('An error occured, Please try again');
    }
  }

  @override
  Future<Either> getAlbumSongs(String albumId) async {
    try {
      List<SongWithFavorite> songs = [];

      var item =
          await supabase.from('songs').select('*').match({'album_id': albumId});

      final List<SongModel> data = item.map((item) {
        return SongModel.fromJson(item);
      }).toList();

      for (final songModel in data) {
        final isFavorite = await isFavoriteSong(songModel.id!);

        songs.add(SongWithFavorite(songModel.toEntity(), isFavorite));
      }

      return Right(songs);
    } catch (e) {
      return const Left('An error occured, Please try again');
    }
  }

  @override
  Future<Either> getPlaylistSongs(String playlistId) async {
    try {

      List<SongWithFavorite> songs = [];

      var playlistSongs = await supabase
          .from('playlist_songs')
          .select('*')
          .match({'playlist_id': playlistId});

      for (final element in playlistSongs) {
        var song = await supabase
            .from('songs')
            .select('*')
            .eq('id', element['song_id'])
            .single();

        SongModel songModel = SongModel.fromJson(song);

        final isFavorite = await isFavoriteSong(songModel.id!);

        songs.add(SongWithFavorite(songModel.toEntity(), isFavorite));
      }

      return Right(songs);
    } catch (e) {
      print(e);
      return Left('an error occured when fetching playlist song');
    }
  }
}
