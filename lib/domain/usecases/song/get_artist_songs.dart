import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/song/song.dart';
import 'package:spotify_clone/service_locator.dart';

class GetArtistSongsUseCase implements Usecase<Either , int> {
  @override
  Future<Either> call({int ? params}) async {
    return await sl<SongRepository>().getArtistSongs(params!);
  }

}