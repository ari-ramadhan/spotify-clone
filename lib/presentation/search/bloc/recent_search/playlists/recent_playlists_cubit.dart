import 'dart:async';

import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/search/get_recent_playlists.dart';
import 'package:spotify_clone/presentation/search/bloc/recent_search/playlists/recent_playlists_state.dart';

class RecentPlaylistsCubit extends Cubit<RecentPlaylistsState> {
  RecentPlaylistsCubit() : super(RecentPlaylistsInitial());

  Future<void> getRecentPlaylists() async {
    if (isClosed) return; // Add this check
    emit(RecentPlaylistsLoading());

    final results = await sl<GetRecentPlaylistsUseCase>().call();

    if (isClosed) return; // Add this check
    results.fold(
      (l) {
        emit(RecentPlaylistsError(errorMessage: l));
      },
      (r) {
        emit(RecentPlaylistsLoaded(r));
      },
    );
  }
}
