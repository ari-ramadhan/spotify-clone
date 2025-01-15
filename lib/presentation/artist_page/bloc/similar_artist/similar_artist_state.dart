import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class SimilarArtistState {}

class SimilarArtistLoading extends SimilarArtistState{}
class SimilarArtistLoaded extends SimilarArtistState{


  final List<ArtistWithFollowing> artistEntity;


  SimilarArtistLoaded({required this.artistEntity});

}
class SimilarArtistFailure extends SimilarArtistState{}
