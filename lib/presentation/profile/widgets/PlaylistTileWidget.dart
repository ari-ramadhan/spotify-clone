import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/domain/entity/playlist/playlist.dart';

class PlaylistTileWidget extends StatelessWidget {
  final VoidCallback onTap;
  const PlaylistTileWidget({
    super.key,
    required this.playlist,
    required this.onTap,
  });

  final PlaylistEntity playlist;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 14.w),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40.h,
                width: 44.w,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff091e3a),
                      Color(0xff2d6cbe),
                      Color(0xff64a9dd),
                    ],
                    stops: [0, 0.5, 0.75],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: SvgPicture.asset(
                    AppVectors.playlist,
                    color: Colors.white,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name!,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    playlist.songCount == 0 ? 'Playlist | empty song' : 'Playlist | ${playlist.songCount} songs',
                    style: TextStyle(fontSize: 10.sp, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
