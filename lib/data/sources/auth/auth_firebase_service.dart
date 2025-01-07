import 'package:dartz/dartz.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/data/models/auth/create_user_request.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';
import 'package:spotify_clone/data/models/auth/user.dart';
import 'package:spotify_clone/data/repository/auth/auth_service.dart';

abstract class AuthSupabaseService {
  Future<Either> signUp(CreateUserRequest createUserReq);
  Future<Either> signIn(SignInUserRequest signInUserReq);
  Future<Either> getUser();
}

class AuthSupabaseServiceImpl extends AuthSupabaseService {
  AuthService authService = AuthService();

  @override
  Future<Either> signIn(SignInUserRequest signInUserReq) async {
    try {
      // await FirebaseAuth.instance.signInWithEmailAndPassword(email: signInUserReq.email, password: signInUserReq.password);

      await supabase.auth.signInWithPassword(
          password: signInUserReq.password, email: signInUserReq.email);

      authService.saveLoginStatus(true);

      return const Right('Sign In was succesfull');
    } on AuthApiException catch (e) {
      String message = '';
      if (e.code!.contains("email")) {
        message = 'No user found for that email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that email';
      }
      return Left(message);
    }
  }

  @override
  Future<Either> signUp(CreateUserRequest createUserReq) async {
    try {
      // await FirebaseAuth.instance.createUserWithEmailAndPassword(email: createUserReq.email, password: createUserReq.password);

      await supabase.auth.signUp(
          password: createUserReq.password, email: createUserReq.email);

      await supabase.from('users').insert({
        "email": createUserReq.email,
        "name": createUserReq.fullName,
        // "uid" : data.user!.id
      });

      authService.saveLoginStatus(true);

      return const Right('Sign Up was succesfull');
    } on AuthApiException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password is too weak';
      } else if (e.code!.contains('exists')) {
        message = 'An account already exists with that email';
      }
      return Left(message);
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      var data = await supabase
          .from('users')
          .select('*')
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();

      // print(data);

      UserModel userModel = UserModel.fromJson(data);
      // userModel.imageUrl = AppURLs.defaultProfile;

      // UserEntity userEntity = userModel.toEntity();

      // print(userEntity.fullName);
      // print(userEntity.email);

      return Right(userModel);
    } catch (e) {
      return const Left('An error has occured');
    }
  }
}
