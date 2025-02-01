import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/models/album/album.dart';
import 'package:spotify_clone/data/models/artist/artist.dart';
import 'package:spotify_clone/data/models/auth/user.dart';
import 'package:spotify_clone/data/models/song/song.dart';
import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/domain/entity/auth/user.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/main.dart';

abstract class SongSupabaseService {
  Future<Either> getNewsSongs();
  Future<Either> getPlaylist();
  Future<Either> addOrRemoveFavoriteSong(int songId);
  Future<bool> isFavoriteSong(int songId);
  Future<Either> getUserFavoriteSongs(String userId);
  Future<Either> getArtistSongs(int artistId);
  Future<Either> getArtistSingleSongs(int artistId);
  Future<Either> getAlbumSongs(String albumId);
  Future<Either> getPlaylistSongs(String playlistId);
  Future<Either> getRecentSongs();
  Future<Either> addRecentSongs(int songId);

  Future<Either<String, Map<String, dynamic>>> searchSongBasedOnKeyword(String keyword);
}

class SongSupabaseServiceImpl extends SongSupabaseService {
  @override
  Future<Either> getNewsSongs() async {
    try {
      List<SongWithFavorite> songs = [];

      var item = await supabase.from('songs').select('*').order('release_date', ascending: false).limit(5);

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

      var item = await supabase.from('songs').select('*').order('release_date', ascending: true).limit(7);

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
      final existingFavorite = await supabase.from('favorites').select().match({'user_id': supabase.auth.currentUser!.id, 'song_id': songId});

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
      final existingFavorite = await supabase.from('favorites').select().match({'user_id': supabase.auth.currentUser!.id, 'song_id': songId});

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
  Future<Either> getUserFavoriteSongs(String userId) async {
    try {
      List<SongWithFavorite> anotherSong = [];

      var songIdQuery = await supabase.from('favorites').select('*').eq('user_id', userId.isEmpty ? supabase.auth.currentUser!.id : userId);

      for (final element in songIdQuery) {
        var songItem = await supabase.from('songs').select('*').eq('id', element['song_id']).single();

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

      var item = await supabase.from('songs').select('*').match({'artist_id': artistId});

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
  Future<Either> getArtistSingleSongs(int artistId) async {
    try {
      List<SongWithFavorite> songs = [];

      var item = await supabase.from('songs').select('*').match({'artist_id': artistId}).isFilter('album_id', null);

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

      var item = await supabase.from('songs').select('*').match({'album_id': albumId});

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

      var playlistSongs = await supabase.from('playlist_songs').select('*').match({'playlist_id': playlistId}).order('added_at', ascending: false);

      for (final element in playlistSongs) {
        var song = await supabase.from('songs').select('*').eq('id', element['song_id']).single();

        SongModel songModel = SongModel.fromJson(song);

        final isFavorite = await isFavoriteSong(songModel.id!);

        songs.add(SongWithFavorite(songModel.toEntity(), isFavorite));
      }

      return Right(songs);
    } catch (e) {
      return const Left('an error occured when fetching playlist song');
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> searchSongBasedOnKeyword(String keyword) async {
    try {
      final responses = await Future.wait([
        supabase.from('songs').select().or("title.ilike.%$keyword%,artist.ilike.%$keyword%"),
        supabase.from('artist').select().ilike('name', '%$keyword%'),
        supabase.from('album').select().ilike('name', '%$keyword%'),
        supabase.from('users').select().ilike('name', '%$keyword%'),
      ]);

      final songs = await Future.wait(
        (responses[0] as List).map((item) async {
          bool isFavorite = await isFavoriteSong(item['id']);
          return SongWithFavorite(SongModel.fromJson(item).toEntity(), isFavorite);
        }).toList(),
      );

      final artists = (responses[1] as List).map((item) => ArtistModel.fromJson(item).toEntity()).toList();

      final albums = await Future.wait(
        (responses[2] as List).map((item) async {
          var result = await supabase.from('artist').select().eq('id', item['artist_id']).single();

          AlbumModel album = AlbumModel.fromJson(item);
          album.songTotal = 0;

          return AlbumWithArtist(album.toEntity(), ArtistModel.fromJson(result).toEntity());
        }).toList(),
      );

      final users = await Future.wait(
        (responses[3] as List).map(
          (item) async {
            var isFollowed = await supabase.from('user_follower').select('*').match({
              'follower': supabase.auth.currentUser!.id,
              'following': item['user_id'],
            });

            var avatarQuery = await supabase.from('avatar').select().eq('user_id', item['user_id']).maybeSingle();
            var avatarUrl = avatarQuery != null && avatarQuery['avatarUrl'] != null
                ? avatarQuery['avatarUrl']
                : 'https://img.freepik.com/free-psd/contact-icon-illustration-isolated_23-2151903337.jpg?semt=ais_hybrid';

            var userModel = UserModel.fromJson(item);
            userModel.avatarUrl = avatarUrl;
            return UserWithStatus(userEntity: userModel.toEntity(), isFollowed: isFollowed.isNotEmpty);
          },
        ),
      );
      // final users = (responses[3] as List).map((item) => UserModel.fromJson(item).toEntity()).toList();

      // Mengembalikan data sebagai Map untuk kategori
      return Right({
        'songs': songs,
        'artists': artists,
        'albums': albums,
        'users': users,
      });
    } catch (e) {
      return const Left('Error while searching entities');
    }
  }

  @override
  Future<Either> getRecentSongs() async {
    List<SongWithFavorite> songs = [];

    try {
      var result =
          await supabase.from('recently_played').select().eq('user_id', supabase.auth.currentUser!.id).order('played_at', ascending: false).limit(5);

      if (result.isEmpty) {
        return Right(songs);
      } else {
        for (var song in result) {
          var songResult = await supabase.from('songs').select().eq('id', song['song_id']).single();
          bool isFavorite = await isFavoriteSong(songResult['id']);
          songs.add(SongWithFavorite(SongModel.fromJson(songResult).toEntity(), isFavorite));
        }
        return Right(songs);
      }
    } catch (e) {
      return const Left('an error occured when getting recent songs');
    }
  }

  @override
  Future<Either> addRecentSongs(int songId) async {
    String message = '';

    try {
      // Ambil semua lagu "recently_played" untuk pengguna saat ini
      final recentSongsResult = await supabase
          .from('recently_played')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('played_at', ascending: true); // Urutkan berdasarkan waktu (lagu lama di atas)

      final List recentSongs = recentSongsResult as List;

      // Jika lagu dengan songId sudah ada, return pesan
      final songExists = recentSongs.any((song) => song['song_id'] == songId);
      if (songExists) {
        return Right('Song already in recent');
      }

      // Jika sudah ada 5 lagu, hapus lagu paling lama
      if (recentSongs.length >= 5) {
        final songToDelete = recentSongs.first; // Lagu paling lama
        await supabase.from('recently_played').delete().eq('id', songToDelete['id']);
      }

      // Insert lagu baru
      await supabase.from('recently_played').insert({
        'song_id': songId,
        'user_id': supabase.auth.currentUser!.id,
        // 'created_at': DateTime.now().toIso8601String(),
      });

      message = 'Added to recent song';
      return Right(message);
    } catch (e) {
      return const Left('Error occurred when adding to recent song');
    }
  }
}
