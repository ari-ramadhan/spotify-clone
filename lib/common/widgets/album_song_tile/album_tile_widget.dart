import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/presentation/album/page/all_songs.dart';
import 'package:spotify_clone/presentation/album/page/artist_album.dart';

class AlbumTileWidget extends StatelessWidget {
  final AlbumEntity album;
  final ArtistEntity artist;
  final double leftPadding;
  final double rightPadding;
  final bool isAllSong;
  final bool isOnAlbumPage;
  const AlbumTileWidget({
    super.key,
    required this.album,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.isAllSong = false,
    this.isOnAlbumPage = false,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isAllSong
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AllSongsPage(
                    artist: artist,
                  ),
                ),
              )
            : isOnAlbumPage
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArtistAlbum(
                        album: album,
                        artist: artist,
                      ),
                    ),
                  )
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArtistAlbum(
                        album: album,
                        artist: artist,
                      ),
                    ),
                  );
      },
      child: Container(
        padding:
            EdgeInsets.only(left: leftPadding, right: rightPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80.h,
              width: 84.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.h),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: isAllSong
                      ? NetworkImage(
                          '${AppURLs.supabaseArtistStorage}${artist.name!.toLowerCase()}.jpg',
                        )
                      : NetworkImage(
                          '${AppURLs.supabaseAlbumStorage}${artist.name} - ${album.name}.jpg',
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            SizedBox(
              width: 84.w,
              child: Text(
                isAllSong ? 'All Song' : album.name!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontSize: album.name!.length <= 12 ? 12.sp : 10.sp,
                    color: Colors.white.withOpacity(0.86),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
