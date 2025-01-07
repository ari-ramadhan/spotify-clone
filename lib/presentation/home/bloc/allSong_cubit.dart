import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/song/get_play_list.dart';
import 'package:spotify_clone/presentation/home/bloc/allSong_state.dart';
import 'package:spotify_clone/service_locator.dart';

class AllSongCubit extends Cubit<AllSongState> {
  AllSongCubit() : super(AllSongLoading());

  Future<void> getAllSong() async {
    var returnedSongs = await sl<GetPlaylistUseCase>().call();

    returnedSongs.fold(
      (l) {
        emit(AllSongLoadFailure());
      },
      (data) {
        if (!isClosed) {
          emit(AllSongLoaded(songs: data));
        }
      },
    );
  }
}
