import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify_clone/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

class FavoriteButton extends StatelessWidget {
  final SongWithFavorite songs;
  final bool isBigger;
  const FavoriteButton({
    super.key,
    required this.songs,
    this.isBigger = false
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteButtonCubit(),
      child: BlocBuilder<FavoriteButtonCubit, FavoriteButtonState>(
        builder: (context, state) {
          if (state is FavoriteButtonInitial) {
            return IconButton(
              onPressed: () {
                context
                    .read<FavoriteButtonCubit>()
                    .favoriteButtonUpdated(songs.song.id);
              },
              icon: Icon(
                songs.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                size: isBigger ? 32.sp : 22.sp,
                color:
                    songs.isFavorite ? AppColors.primary : AppColors.darkGrey,
              ),
            );
          }
          if (state is FavoriteButtonUpdated) {
            return IconButton(
              onPressed: () {
                context
                    .read<FavoriteButtonCubit>()
                    .favoriteButtonUpdated(songs.song.id);
              },
              icon: Icon(
                state.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                size: isBigger ? 35.sp : 25.sp,
                color:
                    state.isFavorite ? AppColors.primary : AppColors.darkGrey,
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
