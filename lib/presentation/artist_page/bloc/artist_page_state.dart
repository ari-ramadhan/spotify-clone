import 'package:spotify_clone/domain/entity/artist/artist.dart';

abstract class ArtistPageState {}

class ArtistPageLoading extends ArtistPageState {}
class ArtistPageLoaded extends ArtistPageState {
  final ArtistEntity artistEntity;

  ArtistPageLoaded({required this.artistEntity});

}
class ArtistPageFailure extends ArtistPageState {}
