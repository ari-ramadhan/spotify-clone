import 'package:spotify_clone/domain/entity/artist/artist.dart';

class ArtistModel {
  int? id;
  String? name;
  String? description;
  String? careerStart;

  ArtistModel({
    this.id,
    this.name,
    this.description,
    this.careerStart,
  });

  ArtistModel.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    careerStart = data['career_start'].toString();
  }
}

extension ArtistModelX on ArtistModel {
  ArtistEntity toEntity() {
    return ArtistEntity(
      id: id,
      name: name,
      description: description,
      careerStart: careerStart,
    );
  }
}
