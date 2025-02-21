import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class PopularSongState {}
class PopularSongInitial extends PopularSongState {}

class PopularSongLoading extends PopularSongState {}

class PopularSongLoaded extends PopularSongState {
  final SongAndArtistList results; // Map hasil pencarian
  PopularSongLoaded(this.results);
}

class PopularSongError extends PopularSongState {
  final String message;
  PopularSongError(this.message);
}

class SongAndArtistList {
  final List<SongWithFavorite> songs;
  final List<ArtistEntity> artists;
  SongAndArtistList(this.songs, this.artists);
}
