
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/user/user.dart';
import 'package:spotify_clone/service_locator.dart';

class UpdateUsernameUseCase implements Usecase<Either , String> {
  @override
  Future<Either> call({String ? params}) async {
    return await sl<UserRepository>().updateUsername(params!);
  }

}
