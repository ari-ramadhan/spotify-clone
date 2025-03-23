import 'dart:async';

import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/search/delete_all_recent_search_keyword.dart';
import 'package:spotify_clone/domain/usecases/search/delete_recent_search_keyword.dart';
import 'package:spotify_clone/domain/usecases/search/get_recent_search_keyword.dart';
import 'package:spotify_clone/presentation/search/bloc/recent_search/recent_search_state.dart';

class RecentSearchCubit extends Cubit<RecentSearchState> {
  RecentSearchCubit() : super(RecentSearchInitial());

  Future<void> getRecentSearchKeyword() async {
    if (isClosed) return; // Add this check
    emit(RecentSearchLoading());

    final results = await sl<GetRecentSearchKeywordUseCase>().call();

    if (isClosed) return; // Add this check
    results.isEmpty
        ? emit(RecentSearchError())
        : emit(RecentSearchLoaded(results));
  }

  Future deleteRecentSearchKeyword(String keyword) async {
    await sl<DeleteRecentSearchKeywordUseCase>().call(params: keyword);

    getRecentSearchKeyword();
  }

  Future deleteAllRecentSearchKeyword() async {
    await sl<DeleteAllRecentSearchKeywordUseCase>().call();

    getRecentSearchKeyword();
  }
}
