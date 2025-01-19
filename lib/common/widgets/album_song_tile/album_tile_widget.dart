import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/presentation/album/page/non_album_page.dart';
import 'package:spotify_clone/presentation/album/page/artist_album.dart';

class AlbumTileWidget extends StatelessWidget {
  final AlbumEntity album;
  final ArtistEntity artist;
  final double leftPadding;
  final double rightPadding;
  final bool isNonAlbum;
  final String nonAlbumTitle;
  final bool isOnAlbumPage;
  const AlbumTileWidget({
    super.key,
    required this.album,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.isNonAlbum = false,
    this.isOnAlbumPage = false,
    this.nonAlbumTitle = '',
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isNonAlbum
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NonAlbumPage(
                    artist: artist,
                    nonAlbumPageTitle: nonAlbumTitle,
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
        padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 80.h,
                  width: 84.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.h),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: isNonAlbum
                          ? nonAlbumTitle == 'Single' ? CachedNetworkImageProvider(
                              '${AppURLs.supabaseArtistStorage}${artist.name!.toLowerCase()}.jpg',
                            ) : CachedNetworkImageProvider(
                              '${AppURLs.supabaseThisIsMyStorage}${artist.name!.toLowerCase()}.jpg',
                            )
                          : CachedNetworkImageProvider(
                              '${AppURLs.supabaseAlbumStorage}${artist.name} - ${album.name}.jpg',
                            ),
                    ),
                  ),
                ),
                isNonAlbum && nonAlbumTitle == 'Single'
                    ? Container(
                        alignment: Alignment.center,
                        height: 80.h,
                        width: 84.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.h),
                          color: AppColors.medDarkBackground.withOpacity(0.50),
                        ),
                        child: const Text(
                          'Single',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 0.8),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            SizedBox(
              height: 7.h,
            ),
            SizedBox(
              width: 84.w,
              child: Text(
                isNonAlbum ? nonAlbumTitle : album.name!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style:
                    TextStyle(fontSize: album.name!.length <= 12 ? 12.sp : 10.sp, color: Colors.white.withOpacity(0.86), fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
