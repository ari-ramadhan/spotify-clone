import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/home/bloc/allSong_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/allSong_state.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

class AllSongPage extends StatefulWidget {
  const AllSongPage({super.key});

  @override
  State<AllSongPage> createState() => _AllSongPageState();
}

class _AllSongPageState extends State<AllSongPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllSongCubit, AllSongState>(
      builder: (context, state) {
        if (state is AllSongLoading) {
          return Container(
              padding: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: const CircularProgressIndicator());
        }

        if (state is AllSongLoaded) {
          return Container(
            // padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 22.w)
            //     .copyWith(right: 15.w, top: 20.h),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Playlist',
                        style: TextStyle(
                          fontSize: 16.2.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'See more',
                        style: TextStyle(
                            fontSize: 11.sp, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
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
    );
  }

  Widget _songs(List<SongWithFavorite> songs) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(left: 6.w),
      shrinkWrap: true,
      itemCount: songs.length,
      itemBuilder: (context, index) {
        // bool isFav = true;

        var songTitle = songs[index].song.title;
        if (songs[index].song.title.length > 25) {
          songTitle = "${songTitle.substring(0, 22)}..";
        }

        return SongTileWidget(
            songList: songs,
            isOnHome: true,
            index: index,
            onSelectionChanged: (isSelected) {});
      },
      // separatorBuilder: (context, index) {
      //   return SizedBox(
      //     height: 13.h,
      //   );
      // },
    );
  }
}
