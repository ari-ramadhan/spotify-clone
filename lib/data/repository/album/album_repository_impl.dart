import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/sources/album/album_supabase_service.dart';
import 'package:spotify_clone/data/sources/song/song_supabase_service.dart';
import 'package:spotify_clone/domain/repository/album/album.dart';
import 'package:spotify_clone/service_locator.dart';

class AlbumRepositoryImpl extends AlbumRepository {

  @override
  Future<Either> getArtistAlbum(int artistId) async {
    return await sl<AlbumSupabaseService>().getArtistAlbum(artistId);
  }
  @override
  Future<Either> getAllSongs(int artistId) async {
    return await sl<SongSupabaseService>().getArtistSongs(artistId);
  }

}
