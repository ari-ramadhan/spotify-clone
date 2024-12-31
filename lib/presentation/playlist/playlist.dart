import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/album_song_tile/album_tile_widget.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/album/bloc/artist_album_cubit.dart';
import 'package:spotify_clone/presentation/album/bloc/artist_album_state.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/album/album_list_cubit.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/album/album_list_state.dart';

class PlaylistPage extends StatelessWidget {
  final ArtistEntity artist;
  final AlbumEntity album;
  PlaylistPage({Key? key, required this.artist, required this.album})
      : super(key: key);

  final List<Map<String, Color>> gradientList = [
    {
      'primaryGradient': Colors.orangeAccent.shade400,
      'secondaryGradient': Colors.orangeAccent.shade700
    },
    {
      'primaryGradient': Colors.purpleAccent.shade400,
      'secondaryGradient': Colors.purpleAccent.shade700
    },
    {
      'primaryGradient': Colors.deepOrangeAccent.shade400,
      'secondaryGradient': Colors.deepOrangeAccent.shade700
    },
    {
      'primaryGradient': Colors.redAccent.shade400,
      'secondaryGradient': Colors.redAccent.shade700
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Merandomkan list
    gradientList.shuffle();

    // Mengambil elemen acak
    Map<String, Color> gradientAcak = gradientList.first;

    return Scaffold(
      backgroundColor: AppColors.medDarkBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    gradientAcak['primaryGradient']!,
                    AppColors.medDarkBackground.withOpacity(0.1),
                  ],
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    '${AppURLs.supabaseAlbumStorage}${artist.name} - ${album.name}.jpg',
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          album.name!,
                          style: TextStyle(
                            fontSize: album.name!.length <= 9 ? 34.sp : 24.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                        SizedBox(
                          height: album.name!.length <= 9 ? 0 : 5.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${artist.name!} ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                                height: 1,
                              ),
                            ),
                            Icon(
                              Icons.circle,
                              color: Colors.white70,
                              size: 7.sp,
                            ),
                            Text(
                              ' ${album.createdAt.toString()} ',
                              style: TextStyle(
                                fontSize: 13.3.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
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
                                Icons.playlist_add,
                                color: AppColors.primary,
                                size: 28.w,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite_outline_rounded,
                                color: AppColors.primary,
                                size: 26.w,
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
                        Container(
                          padding: EdgeInsets.all(8.h),
                          decoration: const BoxDecoration(
                              color: AppColors.primary, shape: BoxShape.circle),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.play_arrow_rounded,
                              size: 25.h,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocProvider(
                      create: (context) =>
                          AlbumSongsCubit()..getAlbumSongs(album.albumId!),
                      child: BlocBuilder<AlbumSongsCubit, AlbumSongsState>(
                        builder: (context, state) {
                          if (state is AlbumSongsLoading) {
                            return Container(
                              height: 200.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          }
                          if (state is AlbumSongsFailure) {
                            return Container(
                              height: 200.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text('Failed to fetch songs'),
                            );
                          }
                          if (state is AlbumSongsLoaded) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.separated(
                                    padding: EdgeInsets.only(left: 22.w),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      SongWithFavorite songs =
                                          state.songs[index];
                                      return SongTileWidget(
                                        songEntity: songs,
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
                                          height: 200.h,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'No other songs',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white54),
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
                      padding: EdgeInsets.only(left: 22.w),
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

                    // other album
                    BlocProvider(
                      create: (context) =>
                          AlbumListCubit()..getAlbum(artist.id!),
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
                                children: List.generate(
                                  state.albumEntity.length,
                                  (index) {
                                    return state.albumEntity[index].albumId !=
                                            album.albumId
                                        ? AlbumTileWidget(
                                            album: albumEntity[index],
                                            artist: artist,
                                            isOnAlbumPage: true,
                                            leftPadding: index == 0 ||
                                                    albumEntity[index]
                                                            .albumId !=
                                                        albumEntity[0].albumId
                                                ? 24.w
                                                : 0,
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
