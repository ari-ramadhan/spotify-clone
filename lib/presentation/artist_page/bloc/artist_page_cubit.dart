import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/artist/get_artist_info.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/artist_page_state.dart';
import 'package:spotify_clone/service_locator.dart';

class ArtistPageCubit extends Cubit<ArtistPageState> {
  ArtistPageCubit() : super(ArtistPageLoading());

  Future<void> getArtist(int artistId) async {
    var artist = await sl<GetArtistInfoUseCase>().call(params: artistId);

    artist.fold(
      (l) {
        emit(ArtistPageFailure());
      },
      (artistEntity) {
        emit(ArtistPageLoaded(artistEntity: artistEntity));
      },
    );
  }
}
