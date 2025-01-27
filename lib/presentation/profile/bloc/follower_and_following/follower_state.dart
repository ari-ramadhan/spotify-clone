import 'package:spotify_clone/domain/entity/auth/user.dart';

abstract class FollowerState {}

class FollowerLoading extends FollowerState{}
class FollowerLoaded extends FollowerState{
  final FollowerAndFollowing followEntity;

  FollowerLoaded({required this.followEntity});


}
class FollowerFailure extends FollowerState{}
