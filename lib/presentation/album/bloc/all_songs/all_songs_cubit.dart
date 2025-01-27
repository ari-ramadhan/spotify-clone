import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/album/get_all_songs.dart';
import 'package:spotify_clone/presentation/album/bloc/all_songs/all_songs_state.dart';

class AllSongsCubit extends Cubit<AllSongsState> {
  AllSongsCubit() : super(AllSongsLoading());

  Future<void> getAllSongs(int artistId) async {
    var allSongs = await sl<GetAllSongsUseCase>().call(params: artistId);

    allSongs.fold(
      (l) {
        emit(AllSongsFailure());
      },
      (songs) {
        if (!isClosed) {
          emit(AllSongsLoaded(songs: songs));
        }
      },
    );
  }
}
