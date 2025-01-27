import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class RecentSongsState {

}

class RecentSongsLoading extends RecentSongsState {

}
class RecentSongsLoaded extends RecentSongsState {
  final List<SongWithFavorite> songs;

  RecentSongsLoaded({required this.songs});

}
class RecentSongsFailure extends RecentSongsState {

}
