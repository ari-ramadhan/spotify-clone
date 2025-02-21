import 'dart:async';

import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/song/popular_songs_from_fav_artist.dart';
import 'package:spotify_clone/presentation/search/bloc/popular_song/popular_song_cubit.dart';

class PopularSongCubit extends Cubit<PopularSongState> {
  PopularSongCubit() : super(PopularSongInitial());

  Future<void> getPopularSongFromFavArtists() async {
    emit(PopularSongLoading());


    final results = await sl<PopularSongsFromFavArtistUseCase>().call();

    await Future.delayed(const Duration(milliseconds: 1200));

    results.fold(
      (l) {
        emit(PopularSongError(l));
      },
      (r) {
        emit(PopularSongLoaded(r));
      },
    );
  }
}
