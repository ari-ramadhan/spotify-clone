import 'package:spotify_clone/domain/entity/playlist/playlist.dart';

abstract class RecentPlaylistsState {}

class RecentPlaylistsInitial extends RecentPlaylistsState {}

class RecentPlaylistsLoading extends RecentPlaylistsState {}

class RecentPlaylistsLoaded extends RecentPlaylistsState {
  final List<PlaylistEntity> playlists; // Map hasil pencarian
  RecentPlaylistsLoaded(this.playlists);
}

class RecentPlaylistsError extends RecentPlaylistsState {
  final String errorMessage;

  RecentPlaylistsError({required this.errorMessage});
}
