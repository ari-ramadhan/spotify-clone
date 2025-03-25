import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/album_song_tile/album_tile_widget.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget.dart';
import 'package:spotify_clone/core/configs/constants/app_methods.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/album/bloc/all_songs/all_songs_cubit.dart';
import 'package:spotify_clone/presentation/album/bloc/all_songs/all_songs_state.dart';
import 'package:spotify_clone/presentation/album/bloc/single_songs/single_songs_cubit.dart';
import 'package:spotify_clone/presentation/album/bloc/single_songs/single_songs_state.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/album/album_list_cubit.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/album/album_list_state.dart';

class NonAlbumPage extends StatefulWidget {
  final ArtistEntity artist;
  final String nonAlbumPageTitle;
  const NonAlbumPage({
    super.key,
    required this.artist,
    required this.nonAlbumPageTitle,
  });

  @override
  State<NonAlbumPage> createState() => _NonAlbumPageState();
}

class _NonAlbumPageState extends State<NonAlbumPage> {
  List<SongWithFavorite> songs = [];

  @override
  Widget build(BuildContext context) {
    // Merandomkan list
    AppColors.gradientList.shuffle();

    return Scaffold(
      // backgroundColor: AppColors.medDarkBackground,
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
                      padding: EdgeInsets.only(top: 130.h),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          alignment: const Alignment(0, -0.5),
                          image: CachedNetworkImageProvider(
                              '${AppURLs.supabaseArtistStorage}${widget.artist.name!.toLowerCase()}.jpg'),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.white),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.medDarkBackground.withOpacity(0),
                              AppColors.medDarkBackground.withOpacity(0.5),
                              AppColors.medDarkBackground.withOpacity(0.7),
                              AppColors.medDarkBackground,
                              // AppColors.medDarkBackground,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min, // Adjust height to fit children
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 17.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                  Text(
                                    'Artist\'s entire songs',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.4,
                                        color: Colors.white70),
                                  ),
                                  Text(
                                    widget.nonAlbumPageTitle,
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Text(
                                    songs.isEmpty
                                        ? '--- times played'
                                        : '${NumberFormat.decimalPattern().format(songs.fold<int>(0, (sum, song) => sum + song.song.playCount))} times played, 30m',
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
                              padding: EdgeInsets.symmetric(horizontal: 8.w)
                                  .copyWith(right: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          blurryDialogForPlaylist(
                                              context: context,
                                              artist: widget.artist,
                                              songList: songs,
                                              backgroundImage:
                                                  '${AppURLs.supabaseArtistStorage}${widget.artist.name!.toLowerCase()}.jpg',
                                              contentToCopy: Row(
                                                children: [
                                                  Container(
                                                    height: 50.w,
                                                    width: 50.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          '${AppURLs.supabaseThisIsMyStorage}${widget.artist.name!.toLowerCase()}.jpg',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 9.w,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        widget.nonAlbumPageTitle
                                                                .contains(
                                                                    'This is')
                                                            ? 'This is'
                                                            : '${widget.artist.name}\'s',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white70,
                                                            fontSize: 11.2.sp),
                                                      ),
                                                      Text(
                                                        widget.nonAlbumPageTitle
                                                                .contains(
                                                                    'This is')
                                                            ? '${widget.artist.name}'
                                                            : 'Singles',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16.sp,
                                                            letterSpacing: 0.4),
                                                      ),
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    15.sp),
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5.w,
                                                                  vertical:
                                                                      1.h),
                                                          color: Colors.white,
                                                          child: Text(
                                                            '${songs.length} Songs',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .darkBackground,
                                                                fontSize: 8.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ));
                                        },
                                        iconSize: 20.sp,
                                        splashRadius: 20.sp,
                                        icon: Icon(
                                          Icons.playlist_add_circle_rounded,
                                          color: AppColors.primary,
                                          size: 28.sp,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        iconSize: 20.sp,
                                        splashRadius: 20.sp,
                                        icon: Icon(
                                          Icons.favorite_outline_rounded,
                                          color: AppColors.primary,
                                          size: 26.w,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        iconSize: 20.sp,
                                        splashRadius: 20.sp,
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
                                      margin: EdgeInsets.only(right: 5.w),
                                      padding: EdgeInsets.all(5.h),
                                      decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.play_arrow_rounded,
                                          size: 25.h,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Album Songs
                    widget.nonAlbumPageTitle.contains('This is')
                        ? BlocProvider(
                            create: (context) =>
                                AllSongsCubit()..getAllSongs(widget.artist.id!),
                            child: BlocBuilder<AllSongsCubit, AllSongsState>(
                              builder: (context, state) {
                                if (state is AllSongsLoading) {
                                  return Container(
                                    height: 100.h,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  );
                                }
                                if (state is AllSongsFailure) {
                                  return Container(
                                    height: 100.h,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: const Text('Failed to fetch songs'),
                                  );
                                }
                                if (state is AllSongsLoaded) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {
                                      songs = state.songs;
                                    });
                                  });

                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          // padding: EdgeInsets.only(left: 22.w, top: 5.h),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return SongTileWidget(
                                              songList: state.songs,
                                              onSelectionChanged:
                                                  (isSelected) {},
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
                                                      fontStyle:
                                                          FontStyle.italic,
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
                          )
                        : BlocProvider(
                            create: (context) => SingleSongsCubit()
                              ..getSingleSongs(widget.artist.id!),
                            child:
                                BlocBuilder<SingleSongsCubit, SingleSongsState>(
                              builder: (context, state) {
                                if (state is SingleSongsLoading) {
                                  return Container(
                                    height: 100.h,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  );
                                }
                                if (state is SingleSongsFailure) {
                                  return Container(
                                    height: 100.h,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: const Text('Failed to fetch songs'),
                                  );
                                }
                                if (state is SingleSongsLoaded) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {
                                      songs = state.songs;
                                    });
                                  });

                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          // padding: EdgeInsets.only(left: 22.w, top: 5.h),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return SongTileWidget(
                                              songList: state.songs,
                                              onSelectionChanged:
                                                  (isSelected) {},
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
                                                      fontStyle:
                                                          FontStyle.italic,
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
                    SizedBox(
                      height: 12.h,
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
                      create: (context) =>
                          AlbumListCubit()..getAlbum(widget.artist.id!),
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
                                    return AlbumTileWidget(
                                      album: albumEntity[index],
                                      artist: widget.artist,
                                      isOnAlbumPage: true,
                                      leftPadding: index == 0 ||
                                              albumEntity[index].albumId !=
                                                  albumEntity[0].albumId
                                          ? 17.w
                                          : 0,
                                    );
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
