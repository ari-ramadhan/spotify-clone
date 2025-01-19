import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/domain/repository/playlist/playlist.dart';
import 'package:spotify_clone/service_locator.dart';

class BatchAddToPlaylistParams {
  final String playlistId;
  final List<SongWithFavorite> songList;

  BatchAddToPlaylistParams({
    required this.playlistId,
    required this.songList,
  });
}

class BatchAddToPlaylistUseCase implements Usecase<Either, BatchAddToPlaylistParams> {
  @override
  Future<Either> call({required BatchAddToPlaylistParams params}) async {
    return await sl<PlaylistRepository>().batchAddToPlaylist(
      params.playlistId,
      params.songList,
    );
  }
}
