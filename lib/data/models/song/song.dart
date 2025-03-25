import 'package:spotify_clone/domain/entity/song/song.dart';

class SongModel {
  int? id;
  String? title;
  String? artist;
  num? duration;
  String? releaseDate;
  int? artistId;
  String? albumName;
  int? playCount;
  String? albumId;
  // bool? isFavorite;

  SongModel(
      {required this.title,
      required this.artist,
      required this.id,
      required this.duration,
      required this.playCount,
      // required this.isFavorite,
      required this.releaseDate});

  SongModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration'];
    releaseDate = data['release_date'];
    artistId = data['artist_id'];
    playCount = data['play_count'];
    id = data['id'];
  }
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
        id: id!,
        title: title!,
        artist: artist!,
        artistId: artistId!,
        playCount: playCount!,
        // isFavorite: isFavorite!,
        duration: duration!,
        releaseDate: releaseDate!);
  }
}
