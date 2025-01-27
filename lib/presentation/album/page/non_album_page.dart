import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/album_song_tile/album_tile_widget.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget.dart';
import 'package:spotify_clone/core/configs/constants/app_methods.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/data/repository/auth/auth_service.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/auth/user.dart';
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
  NonAlbumPage({
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
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            alignment: const Alignment(0, -0.5),
                            opacity: 0.7,
                            image: CachedNetworkImageProvider('${AppURLs.supabaseArtistStorage}${widget.artist.name!.toLowerCase()}.jpg'),
                          ),
                        )),
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
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 14.h,
                          ),
                          Text(
                            'Artist\'s entire songs',
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, letterSpacing: 0.4, color: Colors.white70),
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
                      padding: EdgeInsets.symmetric(horizontal: 8.w).copyWith(right: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    backgroundImage: '${AppURLs.supabaseArtistStorage}${widget.artist.name!.toLowerCase()}.jpg',

                                    // content: Column(
                                    //   children: [],
                                    // ),
                                    // horizontalPadding: 10.w,
                                  );
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
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Album Songs
                    widget.nonAlbumPageTitle.contains('This is')
                        ? BlocProvider(
                            create: (context) => AllSongsCubit()..getAllSongs(widget.artist.id!),
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
                                  songs = state.songs;

                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          // padding: EdgeInsets.only(left: 22.w, top: 5.h),
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
                                                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white54),
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
                            create: (context) => SingleSongsCubit()..getSingleSongs(widget.artist.id!),
                            child: BlocBuilder<SingleSongsCubit, SingleSongsState>(
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
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          // padding: EdgeInsets.only(left: 22.w, top: 5.h),
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
                                                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white54),
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
                      create: (context) => AlbumListCubit()..getAlbum(widget.artist.id!),
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
                                      leftPadding: index == 0 || albumEntity[index].albumId != albumEntity[0].albumId ? 17.w : 0,
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
