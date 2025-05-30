import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_cubit.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

import '../../../core/configs/constants/app_methods.dart';
import '../../../service_locator.dart';

class PlaylistSongTileWidget extends StatefulWidget {
  final List<SongWithFavorite> songList;
  final String playlistId;
  final int index;

  const PlaylistSongTileWidget({
    super.key,
    required this.index,
    required this.songList,
    required this.playlistId,
  });

  @override
  State<PlaylistSongTileWidget> createState() => _PlaylistSongTileWidgetState();
}

class _PlaylistSongTileWidgetState extends State<PlaylistSongTileWidget> {
  @override
  Widget build(BuildContext context) {
    final songList = widget.songList[widget.index];
    final song = widget.songList[widget.index].song;
    String songDuration =
        song.duration.toString().replaceAll('.', ':');

    SongWithFavorite songEntity = widget.songList[widget.index];
    Color textColor = Colors.white;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SongPlayerPage(
              songs: widget.songList,
              startIndex: widget.index,
            ),
          ),
        );
        // Kode sebelumnya
      },
      splashColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 6.h).copyWith(right: 3.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 40.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.sp),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider('${AppURLs.supabaseCoverStorage}${songEntity.song.artist} - ${songEntity.song.title}.jpg'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 14.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        songEntity.song.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w500, color: textColor, fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      songEntity.song.artist,
                      style: TextStyle(fontWeight: FontWeight.w400, color: textColor, fontSize: 11.sp),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Text(
                  songDuration.length == 3
                                ? '${songDuration}0'
                                : songDuration,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                SizedBox(
                    // height: 28.w,
                    // width: 28.w,
                    child: PopupMenuButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.sp)),
                      menuPadding: EdgeInsets.zero,
                      // color: AppColors.medDarkBackground,
                      elevation: 1,
                      iconSize: 16.sp,
                      splashRadius: 15.sp,
                      offset: Offset(-11.w, 32.h),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          height: 28.h,
                          // padding: EdgeInsets.zero,
                          textStyle: TextStyle(fontSize: 12.sp),
                          onTap: () async {
                            var result =
                                await context.read<PlaylistSongsCubit>().removeSongFromPlaylist(widget.playlistId, widget.songList[widget.index]);
                            result.fold(
                              (l) {
                                customSnackBar(isSuccess: false, text: l, context: context);
                              },
                              (r) {
                                customSnackBar(isSuccess: true, text: r, context: context);
                              },
                            );
                          },
                          value: 'Remove',
                          child: Row(
                            children: [
                              Icon(
                                Icons.playlist_remove_rounded,
                                size: 17.sp,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              const Text(
                                'Remove',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          height: 28.h,
                          onTap: () async {
                            final newIsFavorite = await context.read<PlaylistSongsCubit>().toggleFavoriteStatus(song.id);
                            sl<AddOrRemoveFavoriteSongUseCase>().call(params: song.id);

                            if (newIsFavorite != null) {
                              final snackBarMessage = newIsFavorite ? 'Added to favorites' : 'Removed from favorites';

                              // Tampilkan SnackBar
                              customSnackBar(isSuccess: true, text: snackBarMessage, context: context);
                            }
                          },
                          textStyle: TextStyle(fontSize: 12.sp),
                          child: Row(
                            children: [
                              Icon(
                                songList.isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                size: 17.sp,
                                color: songList.isFavorite ? AppColors.primary : const IconThemeData().color,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                songList.isFavorite ? 'Remove from favorite' : 'Add to favorite',
                                style: TextStyle(color: songList.isFavorite ? AppColors.primary : Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
