import 'package:spotify_clone/data/models/auth/user.dart';
import 'package:spotify_clone/domain/entity/auth/user.dart';

abstract class ProfileInfoState {}

class ProfileInfoLoading extends ProfileInfoState{}
class ProfileInfoLoaded extends ProfileInfoState{
  final UserModel userEntity;

  ProfileInfoLoaded({required this.userEntity});
}
class ProfileInfoFailure extends ProfileInfoState{}
