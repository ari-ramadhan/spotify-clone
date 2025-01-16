import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/artist/get_followed_artists.dart';
import 'package:spotify_clone/presentation/profile/bloc/followed_artists.dart/followed_song_state.dart';
import 'package:spotify_clone/service_locator.dart';

class FollowedArtistsCubit extends Cubit<FollowedArtistsState> {
  FollowedArtistsCubit() : super(FollowedArtistsLoading());

  Future<void> getFollowedArtists() async {
    var followedArtists = await sl<GetFollowedArtistsUseCase>().call();

    followedArtists.fold(
      (l) {
        emit(FollowedArtistsFailure());
      },
      (followedArtist) {
        if (!isClosed) {
          emit(FollowedArtistsLoaded(artists: followedArtist));
        }

        // emit(FavoriteSongLoaded(songs: favoriteSong));
      },
    );
  }
}
