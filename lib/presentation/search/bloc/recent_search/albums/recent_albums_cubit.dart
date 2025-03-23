import 'dart:async';

import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/search/get_recent_albums.dart';
import 'package:spotify_clone/presentation/search/bloc/recent_search/albums/recent_albums_state.dart';

class RecentAlbumsCubit extends Cubit<RecentAlbumsState> {
  RecentAlbumsCubit() : super(RecentAlbumsInitial());

  Future<void> getRecentAlbums() async {
    if (isClosed) return; // Add this check
    emit(RecentAlbumsLoading());

    final results = await sl<GetRecentAlbumssUseCase>().call();

    if (isClosed) return; // Add this check
    results.fold(
      (l) {
        emit(RecentAlbumsError(errorMessage: l));
      },
      (r) {
        emit(RecentAlbumsLoaded(r));
      },
    );
  }
}
