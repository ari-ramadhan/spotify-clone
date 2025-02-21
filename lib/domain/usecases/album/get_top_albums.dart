import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/album/album.dart';
import 'package:spotify_clone/service_locator.dart';

class GetTopAlbumsUseCase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return sl<AlbumRepository>().getTopAlbums();
  }

}
