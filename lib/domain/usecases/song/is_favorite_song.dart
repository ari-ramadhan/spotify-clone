import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/domain/repository/song/song.dart';
import 'package:spotify_clone/service_locator.dart';

class IsFavoriteSongUseCase implements Usecase<bool , int> {
  @override
  Future<bool> call({int ? params}) async {
    return await sl<SongRepository>().isFavoriteSong(params!);
  }


}
