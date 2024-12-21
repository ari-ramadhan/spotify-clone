import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class FavoriteSongState {}

class FavoriteSongLoading extends FavoriteSongState{}
class FavoriteSongLoaded extends FavoriteSongState{
  final List<SongEntity> songs;

  FavoriteSongLoaded({required this.songs});
}
class FavoriteSongFailure extends FavoriteSongState{}
