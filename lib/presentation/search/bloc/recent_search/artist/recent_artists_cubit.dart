import 'dart:async';

import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/search/get_recent_artists.dart';
import 'package:spotify_clone/presentation/search/bloc/recent_search/artist/recent_artists_state.dart';

class RecentArtistsCubit extends Cubit<RecentArtistsState> {
  RecentArtistsCubit() : super(RecentArtistsInitial());

  Future<void> getRecentArtists() async {
    if (isClosed) return; // Add this check
    emit(RecentArtistsLoading());

    final results = await sl<GetRecentArtistsUseCase>().call();

    if (isClosed) return; // Add this check
    results.fold(
      (l) {
        emit(RecentArtistsError(errorMessage: l));
      },
      (r) {
        emit(RecentArtistsLoaded(r));
      },
    );
  }
}
