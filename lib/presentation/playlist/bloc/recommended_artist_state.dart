import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class GetRecommendedArtistsState {}

class GetRecommendedArtistsLoading extends GetRecommendedArtistsState {}

class GetRecommendedArtistsLoaded extends GetRecommendedArtistsState {
  final List<ArtistEntity> artists;

  GetRecommendedArtistsLoaded({required this.artists});
}

class GetRecommendedArtistsFailure extends GetRecommendedArtistsState {}
