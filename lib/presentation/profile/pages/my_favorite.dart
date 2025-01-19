import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/presentation/artist_page/pages/artist_page.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_cubit.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_state.dart';
import 'package:spotify_clone/presentation/playlist/bloc/recommended_artist_state.dart';
import 'package:spotify_clone/presentation/playlist/bloc/recommended_artists_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_state.dart';

class MyFavorite extends StatefulWidget {
  final int length;
  MyFavorite({
    required this.length,
    Key? key,
  }) : super(key: key);

  @override
  State<MyFavorite> createState() => _MyFavoriteState();
}

class _MyFavoriteState extends State<MyFavorite> {
  // String playlistName = '';
  // String playlistDesc = '';

  double paddingAddition = 4;

  // final TextEditingController _playlistNameController = TextEditingController();
  // final TextEditingController _playlistDescController = TextEditingController();

  // final _formKey = GlobalKey<FormState>();

  // List<SongWithFavorite> exceptionalSongs = [];
  // List<SongWithFavorite> selectedSongs = [];

  @override
  void initState() {
    super.initState();
    // selectedSongs.clear();
    // playlistName = widget.playlistEntity.name!;
    // playlistDesc = widget.playlistEntity.description!;
  }

  final TextEditingController _controller = TextEditingController();

  bool isShowSelectedSongError = false;
  @override
  Widget build(BuildContext context) {
    // Merandomkan list
    AppColors.gradientList.shuffle();

    // Mengambil elemen acak
    Map<String, Color> gradientAcak = AppColors.gradientList.first;

    return Scaffold(
      backgroundColor: AppColors.medDarkBackground,
      body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => FavoriteSongCubit()..getFavoriteSongs(),
            )
          ],
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    // Header Section (Album Picture)
                    Stack(
                      children: [
                        BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
                          builder: (context, state) {
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
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xfffb3a6a), Color(0xff1c61f5)],
                                      stops: [0.3, 1],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                    ),
                                  ),
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: Icon(
                                      Icons.favorite_rounded,
                                      color: Colors.white,
                                      size: 70.sp,
                                      // size: 26.sp,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 7.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  size: 24.sp,
                                  Icons.arrow_back_ios_rounded,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  return showMenu(
                                    context: context,
                                    position: RelativeRect.fromLTRB(1, 60.h, 0, 0),
                                    menuPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        8.h,
                                      ),
                                    ),
                                    items: [
                                      PopupMenuItem(
                                          onTap: () async {
                                            ;
                                          },
                                          child: const Text('Edit Playlist Info')),
                                      PopupMenuItem(
                                          child: const Text('Delete playlist'),
                                          onTap: () {
                                            ;
                                          })
                                    ],
                                  );
                                },
                                icon: Icon(
                                  size: 24.sp,
                                  Icons.more_vert_sharp,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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
                              Text(
                                'My Favorites',
                                style: TextStyle(
                                  fontSize: 21.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text('contains ${widget.length} songs')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w + paddingAddition.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    iconSize: 20.sp,
                                    onPressed: () async {},
                                    splashRadius: 20.sp,
                                    icon: Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: AppColors.primary,
                                      size: 28.w,
                                    ),
                                  ),
                                  IconButton(
                                    splashRadius: 22.sp,
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
                                // margin: EdgeInsets.only(right: 10.w),
                                padding: EdgeInsets.all(5.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
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
                    padding: EdgeInsets.only(top: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Album Songs
                        BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
                          builder: (context, state) {
                            if (state is FavoriteSongLoading) {
                              return Container(
                                height: 100.h,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              );
                            }
                            if (state is FavoriteSongFailure) {
                              return Container(
                                height: 100.h,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: const Text('Failed to fetch songs'),
                              );
                            }
                            if (state is FavoriteSongLoaded) {
                              // exceptionalSongs = state.songs;

                              // getting artist name by the playlist song's artist name and removes the dupe
                              List<String> artistsName = state.songs.map((e) => e.song.artist).toSet().toList();

                              return state.songs.isNotEmpty
                                  ? SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return SongTileWidget(
                                                index: index,
                                                songList: state.songs,
                                                isShowArtist: true,
                                                onSelectionChanged: (bool) {},
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
                                              : const SizedBox.shrink(),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 12.w, right: 22.w),
                                            child: Text(
                                              'Check out more from these artists',
                                              style: TextStyle(
                                                letterSpacing: 0.3,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          BlocProvider(
                                            create: (context) => GetRecommendedArtistsCubit()..getRecommendedArtists(artistsName),
                                            child: BlocBuilder<GetRecommendedArtistsCubit, GetRecommendedArtistsState>(
                                              builder: (context, state) {
                                                if (state is GetRecommendedArtistsLoading) {
                                                  return Container(
                                                    height: 100.h,
                                                    alignment: Alignment.center,
                                                    child: const CircularProgressIndicator(
                                                      color: AppColors.primary,
                                                    ),
                                                  );
                                                }
                                                if (state is GetRecommendedArtistsFailure) {
                                                  return Container(
                                                      height: 100.h,
                                                      alignment: Alignment.center,
                                                      child: const Text('Failed getting your artists recommendations'));
                                                }
                                                if (state is GetRecommendedArtistsLoaded) {
                                                  return SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: List.generate(
                                                        state.artists.length,
                                                        (index) {
                                                          ArtistEntity artistList = state.artists[index];

                                                          return Padding(
                                                            padding: EdgeInsets.only(
                                                              left: 12.w,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => ArtistPage(artistId: artistList.id!),
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
                                                                            blurRadius: 10,
                                                                            offset: const Offset(3, 3),
                                                                          ),
                                                                        ],
                                                                        color: const Color.fromARGB(115, 54, 54, 54),
                                                                        borderRadius: BorderRadius.circular(10.sp)),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                ),
                                                                SizedBox(
                                                                  width: 8.w,
                                                                )
                                                              ],
                                                            ),
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
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
          //   },
          // ),
          ),
    );
  }
}
