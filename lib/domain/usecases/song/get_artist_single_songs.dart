import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/album/album.dart';
import 'package:spotify_clone/service_locator.dart';

class GetArtistSingleSongs implements Usecase<Either , int> {
  @override
  Future<Either> call({int ? params}) async {
    return await sl<AlbumRepository>().getArtistSingleSongs(params!);
  }

}
