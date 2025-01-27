import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/domain/repository/user/user.dart';
import 'package:spotify_clone/service_locator.dart';

class CheckFollowingStatusUseCase implements Usecase<bool , String> {
  @override
  Future<bool> call({String ? params}) async {
    return await sl<UserRepository>().isFollowed(params!);
  }

}
