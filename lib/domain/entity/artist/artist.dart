class ArtistEntity {
  int? id;
  String? name;
  String? description;
  String? careerStart;

  ArtistEntity({
    this.id,
    this.name,
    this.description,
    this.careerStart,
  });

}
class ArtistWithFollowing {
  final ArtistEntity artist;
  final bool isFollowed;

  const ArtistWithFollowing(this.artist, this.isFollowed);
}
