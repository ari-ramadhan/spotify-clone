import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
// ignore: unused_import
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

class SongTileWidget extends StatefulWidget {
  final List<SongWithFavorite> songList;
  final bool isOnHome;
  final bool isShowArtist;

  final int index;
  final Function(bool) onSelectionChanged;

  const SongTileWidget(
      {super.key,
      this.isOnHome = false,
      required this.index,
      required this.songList,
      this.isShowArtist = false,
      required this.onSelectionChanged});

  @override
  State<SongTileWidget> createState() => _SongTileWidgetState();
}

class _SongTileWidgetState extends State<SongTileWidget> {
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
    isSelected = isSelected;
  }

  void toggleSelected() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              widget.isOnHome
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
                        borderRadius: BorderRadius.circular(7.sp),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
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
                        color: textColor,
                        fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    widget.isOnHome || widget.isShowArtist
                        ? songEntity.song.artist
                        : '239.114',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: textColor,
                        fontSize: 11.sp),
                  ),
                ],
              )
            ],
          ),
          widget.isOnHome
              ? Row(
                  children: [
                    Text(
                      songEntity.song.duration.toString().replaceAll('.', ':'),
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    FavoriteButton(songs: songEntity)
                  ],
                )
              : Row(
                  children: [
                    Text(
                      songEntity.song.duration.toString(),
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      splashRadius: 18.sp,
                      icon: Icon(
                        Icons.playlist_add,
                        size: 17.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
