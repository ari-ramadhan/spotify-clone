import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/song/get_playlist_songs.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_state.dart';

class PlaylistSongsCubit extends Cubit<PlaylistSongsState> {
  PlaylistSongsCubit() : super(PlaylistSongsLoading());

  Future<void> getPlaylistSongs(String playlistId) async {
    var playlistSongs = await sl<GetPlaylistSongsUseCase>().call(params: playlistId);

    playlistSongs.fold(
      (l) {
        emit(PlaylistSongsFailure());
      },
      (playlistSong) {
        emit(PlaylistSongsLoaded(songs: playlistSong));
      },
    );
  }
}
