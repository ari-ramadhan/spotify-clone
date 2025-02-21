import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class SearchSongState {}

class SearchSongInitial extends SearchSongState {}

class SearchSongLoading extends SearchSongState {}

class SearchSongLoaded extends SearchSongState {
  final List<SongWithFavorite> songs;

  SearchSongLoaded({required this.songs});
}

class SearchSongFailure extends SearchSongState {
  final String error;

  SearchSongFailure({required this.error});
}
