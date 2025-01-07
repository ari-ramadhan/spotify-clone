import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class AllSongsState {}

class AllSongsLoading extends AllSongsState {}

class AllSongsLoaded extends AllSongsState {
  final List<SongWithFavorite> songs;

  AllSongsLoaded({required this.songs});
}

class AllSongsFailure extends AllSongsState {}
