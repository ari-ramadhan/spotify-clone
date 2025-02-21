import 'package:spotify_clone/domain/entity/artist/artist.dart';

abstract class SimilarArtistState {}

class SimilarArtistLoading extends SimilarArtistState{}
class SimilarArtistLoaded extends SimilarArtistState{


  final List<ArtistWithFollowing> artistEntity;


  SimilarArtistLoaded({required this.artistEntity});

}
class SimilarArtistFailure extends SimilarArtistState{}
