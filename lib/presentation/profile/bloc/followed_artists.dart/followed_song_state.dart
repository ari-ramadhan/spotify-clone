import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class FollowedArtistsState {}

class FollowedArtistsLoading extends FollowedArtistsState{}
class FollowedArtistsLoaded extends FollowedArtistsState{
  final List<ArtistWithFollowing> artists;

  FollowedArtistsLoaded({required this.artists});
}
class FollowedArtistsFailure extends FollowedArtistsState{}
