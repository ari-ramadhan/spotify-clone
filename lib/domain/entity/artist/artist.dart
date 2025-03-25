class ArtistEntity {
  int? id;
  String? name;
  String? description;
  String? careerStart;
  int? monthlyListeners;

  ArtistEntity({
    this.id,
    this.name,
    this.description,
    this.careerStart,
    this.monthlyListeners,
  });
}

class ArtistWithFollowing {
  final ArtistEntity artist;
  final bool isFollowed;

  const ArtistWithFollowing(this.artist, this.isFollowed);
}
