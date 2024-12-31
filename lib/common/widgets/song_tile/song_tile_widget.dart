import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

class SongTileWidget extends StatelessWidget {
  final SongWithFavorite songEntity;
  final bool isOnHome;

  const SongTileWidget({
    super.key,
    this.isOnHome = false,
    required this.songEntity,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              isOnHome
                  ? Container(
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
                    )
                  : Container(
                      height: 40.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.h),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              '${AppURLs.supabaseCoverStorage}${songEntity.song.artist} - ${songEntity.song.title}.jpg'),
                        ),
                      ),
                    ),
              SizedBox(
                width: 14.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    songEntity.song.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.86),
                        fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    isOnHome ? songEntity.song.artist : '239.114',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                        fontSize: 11.sp),
                  ),
                ],
              )
            ],
          ),
          isOnHome
              ? Row(
                  children: [
                    Text(songEntity.song.duration
                        .toString()
                        .replaceAll('.', ':')),
                    SizedBox(
                      width: 10.w,
                    ),
                    FavoriteButton(songs: songEntity)
                  ],
                )
              : Row(
                  children: [
                    Text(songEntity.song.duration.toString()),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.playlist_add,
                          color: AppColors.primary,
                        )),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
