import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/playlist/playlist.dart';
import 'package:spotify_clone/service_locator.dart';

class AddSongByKeywordParams {
  final String playlistId;
  final String title;

  AddSongByKeywordParams({
    required this.playlistId,
    required this.title,
  });
}

class AddSongByKeywordUseCase implements Usecase<Either, AddSongByKeywordParams> {
  @override
  Future<Either> call({required AddSongByKeywordParams params}) async {
    return await sl<PlaylistRepository>().addSongByKeyword(
      params.playlistId,
      params.title,
    );
  }
}
