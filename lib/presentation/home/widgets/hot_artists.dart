import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/artist_page/pages/artist_page.dart';
import 'package:spotify_clone/presentation/home/bloc/hot_artists/hot_artists_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/hot_artists/hot_artists_state.dart';

class HotArtists extends StatelessWidget {
  const HotArtists({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotArtistsCubit, HotArtistsState>(
      builder: (context, state) {
        if (state is HotArtistsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HotArtistsLoaded) {
          return _songs(context, state.artists);
        }

        return const Center(
          child: Text('No songs available.'),
        );
      },
    );
  }

  Widget _songs(BuildContext context, List<ArtistEntity> artists) {
    if (artists.isEmpty) {
      return const Center(child: Text('No artists available.'));
    }

    return ListView.separated(
      padding: EdgeInsets.only(left: 24.sp),
      scrollDirection: Axis.horizontal,
      itemCount: artists.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => SizedBox(width: 14.w),
      itemBuilder: (context, index) {
        var artist = artists[index];

        return HotArtistsWidget(artist: artist, index: index + 1,);
      },
    );
  }

  Widget _artistItem(
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

class HotArtistsWidget extends StatelessWidget {
  const HotArtistsWidget({
    super.key,
    required this.artist,
    required this.index,
  });

  final ArtistEntity artist;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArtistPage(
              artistId: artist.id!,
            ),
          ),
        );
      },
      child: Container(
        // margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 15.h,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.3,
              ),
              blurRadius: 10,
              offset: const Offset(3, 3),
            ),
          ],
          // color: const Color.fromARGB(115, 0, 0, 0),
          image: DecorationImage(
            fit: BoxFit.cover,
            scale: 0.8,
            opacity: 0.1,
            image: NetworkImage(
                '${AppURLs.supabaseArtistStorage}${artist.name!.toLowerCase()}.jpg'),
          ),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                CircleAvatar(
                  radius: 47.sp,
                  backgroundImage: NetworkImage(
                    '${AppURLs.supabaseArtistStorage}${artist.name!.toLowerCase()}.jpg',
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(9),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary
                  ),
                  child: Text(index.toString(), style: TextStyle(fontSize: index == 1 ? 14.sp : 11.sp, color: Colors.white, fontWeight: FontWeight.w600),),
                )
              ],
            ),
            SizedBox(
              height: 18.h,
            ),
            Text(
              artist.name!,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              'Artist',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
