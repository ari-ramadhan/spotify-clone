import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/domain/repository/search/recent_search.dart';
import 'package:spotify_clone/service_locator.dart';

class DeleteAllRecentSearchKeywordUseCase implements Usecase<dynamic, dynamic> {
  @override
  Future<dynamic> call({params}) async {
    return await sl<RecentSearchRepository>().deleteAllRecentSearchKeyword();
  }
}
