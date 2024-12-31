import 'package:dartz/dartz.dart';

abstract class ArtistRepository {

  Future<Either> getArtistInfo (int artistId);
  Future<Either> getAllArtist ();

}
