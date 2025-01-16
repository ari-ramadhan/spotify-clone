// import 'package:dartz/dartz.dart';
// import 'package:spotify_clone/common/helpers/export.dart';
// import 'package:spotify_clone/domain/entity/song/song.dart';
// import 'package:spotify_clone/domain/usecases/playlist/add_song_by_keyword.dart';
// import 'package:spotify_clone/domain/usecases/playlist/add_songs_to_playlist.dart';
// import 'package:spotify_clone/domain/usecases/playlist/delete_song_from_playlist.dart';
// import 'package:spotify_clone/domain/usecases/song/get_playlist_songs.dart';
// import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_state.dart';

// class PlaylistSongsCubit extends Cubit<PlaylistSongsState> {
//   PlaylistSongsCubit() : super(PlaylistSongsLoading());

//   Future<void> getPlaylistSongs(String playlistId) async {
//     var playlistSongs = await sl<GetPlaylistSongsUseCase>().call(params: playlistId);

//     playlistSongs.fold(
//       (l) {
//         emit(PlaylistSongsFailure());
//       },
//       (playlistSong) {
//         if (!isClosed) {
//           emit(PlaylistSongsLoaded(songs: playlistSong));
//         }
//       },
//     );
//   }

//   Future<void> addSongToPlaylist(String playlistId, List<SongWithFavorite> songIds, BuildContext context) async {
//     List<int> selectedSongIds = songIds.map((song) => song.song.id).toList();

//     final addSongResult = await sl<AddSongsToPlaylistUseCase>().call(
//       params: AddSongsToPlaylistParams(playlistId: playlistId, selectedSongs: selectedSongIds),
//     );

//     addSongResult.fold(
//       (l) {
//         emit(PlaylistSongsFailure());
//       },
//       (r) async {
//         if (state is PlaylistSongsLoaded) {
//           final currentState = state as PlaylistSongsLoaded;

//           print("Before emit: ${currentState.songs.map((e) => e.song.title).toList()}");

//           final updatedSongs = List<SongWithFavorite>.from(currentState.songs)..addAll(songIds);

//           emit(PlaylistSongsLoaded(songs: updatedSongs));

//           print("After emit: ${updatedSongs.map((e) => e.song.title).toList()}");
//         } else {
//           print("State is not PlaylistSongsLoaded. Emitting new state...");
//           await getPlaylistSongs(playlistId); // Ensure state is refreshed
//         }
//       },
//     );
//   }

//   Future<void> addSongByKeyword(String playlistId, String keyword, List<SongWithFavorite> songList) async {
//     var addSongResult = await sl<AddSongByKeywordUseCase>().call(params: AddSongByKeywordParams(playlistId: playlistId, title: keyword));

//     addSongResult.fold(
//       (l) {},
//       (r) {
//         if (state is PlaylistSongsLoaded) {
//           final currentState = state as PlaylistSongsLoaded;
//           final updatedSongs = List<SongWithFavorite>.from(currentState.songs)..add(r);
//           emit(PlaylistSongsLoaded(songs: updatedSongs));
//         }
//       },
//     );
//   }

//   Future<void> removeSongFromPlaylist(String playlistId, SongWithFavorite song) async {
//     if (state is PlaylistSongsLoaded) {
//       final currentState = state as PlaylistSongsLoaded;

//       final result = await sl<DeleteSongFromPlaylistUseCase>().call(
//         params: DeleteSongFromPlaylistParams(playlistId: playlistId, songId: song.song.id),
//       );

//       result.fold(
//         (l) => emit(PlaylistSongsFailure()),
//         (r) {
//           final updatedSongs = List<SongWithFavorite>.from(currentState.songs)..removeWhere((s) => s.song.id == song.song.id);
//           emit(PlaylistSongsLoaded(songs: updatedSongs));
//         },
//       );
//     }
//   }
// }

