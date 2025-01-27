import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/presentation/artist_page/pages/artist_page.dart';

class ArtistTileWidget extends StatelessWidget {
  final ArtistEntity artist;
  final bool isOnSearch;
  const ArtistTileWidget({
    super.key,
    required this.artist,
    this.isOnSearch = false,

  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistPage(artistId: artist.id!),
          ),
        );
      },
      splashColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 5.h).copyWith(right: 6.5.w),
      child: Row(
        children: [
          Container(
            height: 40.h,
            width: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  '${AppURLs.supabaseArtistStorage}${artist.name!.toLowerCase()}.jpg',
                ),
              ),
            ),
          ),
          SizedBox(
            width: 14.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artist.name!,
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  'Artist',
                  style: TextStyle(fontSize: 10.sp, color: Colors.white70),
                ),
              ],
            ),
          ),
          isOnSearch ? Row(
            children: [
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
              ),
              SizedBox(
                width: 10.w,
              )
            ],
          ) : const SizedBox.shrink()
        ],
      ),
    );
  }
}
