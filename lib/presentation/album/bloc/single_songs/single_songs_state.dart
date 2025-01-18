import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class SingleSongsState {}

class SingleSongsLoading extends SingleSongsState {}

class SingleSongsLoaded extends SingleSongsState {
  final List<SongWithFavorite> songs;

  SingleSongsLoaded({required this.songs});
}

class SingleSongsFailure extends SingleSongsState {}
