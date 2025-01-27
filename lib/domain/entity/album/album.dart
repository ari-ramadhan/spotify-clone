import 'package:spotify_clone/domain/entity/artist/artist.dart';

class AlbumEntity {
  String? name;
  String? albumId;
  String? createdAt;
  int? songTotal;

  AlbumEntity({
    required this.name,
    required this.albumId,
    required this.createdAt,
    required this.songTotal,
  });
}

class AlbumWithArtist {
  final AlbumEntity albumEntity;
  final ArtistEntity artistEntity;

  const AlbumWithArtist(this.albumEntity, this.artistEntity);
  AlbumWithArtist copyWith({AlbumEntity? albumEntity, ArtistEntity? artistEntity}) {
    return AlbumWithArtist(
      albumEntity ?? this.albumEntity,
      artistEntity ?? this.artistEntity,
    );
  }
}
