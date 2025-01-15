// import 'package:dartz/dartz.dart';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/album_song_tile/album_tile_widget.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/domain/usecases/artist/follow_unfollow_artist.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/album/album_list_cubit.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/album/album_list_state.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/artist_page_cubit.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/artist_page_state.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/popular_song/artist_songs_cubit.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/popular_song/artist_songs_state.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/similar_artist/similar_artist_cubit.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/similar_artist/similar_artist_state.dart';
import 'package:spotify_clone/presentation/artist_page/widgets/follow_artist_button.dart';

class ArtistPage extends StatefulWidget {
  final int artistId;
  const ArtistPage({Key? key, required this.artistId}) : super(key: key);

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.medDarkBackground,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ArtistPageCubit()..getArtist(widget.artistId),
          child: BlocBuilder<ArtistPageCubit, ArtistPageState>(
            builder: (context, state) {
              if (state is ArtistPageLoading) {
                return Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  width: double.infinity,
                  child: const CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (state is ArtistPageFailure) {
                return const Center(
                  child: Text('Artist profile fail to load'),
                );
              }

              if (state is ArtistPageLoaded) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: artistPictBackground(
                          state.artistEntity, widget.artistId),
                    ),
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: 100.h,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.medDarkBackground.withOpacity(1),
                          AppColors.medDarkBackground.withOpacity(0),
                        ],
                      )),
                      padding: EdgeInsets.only(left: 10.w, top: 10.h),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 35.h,
                          width: 35.w,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 15.h,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget artistAboutCard(ArtistEntity artist) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            // width: 450,
            // height: 250,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  25,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'about',
                      style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary.withBlue(80)),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.w, top: 3.h, bottom: 3.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white10.withOpacity(0.05),
                        Colors.white10.withOpacity(0.0),
                      ],
                    ),
                    border: Border(
                      left: BorderSide(
                          color: AppColors.primary.withOpacity(0.8),
                          width: 3.w),
                    ),
                  ),
                  child: Text(
                    artist.description!,
                    style:
                        TextStyle(fontSize: 14.sp, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),

                Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 8.h,
                  spacing: 10.w,
                  children: [
                    socialMediaChips(
                        AppVectors.instagram, 'Instagram', Colors.redAccent),
                    socialMediaChips(
                        AppVectors.twitter, 'Twitter', Colors.lightBlue),
                    socialMediaChips(
                        AppVectors.facebook, 'Facebook', Colors.blue.shade600),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Container socialMediaChips(String svgAsset, String socialMedia, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w)
          .copyWith(right: 12.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.sp), color: color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgAsset,
            height: 16.h,
            width: 16.h,
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(
            socialMedia,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: Colors.transparent,
      labelPadding: EdgeInsets.zero,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      unselectedLabelColor: Colors.grey,
      padding: EdgeInsets.zero,
      onTap: (value) {
        setState(() {});
      },
      tabs: [
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Popular',
                style: TextStyle(
                  letterSpacing: 0.3,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _tabController.index == 0
                  ? Icon(
                      Icons.arrow_drop_down_rounded,
                      color: AppColors.primary,
                      size: 30.w,
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
        Row(
          children: [
            Text(
              'Artist Picked',
              style: TextStyle(
                letterSpacing: 0.3,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            _tabController.index == 1
                ? Icon(
                    Icons.arrow_drop_down_rounded,
                    color: AppColors.primary,
                    size: 30.w,
                  )
                : const SizedBox.shrink()
          ],
        ),
      ],
    );
  }

  Widget artistPickedList(ArtistEntity artist) {
    return BlocProvider(
      create: (context) => ArtistSongsCubit()..getPopularSong(artist.id!),
      child: BlocBuilder<ArtistSongsCubit, ArtistSongsState>(
        builder: (context, state) {
          if (state is ArtistSongsLoading) {
            return SizedBox(
              height: 70.h,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is ArtistSongsFailure) {
            return SizedBox(
              height: 70.h,
              child: const Center(
                child: Text('Error! try again'),
              ),
            );
          }

          if (state is ArtistSongsLoaded) {
            return SizedBox(
              height: (state.songEntity.length * 40.h) +
                  ((state.songEntity.length - 1) * 13.h),
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView.separated(
                    itemCount: state.songEntity.length,
                    padding: EdgeInsets.only(left: 30.w),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      SongWithFavorite songs = state.songEntity[index];
                      return SongTileWidget(
                        songList: state.songEntity,
                        onSelectionChanged: (isSelected) {},
                        index: index,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 13.h,
                      );
                    },
                  ),
                  ListView.separated(
                    itemCount: state.songEntity.length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      SongWithFavorite songs = state.songEntity[index];
                      return SongTileWidget(
                        songList: state.songEntity,
                        index: index,
                        onSelectionChanged: (isSelected) {},
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 13.h,
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );

    ;
  }

  Padding artistInfo(ArtistWithFollowing artist) {
    bool followStatus = artist.isFollowed;

    return Padding(
      padding: EdgeInsets.only(left: 50.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            artist.artist.name!,
            style: TextStyle(
                fontSize: artist.artist.name!.length > 14 ? 28.sp : 33.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4),
          ),
          SizedBox(
            height: artist.artist.name!.length > 14 ? 5.h : 0,
          ),
          Row(
            children: [
              FollowArtistButton(artistEntity: artist),
              Text(
                '8.929.322 monthly listeners',
                style: TextStyle(fontSize: 13.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Stack artistPictBackground(ArtistWithFollowing artist, int artistId) {
    return Stack(
      // alignment: Alignment.bottomCenter,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: ScreenUtil().screenHeight / 1.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    '${AppURLs.supabaseArtistStorage}${artist.artist.name!.toLowerCase()}.jpg',
                  ),
                ),
              ),
            ),
            Container(
              height: ScreenUtil().screenHeight / 2.3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.medDarkBackground.withOpacity(1),
                    AppColors.medDarkBackground.withOpacity(0.9),
                    AppColors.medDarkBackground.withOpacity(0.3),
                    AppColors.medDarkBackground.withOpacity(0.0)
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 300.h),
          padding: EdgeInsets.only(top: 50.h),
          decoration: BoxDecoration(
            color: AppColors.medDarkBackground,
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.topCenter,
              colors: [
                AppColors.medDarkBackground.withOpacity(0.8),
                AppColors.medDarkBackground.withOpacity(0),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              artistInfo(artist),
              SizedBox(
                height: 16.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: Row(
                      children: [
                        Text(
                          'Album',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          color: AppColors.primary,
                          size: 30.w,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  albumList(artist.artist),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 30.w), child: _tabs()),
                      SizedBox(
                        height: 7.h,
                      ),
                      artistPickedList(artist.artist)
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  artistAboutCard(artist.artist),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30.w, right: 22.w),
                        child: Text(
                          'Similar Artist',
                          style: TextStyle(
                            letterSpacing: 0.3,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      similarArtist(artistId)
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  BlocProvider<SimilarArtistCubit> similarArtist(int artistId) {
    return BlocProvider(
      create: (context) => SimilarArtistCubit()..getArtists(),
      child: BlocBuilder<SimilarArtistCubit, SimilarArtistState>(
        builder: (context, state) {
          if (state is SimilarArtistLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SimilarArtistFailure) {
            return const Center(
              child: Text('Error please try again'),
            );
          }

          if (state is SimilarArtistLoaded) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  state.artistEntity.length,
                  (index) {
                    ArtistEntity artistList = state.artistEntity[index].artist;

                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 30.w : 0,
                      ),
                      child: artistList.id != artistId
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ArtistPage(
                                            artistId: artistList.id!),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              // spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: const Offset(3,
                                                  3) // changes position of shadow
                                              ),
                                        ],
                                        color: const Color.fromARGB(
                                            115, 54, 54, 54),
                                        borderRadius:
                                            BorderRadius.circular(10.sp)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: CircleAvatar(
                                            radius: 50.sp,
                                            backgroundImage: NetworkImage(
                                              '${AppURLs.supabaseArtistStorage}${artistList.name!.toLowerCase()}.jpg',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 18.h,
                                        ),
                                        Text(
                                          artistList.name!,
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
                                  // child: Column(
                                  //   children: [
                                  //     Stack(
                                  //       alignment: Alignment.bottomCenter,
                                  //       children: [
                                  //         Container(
                                  //           height: 125.h,
                                  //           width: 115.w,
                                  //           decoration: BoxDecoration(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(
                                  //               10.w,
                                  //             ),
                                  //             image: DecorationImage(
                                  //               fit: BoxFit.cover,
                                  //               image: NetworkImage(
                                  //                 '${AppURLs.supabaseArtistStorage}${artistList.name!.toLowerCase()}.jpg',
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Container(
                                  //           height: 50.h,
                                  //           width: 115.w,
                                  //           padding: EdgeInsets.only(
                                  //               bottom: 8.h, left: 10.w),
                                  //           decoration: BoxDecoration(
                                  //             borderRadius: BorderRadius.only(
                                  //               bottomLeft:
                                  //                   Radius.circular(10.w),
                                  //               bottomRight:
                                  //                   Radius.circular(10.w),
                                  //             ),
                                  //             color: Colors.white,
                                  //             gradient: LinearGradient(
                                  //               end: Alignment.topCenter,
                                  //               begin: Alignment.bottomCenter,
                                  //               colors: [
                                  //                 AppColors.primary
                                  //                     .withOpacity(1),
                                  //                 AppColors.primary
                                  //                     .withOpacity(0.7),
                                  //                 AppColors.primary
                                  //                     .withOpacity(0),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //           child: Column(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment.end,
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //             children: [
                                  //               SizedBox(
                                  //                 height: 5.h,
                                  //               ),
                                  //               Text(
                                  //                 artistList.name!,
                                  //                 // textAlign: TextAlign.center,
                                  //                 style: TextStyle(
                                  //                     color: Colors.white,
                                  //                     fontWeight:
                                  //                         FontWeight.w600,
                                  //                     fontSize: 12.sp,
                                  //                     letterSpacing: 0.2),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                ),
                                SizedBox(
                                  width: 14.w,
                                )
                              ],
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget albumList(ArtistEntity artist) {
    return BlocProvider(
      create: (context) => AlbumListCubit()..getAlbum(artist.id!),
      child: BlocBuilder<AlbumListCubit, AlbumListState>(
        builder: (context, state) {
          if (state is AlbumListLoading) {
            return SizedBox(
              height: 70.h,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is AlbumListFailure) {
            return SizedBox(
              height: 70.h,
              child: const Center(
                child: Text('Error! try again'),
              ),
            );
          }

          if (state is AlbumListLoaded) {
            var albumList = state.albumEntity;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  albumList.length + 1,
                  (index) {
                    return index == 0
                        ? AlbumTileWidget(
                            album: albumList[index],
                            artist: artist,
                            leftPadding: 30.w,
                            rightPadding: 22.w,
                          )
                        : index == (state.albumEntity.length)
                            ? AlbumTileWidget(
                                album: albumList[0],
                                rightPadding: 22.w,
                                isAllSong: true,
                                artist: artist,
                              )
                            : AlbumTileWidget(
                                rightPadding: 22.w,
                                album: albumList[index],
                                artist: artist,
                              );
                  },
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
