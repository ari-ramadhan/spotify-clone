import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/song/user_favorite_songs.dart';
import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_state.dart';
import 'package:spotify_clone/service_locator.dart';

class FavoriteSongCubit extends Cubit<FavoriteSongState> {
  FavoriteSongCubit() : super(FavoriteSongLoading());

  Future<void> getFavoriteSongs(String userId) async {
    var favoriteSongs = await sl<GetUserFavoriteSongUseCase>().call(params: userId);

    favoriteSongs.fold(
      (l) {
        emit(FavoriteSongFailure());
      },
      (favoriteSong) {
        if (!isClosed) {
          emit(FavoriteSongLoaded(songs: favoriteSong));
        }

        // emit(FavoriteSongLoaded(songs: favoriteSong));
      },
    );
  }
}
