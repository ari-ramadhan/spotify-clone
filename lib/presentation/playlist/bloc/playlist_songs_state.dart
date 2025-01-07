import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class PlaylistSongsState {}

class PlaylistSongsLoading extends PlaylistSongsState {}

class PlaylistSongsLoaded extends PlaylistSongsState {
  final List<SongWithFavorite> songs;

  PlaylistSongsLoaded({required this.songs});
}

class PlaylistSongsFailure extends PlaylistSongsState {}
