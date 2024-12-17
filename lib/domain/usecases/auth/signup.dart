import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/models/auth/create_user_request.dart';
import 'package:spotify_clone/domain/repository/auth/auth.dart';
import 'package:spotify_clone/service_locator.dart';

class SignUpUseCase implements Usecase<Either , CreateUserRequest> {
  @override
  Future<Either> call({CreateUserRequest ? params}) async {
    return sl<AuthRepository>().signUp(params!);

  }

}
