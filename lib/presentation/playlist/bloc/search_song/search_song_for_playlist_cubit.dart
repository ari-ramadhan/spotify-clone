import 'dart:async';

import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/song/search_song.dart';
import 'package:spotify_clone/presentation/playlist/bloc/search_song/search_song_for_playlist_state.dart';

class SearchSongForPlaylistCubit extends Cubit<SearchSongForPlaylistState> {
  SearchSongForPlaylistCubit() : super(SearchSongForPlaylistInitial());

  Future<void> searchSongByKeyword(String keyword) async {
    emit(SearchSongForPlaylistLoading());

    final results = await sl<SearchSongUseCase>().call(params: keyword);

    results.fold(
      (l) {
        emit(SearchSongForPlaylistFailure());
      },
      (r) {
        emit(SearchSongForPlaylistLoaded(songs: r));
      },
    );
  }

  Future<void> restartState() async {
    emit(SearchSongForPlaylistInitial());
  }
}