import 'package:dartz/dartz.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/domain/usecases/playlist/add_song_by_keyword.dart';
import 'package:spotify_clone/domain/usecases/playlist/add_songs_to_playlist.dart';
import 'package:spotify_clone/domain/usecases/playlist/delete_song_from_playlist.dart';
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
        if (!isClosed) {
          emit(PlaylistSongsLoaded(songs: playlistSong));
        }
      },
    );
  }

  Future<void> addSongByKeyword(String playlistId, String keyword, List<SongWithFavorite> songList) async {
    var addSongResult = await sl<AddSongByKeywordUseCase>().call(params: AddSongByKeywordParams(playlistId: playlistId, title: keyword));

    addSongResult.fold(
      (l) {},
      (r) {
        if (state is PlaylistSongsLoaded) {
          final currentState = state as PlaylistSongsLoaded;
          final updatedSongs = List<SongWithFavorite>.from(currentState.songs)..add(r);
          emit(PlaylistSongsLoaded(songs: updatedSongs));
        }
      },
    );
  }

  Future<void> addSongToPlaylist(String playlistId, List<SongWithFavorite> songIds, BuildContext context) async {
    List<int> selectedSongIds = songIds.map((song) => song.song.id).toList();

    final addSongResult = await sl<AddSongsToPlaylistUseCase>().call(
      params: AddSongsToPlaylistParams(playlistId: playlistId, selectedSongs: selectedSongIds),
    );

    addSongResult.fold(
      (l) {
        emit(PlaylistSongsFailure());
      },
      (r) async {
        final currentState = state as PlaylistSongsLoaded;

        print("Before emit: ${currentState.songs.map((e) => e.song.title).toList()}");

        final updatedSongs = List<SongWithFavorite>.from(currentState.songs)..addAll(songIds);

        emit(PlaylistSongsLoaded(songs: updatedSongs));

        print("After emit: ${updatedSongs.map((e) => e.song.title).toList()}");
      },
    );
  }

  Future<Either> removeSongFromPlaylist(String playlistId, SongWithFavorite song) async {
    String message = '';

    try {
      if (state is PlaylistSongsLoaded) {
        final currentState = state as PlaylistSongsLoaded;

        final result = await sl<DeleteSongFromPlaylistUseCase>().call(
          params: DeleteSongFromPlaylistParams(playlistId: playlistId, songId: song.song.id),
        );

        result.fold(
          (l) {
            emit(PlaylistSongsFailure());
            message = l;
          },
          (r) {
            final updatedSongs = List<SongWithFavorite>.from(currentState.songs)..removeWhere((s) => s.song.id == song.song.id);
            emit(PlaylistSongsLoaded(songs: updatedSongs));
            message = r;
          },
        );
      }
      return Right(message);
    } catch (e) {
      message = 'Error while executing function';
      return Left(message);
    }
  }

  Future<bool?> toggleFavoriteStatus(int songId) async {
    final currentState = state;
    if (currentState is PlaylistSongsLoaded) {
      final updatedSongs = currentState.songs.map((song) {
        if (song.song.id == songId) {
          return song.copyWith(isFavorite: !song.isFavorite);
        }
        return song;
      }).toList();

      emit(PlaylistSongsLoaded(songs: updatedSongs));

      // Kembalikan status isFavorite terbaru
      return updatedSongs.firstWhere((song) => song.song.id == songId).isFavorite;
    }
    return null;
  }
}

// import 'package:dartz/dartz.dart';
// import 'package:spotify_clone/common/helpers/export.dart';
// import 'package:spotify_clone/domain/entity/song/song.dart';
// import 'package:spotify_clone/domain/usecases/playlist/add_songs_to_playlist.dart';
// import 'package:spotify_clone/domain/usecases/playlist/delete_song_from_playlist.dart';
// import 'package:spotify_clone/domain/usecases/song/get_playlist_songs.dart';
// import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_state.dart';

// class PlaylistSongsCubit extends Cubit<PlaylistSongsState> {
//   PlaylistSongsCubit() : super(PlaylistSongsLoading());

//   Future<void> getPlaylistSongs(String playlistId) async {
//     var playlistSongs = await sl<GetPlaylistSongsUseCase>().call(params: playlistId);

//     playlistSongs.fold(
//       (l) {
//         emit(PlaylistSongsFailure());
//       },
//       (playlistSong) {
//         if (!isClosed) {
//           emit(PlaylistSongsLoaded(songs: playlistSong));
//         }
//       },
//     );
//   }

//   Future<void> addSongToPlaylist(String playlistId, List<SongWithFavorite> songIds, BuildContext context) async {
//     List<int> selectedSongIds = songIds.map((song) => song.song.id).toList();

//     final addSongResult = await sl<AddSongsToPlaylistUseCase>().call(
//       params: AddSongsToPlaylistParams(playlistId: playlistId, selectedSongs: selectedSongIds),
//     );

//     addSongResult.fold(
//       (l) {
//         emit(PlaylistSongsFailure());
//       },
//       (r) async {
//         if (state is PlaylistSongsLoaded) {
//           final currentState = state as PlaylistSongsLoaded;

//           print("Before emit: ${currentState.songs.map((e) => e.song.title).toList()}");

//           final updatedSongs = List<SongWithFavorite>.from(currentState.songs)..addAll(songIds);

//           emit(PlaylistSongsLoaded(songs: updatedSongs));

//           print("After emit: ${updatedSongs.map((e) => e.song.title).toList()}");

//         } else {
//           print("State is not PlaylistSongsLoaded. Emitting new state...");
//           await getPlaylistSongs(playlistId); // Ensure state is refreshed
//         }
//       },
//     );
//   }

// }
