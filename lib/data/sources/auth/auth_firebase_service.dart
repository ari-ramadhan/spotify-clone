import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_clone/data/models/auth/create_user_request.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';
import 'package:spotify_clone/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthSupabaseService {

  Future<Either> signUp (CreateUserRequest createUserReq);
  Future<Either> signIn (SignInUserRequest signInUserReq);

}

class AuthSupabaseServiceImpl extends AuthSupabaseService {

  @override
  Future<Either> signIn(SignInUserRequest signInUserReq) async {
    try {
      // await FirebaseAuth.instance.signInWithEmailAndPassword(email: signInUserReq.email, password: signInUserReq.password);

      await supabase.auth.signInWithPassword(password: signInUserReq.password, email: signInUserReq.email);

      return Right('Sign In was succesfull');

    } on AuthApiException catch (e){
      String message = '';
      if (e.code!.contains("email")) {
        message = 'No user found for that email';
      } else if (e.code == 'invalid-credential'){
        message = 'Wrong password provided for that email';
      }
      return Left(message);

    }
  }

  @override
  Future<Either> signUp(CreateUserRequest createUserReq) async  {
    try {
      var data = await supabase.auth.signUp(password: createUserReq.password, email: createUserReq.email);
      // await FirebaseAuth.instance.createUserWithEmailAndPassword(email: createUserReq.email, password: createUserReq.password);

      await supabase.from('users').insert({
        "email" : createUserReq.email,
        "name" : createUserReq.fullName
      });



      return const Right('Sign Up was succesfull');

    } on AuthApiException catch (e){
      String message = '';
      print(e.code);
      if (e.code == 'weak-password') {
        message = 'The password is too weak';
      } else if (e.code!.contains('exists')){
        message = 'An account already exists with that email';

      }
      print(message);
      return Left(message);

    }
  }

}
