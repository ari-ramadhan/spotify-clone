import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/song/get_album_songs.dart';
import 'package:spotify_clone/presentation/album/bloc/artist_album/artist_album_state.dart';

class AlbumSongsCubit extends Cubit<AlbumSongsState> {
  AlbumSongsCubit() : super(AlbumSongsLoading());

  Future<void> getAlbumSongs(String albumId) async {
    var albumSongs = await sl<GetAlbumSongsUseCase>().call(params: albumId);

    albumSongs.fold(
      (l) {
        emit(AlbumSongsFailure());
      },
      (albumSong) {
        if (!isClosed) {
          emit(AlbumSongsLoaded(songs: albumSong));
        }
      },
    );
  }
}
