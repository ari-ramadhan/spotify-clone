import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/domain/entity/auth/user.dart';
import 'package:spotify_clone/domain/usecases/user/check_following_status.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/follow_button/follow_button_state.dart';
import 'package:spotify_clone/presentation/profile/bloc/follow_user_button/follow_user_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/follower_and_following/follower_cubit.dart';
import 'package:spotify_clone/service_locator.dart';

class FollowUserButton extends StatefulWidget {
  final UserWithStatus user;
  const FollowUserButton({super.key, required this.user});

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

  Future isFollowing() async {
    var result = await sl<CheckFollowingStatusUseCase>()
        .call(params: widget.user.userEntity.userId);

    if (!mounted) return; // Prevent calling setState after disposal

    setState(() {
      isFollowed = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowUserButtonCubit(),
      child: BlocListener<FollowUserButtonCubit, FollowButtonState>(
        listener: (context, state) {
          if (state is FollowButtonUpdated) {
            // Update follower count based on the new state
            if (state.isFollowed) {
              context.read<FollowerCubit>().incrementFollowerCount();
            } else {
              context.read<FollowerCubit>().decrementFollowerCount();
            }
          }
        },
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
                  context
                      .read<FollowUserButtonCubit>()
                      .followButtonUpdated(widget.user.userEntity.userId!);
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
                  context
                      .read<FollowUserButtonCubit>()
                      .followButtonUpdated(widget.user.userEntity.userId!);
                },
                child: Text(state.isFollowed ? 'Unfollow' : 'Follow'),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
