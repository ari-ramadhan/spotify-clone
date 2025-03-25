class SongEntity {
  final int id;
  final String title;
  final String artist;
  final num duration;
  final String releaseDate;
  final int playCount;
  final int artistId;
  // final bool isFavorite;

  SongEntity(
      {required this.title,
      // required this.isFavorite,
      required this.id,
      required this.artist,
      required this.duration,
      required this.playCount,
      required this.artistId,
      required this.releaseDate});

  SongEntity toEmpty() {
    return SongEntity(
        title: '',
        id: 0,
        artist: '',
        duration: 0,
        artistId: 0,
        playCount: 0,
        releaseDate: '');
  }
}

class SongWithFavorite {
  final SongEntity song;
  final bool isFavorite;

  const SongWithFavorite(this.song, this.isFavorite);
  SongWithFavorite copyWith({SongEntity? song, bool? isFavorite}) {
    return SongWithFavorite(
      song ?? this.song,
      isFavorite ?? this.isFavorite,
    );
  }
}
