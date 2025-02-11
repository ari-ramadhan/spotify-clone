import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/follow_button/follow_button_cubit.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/follow_button/follow_button_state.dart';

import '../../../core/configs/constants/app_methods.dart';

class FollowArtistButton extends StatefulWidget {
  final ArtistWithFollowing artistEntity;
  const FollowArtistButton({Key? key, required this.artistEntity}) : super(key: key);

  @override
  _FollowArtistButtonState createState() => _FollowArtistButtonState();
}

class _FollowArtistButtonState extends State<FollowArtistButton> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowButtonCubit(),
      child: BlocBuilder<FollowButtonCubit, FollowButtonState>(
        builder: (context, state) {
          if (state is FollowButtonInitial) {
            return InkWell(
              onTap: () async {
                context.read<FollowButtonCubit>().followButtonUpdated(widget.artistEntity.artist.id!);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h).copyWith(left: 0),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                decoration: BoxDecoration(
                    color: widget.artistEntity.isFollowed ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: AppColors.primary,
                    ),
                    borderRadius: BorderRadius.circular(15.w)),
                child: widget.artistEntity.isFollowed
                    ? Text(
                        'Followed',
                        style: TextStyle(letterSpacing: 0.7, fontSize: 13.sp, color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    : Text(
                        'Follow',
                        style: TextStyle(letterSpacing: 0.7, fontSize: 13.sp, color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
              ),
            );
          }
          if (state is FollowButtonUpdated) {
            return InkWell(
              onTap: () async {
                context.read<FollowButtonCubit>().followButtonUpdated(widget.artistEntity.artist.id!);

                customSnackBar(
                    isSuccess: false,
                    text: (state.isFollowed ? 'Done unfollowing' : 'Done following') + widget.artistEntity.artist.name!,
                    context: context);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h).copyWith(left: 0),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                decoration: BoxDecoration(
                    color: state.isFollowed ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: AppColors.primary,
                    ),
                    borderRadius: BorderRadius.circular(15.w)),
                child: state.isFollowed
                    ? Text(
                        'Unfollow',
                        style: TextStyle(letterSpacing: 0.7, fontSize: 13.sp, color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    : Text(
                        'Follow',
                        style: TextStyle(letterSpacing: 0.7, fontSize: 13.sp, color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
