import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class PlayListState {

}

class PlaylistLoading extends PlayListState {

}
class PlaylistLoaded extends PlayListState {
  final List<SongWithFavorite> songs;

  PlaylistLoaded({required this.songs});

}
class PlaylistLoadFailure extends PlayListState {

}
