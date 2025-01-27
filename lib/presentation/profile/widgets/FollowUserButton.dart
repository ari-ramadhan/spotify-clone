import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entity/auth/user.dart';
import 'package:spotify_clone/domain/usecases/user/check_following_status.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/follow_button/follow_button_state.dart';
import 'package:spotify_clone/presentation/profile/bloc/follow_user_button/follow_user_cubit.dart';

import '../../../service_locator.dart';

class FollowUserButton extends StatefulWidget {
  final UserWithStatus user;
  const FollowUserButton({Key? key, required this.user}) : super(key: key);

  @override
  _FollowUserButtonState createState() => _FollowUserButtonState();
}



class _FollowUserButtonState extends State<FollowUserButton> {

  bool isFollowed = false;

  @override
  void initState() {
    isFollowing();
    super.initState();
  }

  Future isFollowing () async {
    var result = await sl<CheckFollowingStatusUseCase>().call(params: widget.user.userEntity.userId);
    setState(() {
      isFollowed = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowUserButtonCubit(),
      child: BlocBuilder<FollowUserButtonCubit, FollowButtonState>(
        builder: (context, state) {
          if (state is FollowButtonInitial) {
            return MaterialButton(
              highlightColor: Colors.black,
              color: isFollowed ? Colors.black : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.sp),
                side: const BorderSide(color: Colors.white),
              ),
              onPressed: () async {
                context.read<FollowUserButtonCubit>().followButtonUpdated(widget.user.userEntity.userId!);
              },
              child: Text(isFollowed ? 'Unfollow' : 'Follow'),
            );
          }

          if (state is FollowButtonUpdated) {
            return MaterialButton(
              highlightColor: Colors.black,
              color: state.isFollowed ? Colors.black : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.sp),
                side: const BorderSide(color: Colors.white),
              ),
              onPressed: () async {
                context.read<FollowUserButtonCubit>().followButtonUpdated(widget.user.userEntity.userId!);

                var unfollowSnackbar = SnackBar(
                  content: Row(
                    children: [
                      Text(
                        'Done unfollowing ${widget.user.userEntity.fullName!}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.blue,
                  behavior: SnackBarBehavior.floating,
                );

                var followSnackbar = SnackBar(
                  content: Text(
                    'Done following ${widget.user.userEntity.fullName!}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                );

                ScaffoldMessenger.of(context).showSnackBar(state.isFollowed ? unfollowSnackbar : followSnackbar);
              },
              child: Text(state.isFollowed ? 'Unfollow' : 'Follow'),
            );
          }
          return Container();
        },
      ),
    );
  }
}
