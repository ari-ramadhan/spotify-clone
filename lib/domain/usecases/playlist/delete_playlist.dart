import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/playlist/playlist.dart';
import 'package:spotify_clone/service_locator.dart';

class DeletePlaylistUseCase implements Usecase<Either, String> {
  @override
  Future<Either> call({required params}) async {
    return await sl<PlaylistRepository>().deletePlaylist(params);
  }
}
