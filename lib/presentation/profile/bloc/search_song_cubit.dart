import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/song/search_song.dart';
import 'package:spotify_clone/service_locator.dart';
import 'search_song_state.dart';

class SearchSongCubit extends Cubit<SearchSongState> {
  SearchSongCubit() : super(SearchSongInitial());

  Timer? _debounce;

  void search(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      if (keyword.isEmpty) {
        emit(SearchSongInitial());
        return;
      }

      if (!isClosed) {
        emit(SearchSongLoading());
      }

      // Simulasi pencarian (ganti dengan API call atau logika pencarian Anda)
      final results = await sl<SearchSongUseCase>().call(params: keyword);

      results.fold(
        (l) {
          emit(SearchSongFailure(error: l));
        },
        (r) {
          emit(SearchSongLoaded(songs: r));
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
