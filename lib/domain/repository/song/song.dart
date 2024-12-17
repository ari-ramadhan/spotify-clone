import 'package:dartz/dartz.dart';

abstract class SongRepository {
  Future<Either> getNewsSongs ();
  Future<Either> getPlaylist ();
  Future<Either> addOrRemoveFavoriteSong (int songId);
  Future<bool> isFavoriteSong (int songId);
}
