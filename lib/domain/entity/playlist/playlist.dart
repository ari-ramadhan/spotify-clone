
class PlaylistEntity {
  String? id;
  String? createdAt;
  bool? isPublic;
  String? userId;
  String? name;
  String? description;
  int? songCount;
  // bool? isFavorite;

  PlaylistEntity({
    required this.id,
    required this.createdAt,
    required this.isPublic,
    required this.userId,
    required this.name,
    required this.description,
    required this.songCount,
  });

}
