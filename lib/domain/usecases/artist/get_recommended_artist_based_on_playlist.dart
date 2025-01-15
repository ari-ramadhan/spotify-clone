import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/artist/artist.dart';
import 'package:spotify_clone/service_locator.dart';

class GetRecommendedArtistBasedOnPlaylistUseCase implements Usecase<Either , List<String>> {
  @override
  Future<Either> call({List<String> ? params}) async {
    return sl<ArtistRepository>().getRecommendedArtistBasedOnPlaylist(params!);

  }

}
