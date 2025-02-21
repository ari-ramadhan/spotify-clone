import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/artist/artist.dart';
import 'package:spotify_clone/service_locator.dart';

class HotArtistsUseCase implements Usecase<Either , dynamic> {
  @override
  Future<Either> call({params }) async {
    return sl<ArtistRepository>().getHotArtists();

  }

}
