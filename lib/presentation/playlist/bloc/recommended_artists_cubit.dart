import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/artist/get_recommended_artist_based_on_playlist.dart';
import 'package:spotify_clone/presentation/playlist/bloc/recommended_artist_state.dart';

class GetRecommendedArtistsCubit extends Cubit<GetRecommendedArtistsState> {
  GetRecommendedArtistsCubit() : super(GetRecommendedArtistsLoading());

  Future<void> getRecommendedArtists(List<String> artistsName) async {
    var artists = await sl<GetRecommendedArtistBasedOnPlaylistUseCase>().call(params: artistsName);

    artists.fold(
      (l) {
        emit(GetRecommendedArtistsFailure());
      },
      (artistList) {
        if (!isClosed) {
          emit(GetRecommendedArtistsLoaded(artists: artistList));
        }
      },
    );
  }
}
