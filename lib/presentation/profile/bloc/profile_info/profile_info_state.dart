import 'package:spotify_clone/data/models/auth/user.dart';

abstract class ProfileInfoState {}

class ProfileInfoLoading extends ProfileInfoState{}
class ProfileInfoLoaded extends ProfileInfoState{
  final UserModel userEntity;

  ProfileInfoLoaded({required this.userEntity});
}
class ProfileInfoFailure extends ProfileInfoState{}
