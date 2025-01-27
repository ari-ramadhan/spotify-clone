import 'package:spotify_clone/domain/entity/artist/artist.dart';

abstract class FollowedArtistsState {}

class FollowedArtistsLoading extends FollowedArtistsState{}
class FollowedArtistsLoaded extends FollowedArtistsState{
  final List<ArtistWithFollowing> artists;

  FollowedArtistsLoaded({required this.artists});
}
class FollowedArtistsFailure extends FollowedArtistsState{}
