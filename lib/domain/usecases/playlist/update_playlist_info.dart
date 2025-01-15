import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/playlist/playlist.dart';
import 'package:spotify_clone/service_locator.dart';

class UpdatePlaylistInfoParams {
  final String playlistId;
  final String title;
  final String description;

  UpdatePlaylistInfoParams({
    required this.playlistId,
    required this.title,
    required this.description,
  });
}

class UpdatePlaylistInfoUseCase
    implements Usecase<Either, UpdatePlaylistInfoParams> {
  @override
  Future<Either> call({required UpdatePlaylistInfoParams params}) async {
    return await sl<PlaylistRepository>().updatePlaylistInfo(
        params.playlistId, params.title, params.description);
  }
}
