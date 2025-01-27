import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/song/get_artist_single_songs.dart';
import 'package:spotify_clone/presentation/album/bloc/single_songs/single_songs_state.dart';

class SingleSongsCubit extends Cubit<SingleSongsState> {
  SingleSongsCubit() : super(SingleSongsLoading());

  Future<void> getSingleSongs(int artistId) async {
    var singleSongs = await sl<GetArtistSingleSongs>().call(params: artistId);

    singleSongs.fold(
      (l) {
        emit(SingleSongsFailure());
      },
      (songs) {
        emit(SingleSongsLoaded(songs: songs));
      },
    );
  }
}
