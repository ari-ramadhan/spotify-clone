
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/album_song_tile/album_tile_widget.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/album/bloc/artist_album/artist_album_cubit.dart';
import 'package:spotify_clone/presentation/album/bloc/artist_album/artist_album_state.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/album/album_list_cubit.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/album/album_list_state.dart';

class ArtistAlbum extends StatelessWidget {
  final ArtistEntity artist;
  final AlbumEntity album;
  final bool isAllSong;
  ArtistAlbum({super.key, required this.artist, required this.album, this.isAllSong = false});

  double paddingAddition = 4;

  @override
  Widget build(BuildContext context) {
    // Merandomkan list
    AppColors.gradientList.shuffle();

    // Mengambil elemen acak
    Map<String, Color> gradientAcak = AppColors.gradientList.first;

    return Scaffold(
      backgroundColor: AppColors.medDarkBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                // Header Section (Album Picture)
                Stack(
                  children: [
                    // Album Picture
                    Container(
                      width: double.infinity,
                      height: 200.h,
                      decoration: isAllSong
                          ? BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                alignment: const Alignment(0, -0.5),
                                opacity: 0.7,
                                image: CachedNetworkImageProvider('${AppURLs.supabaseArtistStorage}${artist.name!.toLowerCase()}.jpg'),
                              ),
                            )
                          : BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  gradientAcak['primaryGradient']!,
                                  AppColors.medDarkBackground.withOpacity(0.1),
                                ],
                              ),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  '${AppURLs.supabaseAlbumStorage}${artist.name} - ${album.name}.jpg',
                                ),
                              ),
                            ),
                    ),
                    // Back Button
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.w),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          size: 24.sp,
                          Icons.arrow_back_ios_rounded,
                        ),
                      ),
                    ),
                  ],
                ),

                // Body Section (Album Details)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.w + paddingAddition.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          isAllSong
                              ? Text(
                                  artist.name!,
                                  style: TextStyle(
                                    fontSize: artist.name!.length <= 9 ? 20.sp : 16.sp,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.4,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          isAllSong
                              ? Text(
                                  'All Songs',
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.4,
                                  ),
                                )
                              : Text(
                                  album.name!,
                                  style: TextStyle(
                                    fontSize: album.name!.length < 17 ? 23.sp : 18.sp,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                          SizedBox(
                            height: album.name!.length <= 9 ? 5.h : 5.h,
                          ),
                          isAllSong
                              ? const SizedBox.shrink()
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 10.sp,
                                      backgroundImage: NetworkImage(
                                        '${AppURLs.supabaseArtistStorage}${artist.name!.toLowerCase()}.jpg',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      '${artist.name!} ',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        // color: Colors.white70,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            children: [
                              Text(
                                'Album ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                  height: 1,
                                ),
                              ),
                              Icon(
                                Icons.circle,
                                color: Colors.white70,
                                size: 4.sp,
                              ),
                              Text(
                                ' ${album.createdAt.toString()} ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            '8.923.892 times played, 30m',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white.withOpacity(
                                0.85,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w + paddingAddition.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {},
                                splashRadius: 18.sp,
                                icon: Icon(
                                  Icons.playlist_add,
                                  color: AppColors.primary,
                                  size: 28.w,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                splashRadius: 18.sp,
                                icon: Icon(
                                  Icons.favorite_outline_rounded,
                                  color: AppColors.primary,
                                  size: 26.w,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                splashRadius: 18.sp,
                                icon: Icon(
                                  Icons.more_horiz_rounded,
                                  color: Colors.white70,
                                  size: 28.w,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              // margin: EdgeInsets.only(right: 10.w),
                              padding: EdgeInsets.all(5.h),
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.play_arrow_rounded,
                                  size: 25.h,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            // Body Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Album Songs
                    BlocProvider(
                      create: (context) => AlbumSongsCubit()..getAlbumSongs(album.albumId!),
                      child: BlocBuilder<AlbumSongsCubit, AlbumSongsState>(
                        builder: (context, state) {
                          if (state is AlbumSongsLoading) {
                            return Container(
                              height: 100.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          }
                          if (state is AlbumSongsFailure) {
                            return Container(
                              height: 100.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const Text('Failed to fetch songs'),
                            );
                          }
                          if (state is AlbumSongsLoaded) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    // padding: EdgeInsets.only(
                                    //     left: 13.w, top: 5.h,),
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return SongTileWidget(
                                        songList: state.songs,
                                        onSelectionChanged: (isSelected) {},
                                        index: index,
                                      );
                                    },
                                    itemCount: state.songs.length,
                                  ),
                                  state.songs.length < 7
                                      ? Container(
                                          height: 100.h,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'No other songs',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white54,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            );
                          }

                          return Container();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 17.w),
                      child: Text(
                        'Other Album',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),

                    // Other album
                    BlocProvider(
                      create: (context) => AlbumListCubit()..getAlbum(artist.id!),
                      child: BlocBuilder<AlbumListCubit, AlbumListState>(
                        builder: (context, state) {
                          if (state is AlbumListLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is AlbumListFailure) {
                            return const Center(
                              child: Text('Error! try again'),
                            );
                          }

                          if (state is AlbumListLoaded) {
                            var albumEntity = state.albumEntity;

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  state.albumEntity.length,
                                  (index) {
                                    return state.albumEntity[index].albumId != album.albumId
                                        ? AlbumTileWidget(
                                            album: albumEntity[index],
                                            artist: artist,
                                            isOnAlbumPage: true,
                                            rightPadding: 7.w,
                                            leftPadding: index == 0 || albumEntity[index].albumId != albumEntity[0].albumId ? 17.w : 0,
                                          )
                                        : Container();
                                  },
                                ),
                              ),
                            );
                          }

                          return Container();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
