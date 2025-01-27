import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/domain/repository/artist/artist.dart';
import 'package:spotify_clone/service_locator.dart';

class IsFollowingArtistUseCase implements Usecase<bool , int> {
  @override
  Future<bool> call({int ?  params}) async {
    return sl<ArtistRepository>().isFollowed(params!);

  }

}
