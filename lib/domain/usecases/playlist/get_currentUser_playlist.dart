import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/playlist/playlist.dart';
import 'package:spotify_clone/service_locator.dart';

class GetCurrentuserPlaylistUseCase implements Usecase<Either, String> {
  @override
  Future<Either> call({String ? params}) async {
    return await sl<PlaylistRepository>().getCurrentUserPlaylists(params!);
  }

}
