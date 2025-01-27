import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/user/get_followerAndFollowing.dart';
import 'package:spotify_clone/presentation/profile/bloc/follower_and_following/follower_state.dart';
import 'package:spotify_clone/service_locator.dart';

class FollowerCubit extends Cubit<FollowerState> {
  FollowerCubit() : super(FollowerLoading());

  Future getFollowerAndFollowing(String userId) async {
    var followerAndFollowing = await sl<GetFollowerandfollowingUseCase>().call(params: userId);

    followerAndFollowing.fold(
      (l) {
        emit(FollowerFailure());
      },
      (followerList) {
        if (!isClosed) {
          emit(FollowerLoaded(followEntity: followerList));
        }
      },
    );
  }
}
