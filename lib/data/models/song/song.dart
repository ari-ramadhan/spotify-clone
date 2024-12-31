import 'package:spotify_clone/domain/entity/song/song.dart';

class SongModel {
  int? id;
  String? title;
  String? artist;
  num? duration;
  String? releaseDate;
  int? artistId;
  // bool? isFavorite;

  SongModel(
      {required this.title,
      required this.artist,
      required this.id,
      required this.duration,
      // required this.isFavorite,
      required this.releaseDate});

  SongModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration'];
    releaseDate = data['release_date'];
    artistId = data['artist_id'];
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
        // isFavorite: isFavorite!,
        duration: duration!,
        releaseDate: releaseDate!);
  }
}
