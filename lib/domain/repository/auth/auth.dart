import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/models/auth/create_user_request.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';

abstract class AuthRepository {

  Future<Either> signIn (SignInUserRequest signInUserReq);
  Future<Either> signUp (CreateUserRequest createUserReq);
  Future<Either> getUser ();

}
