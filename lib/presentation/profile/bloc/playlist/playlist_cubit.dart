import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/auth/get_user.dart';
import 'package:spotify_clone/domain/usecases/playlist/get_currentUser_playlist.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_state.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_info/profile_info_state.dart';
import 'package:spotify_clone/service_locator.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit() : super(PlaylistLoading());

  Future<void> getCurrentuserPlaylist() async {
    var playlists = await sl<GetCurrentuserPlaylistUseCase>().call();

    playlists.fold(
      (l) {
        emit(PlaylistFailure());
      },
      (playlist) {
        if (!isClosed) {
          emit(PlaylistLoaded(playlistModel: playlist));
        }
      },
    );
  }
}
