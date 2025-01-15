abstract class FollowButtonState {}


class FollowButtonInitial extends FollowButtonState {}
class FollowButtonUpdated extends FollowButtonState {
  final bool isFollowed;

  FollowButtonUpdated({required this.isFollowed});



}
