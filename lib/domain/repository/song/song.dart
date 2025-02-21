import 'package:dartz/dartz.dart';

abstract class SongRepository {
  Future<Either> getNewsSongs ();
  Future<Either> getPlaylist ();
  Future<Either> getUserFavoriteSongs (String userId);
  Future<Either> addOrRemoveFavoriteSong (int songId);
  Future<bool> isFavoriteSong (int songId);
  Future<Either> getArtistSongs (int artisId);
  Future<Either> getAlbumSongs (String albumId);
  Future<Either> getPlaylistSongs (String playlistId);
  Future<Either> searchSongBasedOnKeyword(String playlistId);
  Future<Either> getRecentSongs();
  Future<Either> addRecentSongs(int songId);
  Future<Either> searchSongs(String keyword);
  Future<Either> popularSongsFromFavoriteArtists();
}
