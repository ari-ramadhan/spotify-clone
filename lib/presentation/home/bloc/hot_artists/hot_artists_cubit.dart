import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/artist/hot_artists.dart';
import 'package:spotify_clone/presentation/home/bloc/hot_artists/hot_artists_state.dart';
import 'package:spotify_clone/service_locator.dart';

class HotArtistsCubit extends Cubit<HotArtistsState> {
  HotArtistsCubit() : super(HotArtistsLoading());

  Future<void> getHotArtists() async {
    var returnedArtists = await sl<HotArtistsUseCase>().call();

    returnedArtists.fold(
      (l) {
        emit(HotArtistsLoadFailure());
      },
      (data) {
        if (!isClosed) {
          emit(HotArtistsLoaded(artists: data));
        }
      },
    );
  }
}
