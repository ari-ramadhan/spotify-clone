import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/domain/repository/search/recent_search.dart';
import 'package:spotify_clone/service_locator.dart';

class DeleteRecentSearchKeywordUseCase implements Usecase<dynamic, String> {
  @override
  Future<dynamic> call({required params}) async {
    return await sl<RecentSearchRepository>().deleteRecentSearchKeyword(params);
  }
}
