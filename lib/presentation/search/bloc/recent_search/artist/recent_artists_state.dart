import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class RecentArtistsState {}

class RecentArtistsInitial extends RecentArtistsState {}

class RecentArtistsLoading extends RecentArtistsState {}

class RecentArtistsLoaded extends RecentArtistsState {
  final List<ArtistEntity> artist; // Map hasil pencarian
  RecentArtistsLoaded(this.artist);
}

class RecentArtistsError extends RecentArtistsState {
  final String errorMessage;

  RecentArtistsError({required this.errorMessage});
}
