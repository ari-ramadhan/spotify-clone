import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/playlist/playlist.dart';
import 'package:spotify_clone/service_locator.dart';

class AddNewPlaylistParams {
  final String title;
  final String description;
  final bool isPublic;
  final List selectedSongs;

  AddNewPlaylistParams({
    required this.title,
    required this.description,
    required this.isPublic,
    required this.selectedSongs,
  });
}

class AddNewPlaylistUseCase implements Usecase<Either, AddNewPlaylistParams> {
  @override
  Future<Either> call({required AddNewPlaylistParams params}) async {
    return await sl<PlaylistRepository>().addNewPlaylist(
      params.title,
      params.description,
      params.isPublic,
      params.selectedSongs,
    );
  }
}
