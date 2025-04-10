import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class SearchSongForPlaylistState {}

class SearchSongForPlaylistInitial extends SearchSongForPlaylistState {}

class SearchSongForPlaylistLoading extends SearchSongForPlaylistState {}

class SearchSongForPlaylistLoaded extends SearchSongForPlaylistState {
  final List<SongWithFavorite> songs;

  SearchSongForPlaylistLoaded({required this.songs});
}

class SearchSongForPlaylistFailure extends SearchSongForPlaylistState {}
