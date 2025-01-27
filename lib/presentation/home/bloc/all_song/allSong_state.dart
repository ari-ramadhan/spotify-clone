import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class AllSongState {

}

class AllSongLoading extends AllSongState {

}
class AllSongLoaded extends AllSongState {
  final List<SongWithFavorite> songs;

  AllSongLoaded({required this.songs});

}
class AllSongLoadFailure extends AllSongState {

}
