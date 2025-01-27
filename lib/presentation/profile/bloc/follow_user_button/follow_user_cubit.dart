import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/user/follow_user.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/follow_button/follow_button_state.dart';
import 'package:spotify_clone/service_locator.dart';

class FollowUserButtonCubit extends Cubit<FollowButtonState> {
  FollowUserButtonCubit() : super(FollowButtonInitial());

  void followButtonUpdated(String userId) async {
    var result = await sl<FollowUserUseCase>()
        .call(params: userId);

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
