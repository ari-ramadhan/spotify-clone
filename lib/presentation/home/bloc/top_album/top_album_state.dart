import 'package:spotify_clone/data/models/album/album.dart';
import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';

abstract class TopAlbumsState {}

class TopAlbumsLoading extends TopAlbumsState {}

class TopAlbumsLoaded extends TopAlbumsState {
  final List<AlbumDetail> albums;

  TopAlbumsLoaded({required this.albums});
}

class TopAlbumsLoadFailure extends TopAlbumsState {}

class AlbumDetail {
  final AlbumEntity albumEnitity;
  final ArtistEntity artistEntity;
  // final String artistName;

  AlbumDetail({required this.albumEnitity, required this.artistEntity});
}
