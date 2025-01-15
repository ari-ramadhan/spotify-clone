import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/artist/follow_unfollow_artist.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/follow_button/follow_button_state.dart';
import 'package:spotify_clone/service_locator.dart';

class FollowButtonCubit extends Cubit<FollowButtonState> {
  FollowButtonCubit() : super(FollowButtonInitial());

  void followButtonUpdated(int artistId) async {
    var result = await sl<FollowUnfollowArtistUseCase>()
        .call(params: artistId);

    result.fold(
      (l) {},
      (isFollowed) {
        emit(
          FollowButtonUpdated(isFollowed: isFollowed)
        );
      },
    );
  }
}
