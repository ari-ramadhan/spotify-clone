import 'package:dartz/dartz.dart';

abstract class SongRepository {
  Future<Either> getNewsSongs ();
  Future<Either> getPlaylist ();
  Future<Either> getUserFavoriteSongs ();
  Future<Either> addOrRemoveFavoriteSong (int songId);
  Future<bool> isFavoriteSong (int songId);
  Future<Either> getArtistSongs (int artisId);
  Future<Either> getAlbumSongs (String albumId);
  Future<Either> getPlaylistSongs (String playlistId);
}
