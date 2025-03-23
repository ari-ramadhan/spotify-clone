import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/search/recent_search.dart';
import 'package:spotify_clone/service_locator.dart';

class GetRecentSearchKeywordUseCase implements Usecase<List<String>, dynamic> {
  @override
  Future<List<String>> call({params}) async {
    return await sl<RecentSearchRepository>().getLocalRecentSearchKeyword();
  }
}
