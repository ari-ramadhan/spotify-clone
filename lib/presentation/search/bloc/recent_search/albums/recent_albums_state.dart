import 'package:spotify_clone/presentation/home/bloc/top_album/top_album_state.dart';

abstract class RecentAlbumsState {}

class RecentAlbumsInitial extends RecentAlbumsState {}

class RecentAlbumsLoading extends RecentAlbumsState {}

class RecentAlbumsLoaded extends RecentAlbumsState {
  final List<AlbumDetail> albums; // Map hasil pencarian
  RecentAlbumsLoaded(this.albums);
}

class RecentAlbumsError extends RecentAlbumsState {
  final String errorMessage;

  RecentAlbumsError({required this.errorMessage});
}
