import 'package:spotify_clone/domain/entity/artist/artist.dart';

abstract class HotArtistsState {}

class HotArtistsLoading extends HotArtistsState {}

class HotArtistsLoaded extends HotArtistsState {
  final List<ArtistEntity> artists;

  HotArtistsLoaded({required this.artists});
}

class HotArtistsLoadFailure extends HotArtistsState {}
