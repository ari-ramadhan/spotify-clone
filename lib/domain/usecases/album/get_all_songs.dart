import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/song/song.dart';
import 'package:spotify_clone/service_locator.dart';

class GetAllSongsUseCase implements Usecase<Either , int> {
  @override
  Future<Either> call({int ?  params}) async {
    return sl<SongRepository>().getArtistSongs(params!);
  }

}
