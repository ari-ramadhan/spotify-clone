import 'package:dartz/dartz.dart';

abstract class RecentSearchRepository {
  Future setLocalRecentSearchKeyword(String keyword);
  Future<List<String>> getLocalRecentSearchKeyword();
  Future deleteRecentSearchKeyword(String keyword);
  Future deleteAllRecentSearchKeyword();
  Future<Either> getRecentArtists();
  Future<Either> getRecentAlbums();
  Future<Either> getRecentPlaylists();
}
