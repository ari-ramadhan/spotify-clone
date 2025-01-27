import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/domain/usecases/song/search_song_by_keyword.dart';
import 'package:spotify_clone/presentation/search/bloc/search_state.dart';
import 'package:spotify_clone/service_locator.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Timer? _debounce;

  void search(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      if (keyword.isEmpty) {
        emit(SearchInitial());
        return;
      }

      if (!isClosed) {
        emit(SearchLoading());
      }

      // Simulasi pencarian (ganti dengan API call atau logika pencarian Anda)
      final results = await sl<SearchSongByKeywordUseCase>().call(params: keyword);

      results.fold(
        (l) {
          emit(SearchError(l));
        },
        (r) {
          emit(SearchLoaded(r));
        },
      );
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
