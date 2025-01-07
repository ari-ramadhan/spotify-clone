import 'package:dartz/dartz.dart';

abstract class AlbumRepository {

  Future<Either> getArtistAlbum (int artistId);
  Future<Either> getAllSongs (int artistId);


}
