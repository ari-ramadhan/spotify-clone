import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/home/bloc/news_songs_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/news_songs_state.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

class NewsSongs extends StatelessWidget {
  const NewsSongs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsSongsCubit()..getNewsSongs(),
      child: SizedBox(
          // height: 200,
          child: BlocBuilder<NewsSongsCubit, NewsSongsState>(
            builder: (context, state) {
              if (state is NewsSongsLoading) {
                return Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator());
              }

              if (state is NewsSongsLoaded) {
                return _songs(state.songs);
              }

              return Container();
            },
          )),
    );
  }

  Widget _songs(List<SongWithFavorite> songs) {
    return ListView.separated(
      padding: EdgeInsets.only(left: 24.sp),
      scrollDirection: Axis.horizontal,
      itemCount: songs.length,
      separatorBuilder: (context, index) {
        return SizedBox(
          width: 14.w,
        );
      },
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SongPlayerPage(songEntity: songs[index],)));
          },
          child: Padding(
            padding: EdgeInsets.only(
                // left: index == 0 ? 0 : 0,
                right: index == (songs.length - 1) ? 10.w : 0),
            child: SizedBox(
              width: 135.w,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.sp),
                        image: DecorationImage(
                          fit: BoxFit.cover,

                          image: NetworkImage(
                              '${AppURLs.supabaseCoverStorage}${songs[index].song.artist} - ${songs[index].song.title}.jpg'),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 35.h,
                          width: 35.w,
                          transform: Matrix4.translationValues(-15.w, 13.h, 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.isDarkMode
                                ? AppColors.darkGrey
                                : Color(0xffE6E6E6),
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: context.isDarkMode
                                ? Color(0xff959595)
                                : Color(0xff555555),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songs[index].song.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          songs[index].song.artist,
                          style: TextStyle(
                              fontSize: 12.7.sp,
                              fontWeight: FontWeight.w400,
                              color: context.isDarkMode ? Color(0xffC6C6C6) : Color(0xff000000)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


}
