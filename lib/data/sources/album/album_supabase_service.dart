import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/models/album/album.dart';
import 'package:spotify_clone/data/models/artist/artist.dart';
import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/presentation/home/bloc/top_album/top_album_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AlbumSupabaseService {
  Future<Either> getArtistAlbum(int artistId);
  Future<Either> getTopAlbums();
}

class AlbumSupabaseServiceImpl extends AlbumSupabaseService {
  @override
  Future<Either> getArtistAlbum(int artistId) async {
    try {
      List<AlbumEntity> albumList = [];

      var item = await supabase.from('album').select('*').match({
        'artist_id': artistId,
      });

      final List<AlbumModel> data = item.map((item) {
        return AlbumModel.fromJson(item);
      }).toList();

      for (final albumModel in data) {
        var albumSong = await supabase
            .from('songs')
            .select('*')
            .match({'album_id': albumModel.albumId!}).count();

        albumModel.songTotal = albumSong.count;

        albumList.add(albumModel.toEntity());
      }

      return Right(albumList);
    } catch (e) {
      return const Left('Error occured when retrieving album');
    }
  }

  @override
  Future<Either> getTopAlbums() async {
    try {
      final result = await supabase.from('album').select('*');
      List<AlbumDetail> albumsDetail = [];

      for (var item in result) {
        var artist = await supabase
            .from('artist')
            .select()
            .eq('id', item['artist_id'])
            .single();

        var songTotal = await supabase
            .from('songs')
            .select()
            .eq('album_id', item['album_id'])
            .count();

        // print(
        // '${AppURLs.supabaseAlbumStorage}${artist['name']} - ${item['name']}.jpg');

        AlbumModel album = AlbumModel.fromJson(item);
        ArtistEntity artistEntity = ArtistModel.fromJson(artist).toEntity();
        album.songTotal = songTotal.count;

        albumsDetail.add(AlbumDetail(
          albumEnitity: album.toEntity(),
          artistEntity: artistEntity,
        ));
      }

      albumsDetail.shuffle();

      return Right(albumsDetail);
    } catch (e) {
      if (e is PostgrestException) {
        return Left('Database Error: ${e.message}');
      } else {
        return Left('An unexpected error occurred: $e');
      }
    }
  }

  // @override
  // Future<Either> getTopAlbums() async {
  //   try {
  //     List<AlbumEntity> albumList = [];

  //     var item = await supabase.from('album').select('*');

  //     final List<AlbumModel> data = item.map((item) {
  //       return AlbumModel.fromJson(item);
  //     }).toList();

  //     for (final albumModel in data) {
  //       var albumSong = await supabase
  //           .from('songs')
  //           .select('*')
  //           .match({'album_id': albumModel.albumId!}).count();

  //       albumModel.songTotal = albumSong.count;

  //       albumList.add(albumModel.toEntity());
  //     }

  //     return Right(albumList);
  //   } catch (e) {
  //     return const Left('Error occured when retrieving album');
  //   }
  // }
}
