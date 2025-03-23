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
    var playlists =
        await sl<GetCurrentuserPlaylistUseCase>().call(params: userId);

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
      emit(PlaylistLoading()); // Emit loading state before deleting

      final deleteResult =
          await sl<DeletePlaylistUseCase>().call(params: playlistId);
      String returnObject = "";

      deleteResult.fold(
        (l) {
          emit(PlaylistFailure()); // Emit failure state if deletion fails
          returnObject = l;
        },
        (r) {
          // IMPORTANT: Check the state before casting
          if (state is PlaylistLoaded) {
            final currentState = state as PlaylistLoaded;
            // final updatedPlaylists = currentState.playlistModel.where((playlist) => playlist.id != playlistId).toList();

            final updatedPlaylists =
                List<PlaylistEntity>.from(currentState.playlistModel)
                  ..removeWhere((playlist) => playlist.id == playlistId);
            emit(PlaylistLoaded(
                playlistModel: updatedPlaylists)); // Emit updated state
          } else if (state is PlaylistLoading) {
            // Handle the case where the state is PlaylistLoading (though unlikely at this point)
            // You might want to re-fetch the data or show a message.
            getCurrentuserPlaylist("");
          }
          returnObject = "success";
        },
      );
      return returnObject;
    } catch (e) {
      emit(PlaylistFailure()); // Emit failure state if an exception occurs
      return "an error occured";
    }
  }

  // Future<void> deletePlaylist(String playlistId) async {
  //   try {
  //     var currentState = state as PlaylistLoaded;
  //     final updatedPlaylists = currentState.playlistModel.where((playlist) => playlist.id != playlistId).toList();

  //     emit(PlaylistLoaded(playlistModel: updatedPlaylists));
  //   } catch (e) {
  //     emit(PlaylistFailure());
  //   }
  // }

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

          final updatedPlaylists =
              List<PlaylistEntity>.from(currentState.playlistModel)..add(r);

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
