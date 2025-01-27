import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/song/get_recent_songs.dart';
import 'package:spotify_clone/presentation/home/bloc/recent_songs/recent_songs_state.dart';
import 'package:spotify_clone/service_locator.dart';

class RecentSongsCubit extends Cubit<RecentSongsState> {
  RecentSongsCubit() : super(RecentSongsLoading());

  Future<void> getRecentSongs() async {
    var returnedSongs = await sl<GetRecentSongsUseCase>().call();

    returnedSongs.fold(
      (l) {
        emit(RecentSongsFailure());
      },
      (data) {
        if (!isClosed) {
          emit(RecentSongsLoaded(songs: data));
        }
      },
    );
  }
}
