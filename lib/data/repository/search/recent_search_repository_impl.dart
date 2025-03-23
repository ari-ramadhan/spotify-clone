import 'package:dartz/dartz.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/data/sources/search/search_supabase_service.dart';
import 'package:spotify_clone/domain/repository/search/recent_search.dart';

class RecentSearchRepositoryImpl implements RecentSearchRepository {
  @override
  Future<List<String>> getLocalRecentSearchKeyword() {
    return sl<SearchSupabaseService>().getLocalRecentSearchKeyword();
  }

  @override
  Future setLocalRecentSearchKeyword(String keyword) {
    return sl<SearchSupabaseService>().setLocalRecentSearchKeyword(keyword);
  }

  @override
  Future deleteRecentSearchKeyword(String keyword) {
    return sl<SearchSupabaseService>().deleteRecentSearchKeyword(keyword);
  }

  @override
  Future deleteAllRecentSearchKeyword() {
    return sl<SearchSupabaseService>().deleteAllRecentSearchKeyword();
  }

  @override
  Future<Either> getRecentAlbums() {
    return sl<SearchSupabaseService>().getRecentAlbums();
  }

  @override
  Future<Either> getRecentArtists() {
    return sl<SearchSupabaseService>().getRecentArtists();
  }

  @override
  Future<Either> getRecentPlaylists() {
    return sl<SearchSupabaseService>().getRecentPlaylists();
  }
}
