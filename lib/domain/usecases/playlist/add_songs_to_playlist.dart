import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/playlist/playlist.dart';
import 'package:spotify_clone/service_locator.dart';

class AddSongsToPlaylistParams {
  final String playlistId;
  final List selectedSongs;

  AddSongsToPlaylistParams({
    required this.playlistId,
    required this.selectedSongs,
  });
}

class AddSongsToPlaylistUseCase implements Usecase<Either, AddSongsToPlaylistParams> {
  @override
  Future<Either> call({required AddSongsToPlaylistParams params}) async {
    return await sl<PlaylistRepository>().addSongsToPlaylist(
      params.playlistId,
      params.selectedSongs,
    );
  }
}
