import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/models/song/song.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/main.dart';

abstract class SongSupabaseService {
  Future<Either> getNewsSongs();
  Future<Either> getPlaylist();
  Future<Either> addOrRemoveFavoriteSong(int songId);
  Future<bool> isFavoriteSong(int songId);
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
          .limit(4);

      final List<SongModel> data = item.map((item) {
        return SongModel.fromJson(item);
      }).toList();


      // print(supabase.auth.currentUser!.);
      // data.forEach((element) {
      //   songs.insert(data.indexOf(element), element.toEntity());
      //   print(element.id.toString());
      // });

      for (final songModel in data) {
        final isFavorite = await isFavoriteSong(songModel.id!);

        songs.add(SongWithFavorite(songModel.toEntity(), isFavorite));
      }
      // for (final songModel in data) {
      //   final isFavorite = await isFavoriteSong(songModel.id!);
      //   SongModel result = SongModel(
      //       id: songModel.id,
      //       title: songModel.title,
      //       artist: songModel.artist,
      //       duration: songModel.duration,
      //       isFavorite: isFavorite,
      //       releaseDate: songModel.releaseDate);

      //   songs.insert(data.indexOf(songModel),  result.toEntity());
      // }

      return Right(songs);
    } catch (e) {
      return Left('An error occured, Please try again');
    }
  }

  @override
  Future<Either> getPlaylist() async {
    try {
      List<SongWithFavorite> songs = [];

      var item = await supabase
          .from('songs')
          .select('*')
          .order('release_date', ascending: true);

      final List<SongModel> data = item.map((item) {
        return SongModel.fromJson(item);
      }).toList();

      // data.forEach(
      //     (element) {
      //       songs.insert(data.indexOf(element), element.toEntity());
      //     });
      for (final songModel in data) {
        final isFavorite = await isFavoriteSong(songModel.id!);

        songs.add(SongWithFavorite(songModel.toEntity(), isFavorite));
      }

      return Right(songs);
    } catch (e) {
      return Left('An error occured, Please try again');
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
      return Left('An error has occured');
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
}
