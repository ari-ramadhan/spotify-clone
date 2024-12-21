import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerPage extends StatelessWidget {
  final SongWithFavorite songEntity;
  const SongPlayerPage({super.key, required this.songEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        onTap: () async {
          // await context
          //           .read<SongPlayerCubit>().close;
          Navigator.pop(context);
        },
        title: Text(
          'Now playing',
          style: TextStyle(
            fontSize: 16.sp,
            color: context.isDarkMode ? Colors.white : Colors.black
          ),
        ),
        action: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_vert_rounded,
            color: context.isDarkMode ? Colors.white : Colors.black
          ),
        ),
      ),
      body: BlocProvider(

        create: (context) => SongPlayerCubit()
          ..loadSong(
              '${AppURLs.supabaseSongStorage}${songEntity.song.artist} - ${songEntity.song.title}.mp3'),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
          child: Column(
            children: [
              _songCover(context),
              SizedBox(
                height: 20.h,
              ),
              _songDetail(),
              SizedBox(
                height: 24.h,
              ),
              _songPlayer(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight / 2.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              '${AppURLs.supabaseCoverStorage}${songEntity.song.artist} - ${songEntity.song.title}.jpg',
            ),
          )),
    );
  }

  Widget _songDetail() {
    var title = songEntity.song.title;
    if (songEntity.song.title.length > 26) {
      title = "${title.substring(0, 24)}..";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.sp),
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              songEntity.song.artist,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  // letterSpacing: 0.6,
                  fontSize: 16.4.sp),
            ),
          ],
        ),
        FavoriteButton(songs: songEntity, isBigger: true,)
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(

      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return const CircularProgressIndicator();
        }
        if (state is SongPlayerLoaded) {
          return Column(
            children: [
              Slider(
                thumbColor: AppColors.grey,
                activeColor: AppColors.grey,
                inactiveColor: AppColors.darkGrey,
                value: context
                    .read<SongPlayerCubit>()
                    .songPosition
                    .inSeconds
                    .toDouble(),
                min: 0,
                max: context
                    .read<SongPlayerCubit>()
                    .songDuration
                    .inSeconds
                    .toDouble(),
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(
                        context.read<SongPlayerCubit>().songPosition),
                  ),
                  Text(
                    formatDuration(
                        context.read<SongPlayerCubit>().songDuration),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  context.read<SongPlayerCubit>().playOrPauseSong();
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.primary),
                  child: Icon(
                      context.read<SongPlayerCubit>().audioPlayer.playing
                          ? Icons.pause
                          : Icons.play_arrow,
                          color: context.isDarkMode ? Colors.black : Colors.white,
                          ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          );
        }

        return Container();
      },
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
