import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/home/bloc/news_song/news_songs_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/news_song/news_songs_state.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

class NewsSongs extends StatelessWidget {
  const NewsSongs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsSongsCubit, NewsSongsState>(
      builder: (context, state) {
        if (state is NewsSongsLoading) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20.w),
            child: Row(
              children: [
                SkeletonNewsSongCard(),
                SkeletonNewsSongCard(),
                SkeletonNewsSongCard(),
                SkeletonNewsSongCard(),
              ],
            ),
          );

          return const Center(child: CircularProgressIndicator());
        }

        if (state is NewsSongsLoaded) {
          return _songs(context, state.songs);
        }

        return const Center(
          child: Text('No songs available.'),
        );
      },
    );
  }

  Widget _songs(BuildContext context, List<SongWithFavorite> songs) {
    if (songs.isEmpty) {
      return const Center(child: Text('No songs available.'));
    }

    return ListView.separated(
      padding: EdgeInsets.only(left: 24.sp),
      scrollDirection: Axis.horizontal,
      itemCount: songs.length,
      separatorBuilder: (context, index) => SizedBox(width: 14.w),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SongPlayerPage(
                  songs: songs, // Daftar lengkap lagu
                  startIndex: index, // Indeks lagu yang dipilih
                ),
              ),
            );
          },
          child: _songItem(context, songs[index], index, songs.length),
        );
      },
    );
  }

  Widget _songItem(
    BuildContext context,
    SongWithFavorite song,
    int index,
    int totalSongs,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        right: index == (totalSongs - 1) ? 10.w : 0,
      ),
      child: SizedBox(
        width: 111.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        '${AppURLs.supabaseCoverStorage}${song.song.artist} - ${song.song.title}.jpg'),
                    // NetworkImage(
                    //   '${AppURLs.supabaseCoverStorage}${song.song.artist} - ${song.song.title}.jpg',
                    // ),
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 34.w,
                    width: 34.w,
                    transform: Matrix4.translationValues(-7.w, 10.h, 0),
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
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    song.song.artist,
                    style: TextStyle(
                      fontSize: 12.7.sp,
                      fontWeight: FontWeight.w400,
                      color: context.isDarkMode
                          ? const Color(0xffC6C6C6)
                          : const Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonNewsSongCard extends StatelessWidget {
  const SkeletonNewsSongCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 12.w
      ),
      child: SizedBox(
        width: 111.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Skeletonizer(
                enabled: true,
                ignoreContainers: false,
                child: Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.sp),
                    color: Colors.grey.shade800
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer(
                    enabled: true,
                    textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(0)),
                    child: Text(
                      'data data',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Skeletonizer(
                    enabled: true,
                    textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(0)),
                    child: Text(
                      'data',
                      style: TextStyle(
                        fontSize: 12.7.sp,
                        fontWeight: FontWeight.w400,
                        color: context.isDarkMode
                            ? const Color(0xffC6C6C6)
                            : const Color(0xff000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
