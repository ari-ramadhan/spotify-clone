import 'package:flutter/material.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/playlist/playlist.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_cubit.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_state.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_state.dart';

class PlaylistPage extends StatelessWidget {
  final PlaylistEntity playlistEntity;
  PlaylistPage({
    Key? key,
    required this.playlistEntity,
  }) : super(key: key);

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
                    BlocProvider(
                      create: (context) => PlaylistSongsCubit()
                        ..getPlaylistSongs(playlistEntity.id!),
                      child:
                          BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
                        builder: (context, state) {
                          // if (state is PlaylistSongsLoaded) {
                          return Container(
                            width: double.infinity,
                            height: 180.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  gradientAcak['primaryGradient']!,
                                  AppColors.medDarkBackground.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Container(
                                  height: 180.h,
                                  width: 180.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade700,
                                    // gradient: LinearGradient(
                                    //   begin: Alignment.bottomCenter,
                                    //   end: Alignment.topCenter,
                                    //   colors: [
                                    //     Colors.blueGrey.shade700.withOpacity(0),
                                    //     Colors.blueGrey.shade700.withOpacity(0.8),
                                    //     Colors.blueGrey.shade700.withOpacity(1),
                                    //   ],
                                    // ),
                                  ),
                                  child: (() {
                                    if (state is PlaylistSongsFailure) {
                                      return Center(
                                        child: Text(
                                          playlistEntity.name![0],
                                          style: TextStyle(
                                            fontSize: 60.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }
                                    if (state is PlaylistSongsLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      );
                                    }
                                    if (state is PlaylistSongsLoaded) {
                                      return state.songs.length <= 1
                                          ? Center(
                                              child: Text(
                                                playlistEntity.name![0],
                                                style: TextStyle(
                                                  fontSize: 60.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : GridView.count(
                                              crossAxisCount: 2,
                                              children: state.songs.map(
                                                (e) {
                                                  return Image.network(
                                                      '${AppURLs.supabaseCoverStorage}${e.song.artist} - ${e.song.title}.jpg');
                                                },
                                              ).toList());
                                    }
                                  })()),
                            ),
                          );
                          // }
                          // return Container();
                        },
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
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 18.h,
                          ),
                          Text(
                            playlistEntity.name!,
                            style: TextStyle(
                              fontSize: playlistEntity.name!.length < 17
                                  ? 28.sp
                                  : 22.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'created by ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                  height: 1,
                                ),
                              ),
                              Text(
                                ' ari ramadhan ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                  height: 1,
                                ),
                              ),
                              Icon(
                                Icons.circle,
                                color: Colors.white70,
                                size: 4.sp,
                              ),
                              Text(
                                ' 2019',
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
                            height: 15.h,
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
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: AppColors.primary,
                                  size: 28.w,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.more_horiz_rounded,
                                  color: Colors.white70,
                                  size: 28.w,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              height: 1.h,
              width: double.infinity,
              color: Colors.transparent,
              child: OverflowBox(
                minWidth: 0.0,
                maxWidth: double.infinity,
                minHeight: 0.0,
                alignment: Alignment.centerRight,
                maxHeight: double.infinity,
                child: BlocProvider(
                  create: (context) => PlaylistSongsCubit()
                    ..getPlaylistSongs(playlistEntity.id!),
                  child: BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
                    builder: (context, state) {
                      if (state is PlaylistSongsLoading) {
                        return Container(
                          // height: 56.w,
                          // width: 56.w,
                          // margin: EdgeInsets.only(right: 10.w),
                          // padding: EdgeInsets.all(5.h),
                          // decoration: const BoxDecoration(
                          //   color: Colors.grey,
                          //   shape: BoxShape.circle,
                          // ),
                        );
                      }
                      if (state is PlaylistFailure) {
                        return Container(
                          margin: EdgeInsets.only(right: 10.w),
                          padding: EdgeInsets.all(5.h),
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.play_disabled_rounded,
                              size: 25.h,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                      if (state is PlaylistSongsLoaded) {
                        return Container(
                          margin: EdgeInsets.only(right: 10.w),
                          padding: EdgeInsets.all(5.h),
                          decoration: BoxDecoration(
                            color: state.songs.isEmpty
                                ? Colors.grey
                                : AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.play_arrow_rounded,
                              size: 25.h,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ),
            // Body Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Album Songs
                    BlocProvider(
                      create: (context) => PlaylistSongsCubit()
                        ..getPlaylistSongs(playlistEntity.id!),
                      child:
                          BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
                        builder: (context, state) {
                          if (state is PlaylistSongsLoading) {
                            return Container(
                              height: 100.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          }
                          if (state is PlaylistSongsFailure) {
                            return Container(
                              height: 100.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const Text('Failed to fetch songs'),
                            );
                          }
                          if (state is PlaylistSongsLoaded) {
                            return state.songs.isNotEmpty
                                ? SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ListView.separated(
                                          padding: EdgeInsets.only(
                                              left: 22.w, top: 5.h),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10.w),
                                              child: SongTileWidget(
                                                songList: state.songs,
                                                index: index,
                                                isShowArtist: true,
                                                onSelectionChanged:
                                                    (isSelected) {},
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                              height: 13.h,
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
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    height: 200.h,
                                    child: const Text(
                                      'No songs added to this playlist',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  );
                          }

                          return Container();
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 22.w),
                    //   child: Text(
                    //     'Other Album',
                    //     style: TextStyle(
                    //       fontSize: 16.sp,
                    //       fontWeight: FontWeight.bold,
                    //       letterSpacing: 0.3,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10.h,
                    // ),

                    // Other album
                    // BlocProvider(
                    //   create: (context) =>
                    //       AlbumListCubit()..getAlbum(artist.id!),
                    //   child: BlocBuilder<AlbumListCubit, AlbumListState>(
                    //     builder: (context, state) {
                    //       if (state is AlbumListLoading) {
                    //         return const Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    //       }

                    //       if (state is AlbumListFailure) {
                    //         return const Center(
                    //           child: Text('Error! try again'),
                    //         );
                    //       }

                    //       if (state is AlbumListLoaded) {
                    //         var albumEntity = state.albumEntity;

                    //         return SingleChildScrollView(
                    //           scrollDirection: Axis.horizontal,
                    //           child: Row(
                    //             children: List.generate(
                    //               state.albumEntity.length,
                    //               (index) {
                    //                 return state.albumEntity[index].albumId !=
                    //                         album.albumId
                    //                     ? AlbumTileWidget(
                    //                         album: albumEntity[index],
                    //                         artist: artist,
                    //                         isOnAlbumPage: true,
                    //                         leftPadding: index == 0 ||
                    //                                 albumEntity[index]
                    //                                         .albumId !=
                    //                                     albumEntity[0].albumId
                    //                             ? 24.w
                    //                             : 0,
                    //                       )
                    //                     : Container();
                    //               },
                    //             ),
                    //           ),
                    //         );
                    //       }

                    //       return Container();
                    //     },
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20.h,
                    // )
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
