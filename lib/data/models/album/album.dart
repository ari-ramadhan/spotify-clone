import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

class AlbumModel {
  String? name;
  String? albumId;
  String? createdAt;
  int ? songTotal;

  AlbumModel({
    required this.name,
    required this.albumId,
    required this.createdAt,
    required this.songTotal,
  });

  AlbumModel.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    albumId = data['album_id'];
    createdAt = data['created_year'].toString();
  }
}

extension AlbumModelX on AlbumModel {
  AlbumEntity toEntity() {
    return AlbumEntity(
      name: name!,
      albumId: albumId!,
      createdAt: createdAt!,
      songTotal: songTotal!,
    );
  }
}
