import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/models/auth/create_user_request.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';
import 'package:spotify_clone/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify_clone/domain/repository/auth/auth.dart';
import 'package:spotify_clone/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository{
  @override
  Future<Either> signIn(SignInUserRequest signInUserReq) async {
      return await sl<AuthSupabaseService>().signIn(signInUserReq);
  }

  @override
  Future<Either> signUp(CreateUserRequest createUserReq) async {
      return await sl<AuthSupabaseService>().signUp(createUserReq);
  }



}
