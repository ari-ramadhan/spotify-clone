import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/entity/playlist/playlist.dart';
import 'package:spotify_clone/domain/usecases/playlist/add_new_playlist.dart';
import 'package:spotify_clone/domain/usecases/playlist/delete_playlist.dart';
import 'package:spotify_clone/domain/usecases/playlist/get_currentUser_playlist.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_state.dart';
import 'package:spotify_clone/service_locator.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit() : super(PlaylistLoading());

  Future<void> getCurrentuserPlaylist(String userId) async {
    var playlists = await sl<GetCurrentuserPlaylistUseCase>().call(params: userId);

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

  Future<String> deletePlaylist(String playlistId) async {
    try {
      emit(PlaylistLoading());

      final deleteResult = await sl<DeletePlaylistUseCase>().call(params: playlistId);
      String returnObject = "";

      deleteResult.fold(
        (l) {
          emit(PlaylistFailure());
          returnObject = l;
        },
        (r) {
          if (state is PlaylistLoaded) {
            final currentState = state as PlaylistLoaded;

            final updatedPlaylists = List<PlaylistEntity>.from(currentState.playlistModel)..removeWhere((playlist) => playlist.id == playlistId);
            emit(PlaylistLoaded(playlistModel: updatedPlaylists));
          } else if (state is PlaylistLoading) {
            getCurrentuserPlaylist("");
          }
          returnObject = "success";
        },
      );
      return returnObject;
    } catch (e) {
      emit(PlaylistFailure());
      return "an error occured";
    }
  }

  Future<Either> createPlaylist({
    required String playlistTitle,
    required String playlistDesc,
    required bool isPublic,
    required List<int> selectedSongsId,
  }) async {
    var returnObject = '';

    try {
      final addSongResult = await sl<AddNewPlaylistUseCase>().call(
        params: AddNewPlaylistParams(
          title: playlistTitle,
          selectedSongs: selectedSongsId,
          description: '',
          isPublic: true,
        ),
      );

      addSongResult.fold(
        (l) {
          emit(PlaylistFailure());
          returnObject = l;
        },
        (r) async {
          final currentState = state as PlaylistLoaded;

          final updatedPlaylists = List<PlaylistEntity>.from(currentState.playlistModel)..add(r);

          emit(PlaylistLoaded(playlistModel: updatedPlaylists));

          returnObject = 'Playlist created';
        },
      );

      return Right(returnObject);
    } catch (e) {
      returnObject = 'an error occured';
      return Left(returnObject);
    }
  }
}
