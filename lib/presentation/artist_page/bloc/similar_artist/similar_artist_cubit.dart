import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/artist/get_all_artist.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/similar_artist/similar_artist_state.dart';

class SimilarArtistCubit extends Cubit<SimilarArtistState> {
  SimilarArtistCubit() : super(SimilarArtistLoading());

  Future<void> getArtists() async {
    var artist = await sl<GetAllArtistUseCase>().call();

    artist.fold(
      (l) {
        emit(SimilarArtistFailure());
      },
      (similarArtist) {
        if (!isClosed) {
          emit(SimilarArtistLoaded(artistEntity: similarArtist));
        }
      },
    );
  }
}
