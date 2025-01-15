import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

class PlaylistSongTileWidget extends StatefulWidget {
  final List<SongWithFavorite> songList;
  final String playlistId;
  final int index;
  final Widget suffixActionButton;

  const PlaylistSongTileWidget({
    super.key,
    required this.index,
    required this.songList,
    required this.playlistId,
    required this.suffixActionButton,
  });

  @override
  State<PlaylistSongTileWidget> createState() => _PlaylistSongTileWidgetState();
}

class _PlaylistSongTileWidgetState extends State<PlaylistSongTileWidget> {

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
                  Text(
                    songEntity.song.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w500, color: textColor, fontSize: 14.sp),
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
                songEntity.song.duration.toString(),
                style: TextStyle(
                  color: textColor,
                ),
              ),
              SizedBox(
                height: 28.w,
                width: 28.w,

                child: widget.suffixActionButton)
            ],
          ),
        ],
      ),
    );
  }
}
