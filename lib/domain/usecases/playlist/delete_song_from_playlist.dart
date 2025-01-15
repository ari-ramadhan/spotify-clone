import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/playlist/playlist.dart';
import 'package:spotify_clone/service_locator.dart';

class DeleteSongFromPlaylistParams {
  final String playlistId;
  final int songId;

  DeleteSongFromPlaylistParams({
    required this.playlistId,
    required this.songId,
  });
}

class DeleteSongFromPlaylistUseCase implements Usecase<Either, DeleteSongFromPlaylistParams> {
  @override
  Future<Either> call({required DeleteSongFromPlaylistParams params}) async {
    return await sl<PlaylistRepository>().deleteSongFromPlaylist(
      params.playlistId,
      params.songId,
    );
  }
}
