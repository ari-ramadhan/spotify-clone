import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/models/album/album.dart';
import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/main.dart';

abstract class AlbumSupabaseService {

  Future<Either> getArtistAlbum (int artistId);

}

class AlbumSupabaseServiceImpl extends AlbumSupabaseService {
  @override
  Future<Either> getArtistAlbum(int artistId) async {
    try{

      List<AlbumEntity> albumList = [];

      var item = await supabase.from('album').select('*').match({
        'artist_id' : artistId,
      });

      final List<AlbumModel> data = item.map((item){
        return AlbumModel.fromJson(item);
      }).toList();



      for (final albumModel in data) {
        var albumSong = await supabase.from('songs').select('*').match({
          'album_id' : albumModel.albumId!
        }).count();

        albumModel.songTotal = albumSong.count;

        albumList.add(albumModel.toEntity());
      }

      return Right(albumList);

    } catch (e){
      return const Left('Error occured when retrieving album');
    }
  }

}
