import 'package:spotify_clone/domain/entity/playlist/playlist.dart';
// ignore: unused_import
import 'package:spotify_clone/domain/entity/song/song.dart';

class PlaylistModel {
  String? id;
  String? createdAt;
  bool? isPublic;
  String? userId;
  String? name;
  String? description;
  // bool? isFavorite;

  PlaylistModel({
    required this.id,
    required this.createdAt,
    required this.isPublic,
    required this.userId,
    required this.name,
    required this.description,
  });

  PlaylistModel.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    createdAt = data['created_at'].toString();
    isPublic = data['is_public'];
    userId = data['user_id'];
    name = data['name'];
    description = data['description'];
  }
}

extension PlaylistModelX on PlaylistModel {
  PlaylistEntity toEntity() {
    return PlaylistEntity(
        id: id!,
        createdAt: createdAt!,
        isPublic: isPublic!,
        userId: userId!,
        name: name!,
        description: description!);
  }
}
