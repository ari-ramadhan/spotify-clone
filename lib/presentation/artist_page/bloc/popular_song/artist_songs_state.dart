import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

abstract class ArtistSongsState {}

class ArtistSongsLoading extends ArtistSongsState{}
class ArtistSongsLoaded extends ArtistSongsState{

  final List<SongWithFavorite> songEntity;

  ArtistSongsLoaded({required this.songEntity});

}
class ArtistSongsFailure extends ArtistSongsState{}
