import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/sources/album/album_supabase_service.dart';
import 'package:spotify_clone/domain/repository/album/album.dart';
import 'package:spotify_clone/service_locator.dart';

class AlbumRepositoryImpl extends AlbumRepository {

  @override
  Future<Either> getArtistAlbum(int artistId) async {
    return await sl<AlbumSupabaseService>().getArtistAlbum(artistId);
  }

}
