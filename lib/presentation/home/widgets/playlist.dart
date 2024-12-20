import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/home/bloc/play_list_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/play_list_state.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlayListCubit()..getPlaylist(),
      child: BlocBuilder<PlayListCubit, PlayListState>(
        builder: (context, state) {
          if (state is PlaylistLoading) {
            return Container(
                padding: const EdgeInsets.only(top: 30),
                alignment: Alignment.center,
                child: const CircularProgressIndicator());
          }

          if (state is PlaylistLoaded) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 22.w).copyWith(right: 15.w, top: 20.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Playlist',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'See more',
                        style: TextStyle(
                            fontSize: 11.sp, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  _songs(state.songs)
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _songs(List<SongWithFavorite> songs) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // bool isFav = true;

          var songTitle = songs[index].song.title;
          if (songs[index].song.title.length > 25) {
            songTitle = "${songTitle.substring(0, 22)}..";
          }

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SongPlayerPage(
                        songEntity: songs[index],
                      )));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 35.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.isDarkMode
                            ? AppColors.darkGrey
                            : const Color(0xffE6E6E6),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: context.isDarkMode
                            ? const Color(0xff959595)
                            : const Color(0xff555555),
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songTitle,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14.sp),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          songs[index].song.artist,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 11.sp),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(songs[index]
                        .song
                        .duration
                        .toString()
                        .replaceAll('.', ':')),
                    SizedBox(
                      width: 10.w,
                    ),
                    FavoriteButton(songs: songs[index])
                  ],
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return  SizedBox(
            height: 13.h,
          );
        },
        itemCount: songs.length);
  }
}
