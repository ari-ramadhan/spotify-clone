// import 'package:dartz/dartz.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/album_song_tile/album_tile_widget.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/album/album_list_cubit.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/album/album_list_state.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/artist_page_cubit.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/artist_page_state.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/popular_song/artist_songs_cubit.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/popular_song/artist_songs_state.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/similar_artist/similar_artist_cubit.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/similar_artist/similar_artist_state.dart';

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
      backgroundColor: AppColors.medDarkBackground,
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
                      padding: EdgeInsets.only(left: 10.w, top: 20.h),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
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

  Container artistAboutCard(ArtistEntity artist) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.medDarkBackground,
            Color.fromARGB(235, 54, 54, 54),
          ],
          stops: [
            0,
            1,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.h),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10.0,
              offset: const Offset(0, 4) // changes position of shadow
              ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'about',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
              Text(
                'musician since ${artist.careerStart}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            artist.description!,
            style: TextStyle(fontSize: 15.sp),
            textAlign: TextAlign.justify,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'Social media :',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            textAlign: TextAlign.justify,
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              SizedBox(
                  height: 40.h,
                  width: 40.h,
                  child: SvgPicture.asset(AppVectors.instagram)),
              SizedBox(
                width: 5.w,
              ),
              SizedBox(
                  height: 40.h,
                  width: 40.h,
                  child: SvgPicture.asset(AppVectors.twitter)),
              SizedBox(
                width: 5.w,
              ),
              SizedBox(
                  height: 40.h,
                  width: 40.h,
                  child: SvgPicture.asset(AppVectors.facebook)),
            ],
          ),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ArtistSongsFailure) {
            return const Center(
              child: Text('Error! try again'),
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
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      SongWithFavorite songs = state.songEntity[index];
                      return SongTileWidget(
                        songEntity: songs,
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
                        songEntity: songs,
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

  Padding artistInfo(ArtistEntity artist) {
    return Padding(
      padding: EdgeInsets.only(left: 50.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            artist.name!,
            style: TextStyle(
                fontSize: artist.name!.length > 14 ? 28.sp : 33.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4),
          ),
          SizedBox(
            height: artist.name!.length > 14 ? 5.h : 0,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h)
                    .copyWith(left: 0),
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 4.h),
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    border: Border.all(
                      color: AppColors.primary,
                    ),
                    borderRadius: BorderRadius.circular(15.w)),
                child: Text(
                  'Follow',
                  style: TextStyle(
                      letterSpacing: 0.7,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
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

  Stack artistPictBackground(ArtistEntity artist, int artistId) {
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
                  image: NetworkImage(
                    '${AppURLs.supabaseArtistStorage}${artist.name!.toLowerCase()}.jpg',
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
                  albumList(artist),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _tabs(),
                        SizedBox(
                          height: 7.h,
                        ),
                        artistPickedList(artist)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  artistAboutCard(artist),
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
                    ArtistEntity artistList = state.artistEntity[index];

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
                                        ));
                                  },
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Container(
                                            height: 125.h,
                                            width: 115.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10.w,
                                              ),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  '${AppURLs.supabaseArtistStorage}${artistList.name!.toLowerCase()}.jpg',
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 50.h,
                                            width: 115.w,
                                            padding: EdgeInsets.only(
                                                bottom: 8.h, left: 10.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(10.w),
                                                bottomRight:
                                                    Radius.circular(10.w),
                                              ),
                                              color: Colors.white,
                                              gradient: LinearGradient(
                                                end: Alignment.topCenter,
                                                begin: Alignment.bottomCenter,
                                                colors: [
                                                  AppColors.primary
                                                      .withOpacity(1),
                                                  AppColors.primary
                                                      .withOpacity(0.7),
                                                  AppColors.primary
                                                      .withOpacity(0),
                                                ],
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text(
                                                  artistList.name!,
                                                  // textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12.sp,
                                                      letterSpacing: 0.2),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 14.w,
                                )
                              ],
                            )
                          : SizedBox.shrink(),
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
