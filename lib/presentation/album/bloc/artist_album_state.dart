import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class AlbumSongsState {}

class AlbumSongsLoading extends AlbumSongsState {}

class AlbumSongsLoaded extends AlbumSongsState {
  final List<SongWithFavorite> songs;

  AlbumSongsLoaded({required this.songs});
}

class AlbumSongsFailure extends AlbumSongsState {}
