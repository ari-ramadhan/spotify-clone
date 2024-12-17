class SongEntity {
  final int id;
  final String title;
  final String artist;
  final num duration;
  final String releaseDate;
  // final bool isFavorite;

  SongEntity(
      {required this.title,
      // required this.isFavorite,
      required this.id,
      required this.artist,
      required this.duration,
      required this.releaseDate});
}
class SongWithFavorite {
  final SongEntity song;
  final bool isFavorite;

  const SongWithFavorite(this.song, this.isFavorite);
}
