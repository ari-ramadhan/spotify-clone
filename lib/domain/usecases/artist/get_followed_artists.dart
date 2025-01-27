import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/artist/artist.dart';
import 'package:spotify_clone/service_locator.dart';

class GetFollowedArtistsUseCase implements Usecase<Either , String> {
  @override
  Future<Either> call({String ? params}) async {
    return sl<ArtistRepository>().getFollowedArtists(params!);

  }

}
