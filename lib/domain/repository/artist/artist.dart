import 'package:dartz/dartz.dart';

abstract class ArtistRepository {

  Future<Either> getArtistInfo (int artistId);
  Future<bool> isFollowed (int artistId);
  Future<Either> followUnfollowArtist (int artistId);
  Future<Either> getRecommendedArtistBasedOnPlaylist(List<String> artistsName);
  Future<Either> getAllArtist ();
  Future<Either> getFollowedArtists (String params);
  Future<Either> getHotArtists();

}
