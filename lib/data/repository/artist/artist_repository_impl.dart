import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/sources/artist/artist_supabase_service.dart';
import 'package:spotify_clone/domain/repository/artist/artist.dart';
import 'package:spotify_clone/service_locator.dart';

class ArtistRepositoryImpl extends ArtistRepository {
  @override
  Future<Either> getArtistInfo(int artistId) async {
    return await sl<ArtistSupabaseService>().getArtistInfo(artistId);
  }

  @override
  Future<Either> getAllArtist() async {
    return await sl<ArtistSupabaseService>().getAllArtist();
  }

  @override
  Future<Either> followUnfollowArtist(int artistId) async {
    return await sl<ArtistSupabaseService>().followUnfollowArtist(artistId);
  }

  @override
  Future<bool> isFollowed(int artistId) async {
    return await sl<ArtistSupabaseService>().isFollowed(artistId);
  }

}
