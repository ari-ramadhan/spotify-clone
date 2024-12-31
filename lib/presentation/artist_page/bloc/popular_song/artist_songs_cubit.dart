import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/song/get_artist_songs.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/popular_song/artist_songs_state.dart';

class ArtistSongsCubit extends Cubit<ArtistSongsState> {
  ArtistSongsCubit() : super(ArtistSongsLoading());

  Future<void> getPopularSong(int artistId) async {
    var album = await sl<GetArtistSongsUseCase>().call(params: artistId);

    album.fold(
      (l) {
        emit(ArtistSongsFailure());
      },
      (popularSongs) {
        emit(ArtistSongsLoaded(songEntity: popularSongs));
      },
    );
  }
}
