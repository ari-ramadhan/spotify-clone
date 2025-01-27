import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class NewsSongsState {

}

class NewsSongsLoading extends NewsSongsState {

}
class NewsSongsLoaded extends NewsSongsState {
  final List<SongWithFavorite> songs;

  NewsSongsLoaded({required this.songs});

}
class NewsSongsLoadFailure extends NewsSongsState {

}
