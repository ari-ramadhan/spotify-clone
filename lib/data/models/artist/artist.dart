import 'package:spotify_clone/domain/entity/artist/artist.dart';

class ArtistModel {
  int? id;
  String? name;
  String? description;
  String? careerStart;
  int? monthlyListeners;

  ArtistModel({
    this.id,
    this.name,
    this.description,
    this.careerStart,
    this.monthlyListeners,
  });

  ArtistModel.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    careerStart = data['career_start'].toString();
    monthlyListeners = data['monthly_listeners'];
  }
}

extension ArtistModelX on ArtistModel {
  ArtistEntity toEntity() {
    return ArtistEntity(
      id: id,
      name: name,
      description: description,
      careerStart: careerStart,
      monthlyListeners: monthlyListeners,
    );
  }
}
