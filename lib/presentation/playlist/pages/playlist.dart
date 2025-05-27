import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/favorite_button/playlist_song_tile_widget.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget_deletable.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget_selectable.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget_controllable.dart';
import 'package:spotify_clone/core/configs/constants/app_methods.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/auth/user.dart';
import 'package:spotify_clone/domain/entity/playlist/playlist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/domain/usecases/playlist/update_playlist_info.dart';
import 'package:spotify_clone/presentation/artist_page/pages/artist_page.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_cubit.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_state.dart';
import 'package:spotify_clone/presentation/playlist/bloc/recommended_artist_state.dart';
import 'package:spotify_clone/presentation/playlist/bloc/recommended_artists_cubit.dart';
import 'package:spotify_clone/presentation/playlist/bloc/search_song/search_song_for_playlist_cubit.dart';
import 'package:spotify_clone/presentation/playlist/bloc/search_song/search_song_for_playlist_state.dart';
import 'package:spotify_clone/presentation/playlist/widgets/EditInfoField.dart';
import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_state.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_state.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

class PlaylistPage extends StatefulWidget {
  final PlaylistEntity playlistEntity;
  final UserEntity userEntity;
  final VoidCallback onPlaylistDeleted;
  const PlaylistPage({
    super.key,
    required this.userEntity,
    required this.playlistEntity,
    required this.onPlaylistDeleted,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> with SingleTickerProviderStateMixin {
  String playlistName = '';
  String playlistDesc = '';

  late Map<String, Color> gradientAcak;

  double paddingAddition = 4;

  final TextEditingController _playlistNameController = TextEditingController();
  final TextEditingController _playlistDescController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<SongWithFavorite> exceptionalSongs = [];
  // List<SongWithFavorite> selectedSongs = [];

  late TabController _tabController;

  final TextEditingController _searchSongController = TextEditingController();

  final SearchSongForPlaylistCubit _searchCubit = SearchSongForPlaylistCubit();

  int selectedSongCount = 0;

  bool _isNotEmpty = false;
  late FocusNode _focusNode;
  bool _isFocused = false;

  ValueNotifier<List<SongWithFavorite>> _selectedSongs = ValueNotifier<List<SongWithFavorite>>([]);

  @override
  void initState() {
    super.initState();
    _selectedSongs.value.clear();
    playlistName = widget.playlistEntity.name!;
    playlistDesc = widget.playlistEntity.description!;
    AppColors.gradientList.shuffle();
    gradientAcak = AppColors.gradientList.first;

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _searchSongController.addListener(() {
      setState(() {
        _isNotEmpty = _searchSongController.text.isNotEmpty;
      });
    });
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
      } else {}
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _searchSongController.clear();
  // }

  bool isShowSelectedSongError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.medDarkBackground,
      body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PlaylistSongsCubit()..getPlaylistSongs(widget.playlistEntity.id!),
            ),
            BlocProvider(
              create: (context) => FavoriteSongCubit()..getFavoriteSongs(''),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Column(
                children: [
                  // Header Section (Album Picture)
                  _headerSection(context),
                  _playlistInfoSection()
                ],
              ),

              // Body Scrollable Section
              Expanded(
                child: SingleChildScrollView(
                  child: _playlistSongsSection(),
                ),
              )
            ],
          )),
    );
  }

  Stack _headerSection(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
          builder: (context, state) {
            return Container(
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              height: 180.h + MediaQuery.of(context).viewPadding.top,
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
              child: Container(
                height: 180.h,
                width: 180.h,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff091e3a),
                      Color(0xff2d6cbe),
                      Color(0xff64a9dd),
                    ],
                    stops: [0, 0.5, 0.75],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        AppVectors.playlist,
                        height: 90.w,
                        width: 90.w,
                        color: Colors.white,
                      ),
                    ),
                    if (state is PlaylistSongsLoaded) ...[
                      GridView.count(
                        crossAxisCount: 2,
                        padding: EdgeInsets.zero,
                        children: (state.songs.take(4)).map(
                          (e) {
                            return Image.network('${AppURLs.supabaseCoverStorage}${e.song.artist} - ${e.song.title}.jpg');
                          },
                        ).toList(),
                      )
                    ],
                  ],
                ),
              ),
            );
          },
        ),
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context, true);
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
                                _updatePlaylistInfoPopUp(context);
                              },
                              child: const Text('Edit Playlist Info')),
                          PopupMenuItem(
                            child: const Text('Delete playlist'),
                            onTap: () {
                              _deletePlaylistPopUp(context);
                            },
                          )
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
            ],
          ),
        )
      ],
    );
  }

  Container _playlistInfoSection() {
    return Container(
      child: Column(
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
                  playlistName,
                  style: TextStyle(
                    fontSize: playlistName.length < 17 ? 21.sp : 17.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                playlistDesc.isEmpty
                    ? const SizedBox.shrink()
                    : Text(
                        "~ $playlistDesc",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white54,
                          height: 1,
                        ),
                      ),
                playlistDesc.isEmpty
                    ? const SizedBox.shrink()
                    : SizedBox(
                        height: 10.h,
                      ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'created by',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                        height: 1,
                      ),
                    ),
                    Text(
                      ' ${widget.userEntity.fullName} ',
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
                      ' ${widget.playlistEntity.createdAt.toString().substring(0, 4)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                        height: 1,
                      ),
                    ),
                  ],
                )
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
                    BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
                      builder: (playctx, state) {
                        if (state is PlaylistSongsLoaded) {
                          List exceptionalSongs = state.songs;

                          return _addSongToPlaylistButton(playctx, exceptionalSongs);
                        }
                        return Container();
                      },
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
                BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
                  builder: (context, state) {
                    if (state is PlaylistSongsLoading) {
                      return Container();
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
                        // margin: EdgeInsets.only(right: 10.w),
                        padding: EdgeInsets.all(5.h),
                        decoration: BoxDecoration(
                          color: state.songs.isEmpty ? Colors.grey : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SongPlayerPage(
                                  songs: state.songs,
                                  startIndex: 0,
                                ),
                              ),
                            );
                          },
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Object?> _deletePlaylistPopUp(BuildContext context) {
    return blurryDialog(
      onClosed: () {
        Navigator.pop(context);
      },
      context: context,
      dialogTitle: 'Delete this playlist',
      horizontalPadding: 21,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirm to delete this playlist?',
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15.sp,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 15.h,
                color: Colors.white,
              ),
              BlocProvider(
                create: (contextPlaylist) => PlaylistCubit(),
                lazy: true,
                child: BlocBuilder<PlaylistCubit, PlaylistState>(
                  builder: (contextPlaylist, state) => Expanded(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
                      onPressed: () {
                        deletePlaylist(context: context, playlistContext: contextPlaylist);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.h,
                        ),
                        child: Text(
                          'Confirm',
                          style: TextStyle(fontSize: 16.sp, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Object?> _updatePlaylistInfoPopUp(BuildContext context) {
    return blurryDialog(
        context: context,
        horizontalPadding: 21,
        onClosed: () {
          Navigator.pop(context);
        },
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  EditInfoField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'You must add some title';
                      }
                      return null;
                    },
                    value: playlistName,
                    controller: _playlistNameController,
                    label: 'Title',
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 80.h,
                    width: double.maxFinite,
                    child: EditInfoField(
                      validator: (value) {
                        return null;
                      },
                      value: playlistDesc,
                      isExpanded: true,
                      controller: _playlistDescController,
                      label: 'Description',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            MaterialButton(
              onPressed: () async {
                await updatePlaylist(context);
              },
              focusColor: Colors.black45,
              highlightColor: Colors.black12,
              splashColor: AppColors.darkBackground.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  15.sp,
                ),
              ),
              color: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Text(
                'Update',
                style: TextStyle(fontSize: 17.sp),
              ),
            ),
          ],
        ),
        dialogTitle: 'Edit playlist Info');
  }

  BlocBuilder<PlaylistSongsCubit, PlaylistSongsState> _playlistSongsSection() {
    return BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
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
          exceptionalSongs = state.songs;

          // getting artist name by the playlist song's artist name and removes the dupe
          List<String> artistsName = state.songs.map((e) => e.song.artist).toSet().toList();

          return state.songs.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.only(top: 5.h),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return PlaylistSongTileWidget(
                            index: index,
                            songList: state.songs,
                            playlistId: widget.playlistEntity.id!,
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
                        height: 12.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 22.w),
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
                              return Container(height: 100.h, alignment: Alignment.center, child: const Text('Failed getting your artists recommendations'));
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
                                                decoration: BoxDecoration(boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(
                                                      0.3,
                                                    ),
                                                    blurRadius: 10,
                                                    offset: const Offset(3, 3),
                                                  ),
                                                ], color: const Color.fromARGB(115, 54, 54, 54), borderRadius: BorderRadius.circular(10.sp)),
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
    );
  }

  Widget _addSongToPlaylistButton(BuildContext playctx, List exceptionalSongs) {
    return IconButton(
      iconSize: 20.sp,
      onPressed: () async {
        setState(
          () {
            _selectedSongs.value = [];
          },
        );

        await blurryDialog(
          context: context,
          horizontalPadding: 21,
          dialogTitle: 'Add songs',
          onClosed: () async {
            Navigator.pop(context);
            _searchCubit.restartState();
            _searchSongController.clear();

            _selectedSongs.value.clear();
            // _searchCubit.close();
          },
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _addSongToPlaylistTabBar(),
                SizedBox(
                  height: 5.h,
                ),
                BlocProvider(
                  create: (context) => FavoriteSongCubit()..getFavoriteSongs(''),
                  child: BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
                    builder: (context, state) {
                      if (state is FavoriteSongLoading) {
                        return SizedBox(
                          height: 180.h,
                          width: double.infinity,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }
                      if (state is FavoriteSongFailure) {
                        return const Center(
                          child: Text('failed'),
                        );
                      }
                      if (state is FavoriteSongLoaded) {
                        state.songs.removeWhere(
                          (song) {
                            return exceptionalSongs.any(
                              (excludeSong) {
                                return excludeSong.song.id == song.song.id;
                              },
                            );
                          },
                        );

                        List<SongWithFavorite> realList = state.songs;

                        return SizedBox(
                          height: 220.h,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _searchSongSection(realList),
                              _favoriteSongListSection(realList),
                            ],
                          ),
                        );
                      }

                      return Container();
                    },
                  ),
                ),
                isShowSelectedSongError
                    ? const Text(
                        'please select at least 1 song',
                        style: TextStyle(color: Colors.red),
                      )
                    : const SizedBox.shrink(),
                SizedBox(
                  height: 12.h,
                ),
                ValueListenableBuilder(
                  valueListenable: _selectedSongs,
                  builder: (context, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: value.isEmpty ? CrossAxisAlignment.center : CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: value.isEmpty
                              ? Text(
                                  'no song is selected',
                                  style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade300, letterSpacing: 0.4),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected',
                                      style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade300, letterSpacing: 0.4),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    selectedSongsPreview(playctx, value)
                                  ],
                                ),
                        ),
                        Container(
                          height: 30.h,
                          child: MaterialButton(
                            onPressed: () async {
                              if (_selectedSongs.value.isEmpty) {
                                customSnackBar(isSuccess: false, text: 'Select atleast one song!', context: context);
                              } else {
                                await playctx.read<PlaylistSongsCubit>().addSongToPlaylist(widget.playlistEntity.id!, _selectedSongs.value, context);
                                customSnackBar(isSuccess: true, text: 'Success adding a song', context: context);
                                Navigator.pop(context);
                              }
                            },
                            focusColor: Colors.black45,
                            highlightColor: Colors.black12,
                            splashColor: AppColors.darkBackground.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15.sp,
                              ),
                            ),
                            color: value.isNotEmpty ? AppColors.primary : AppColors.darkGrey,
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            child: Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 17.sp,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
      splashRadius: 20.sp,
      icon: Icon(
        Icons.add_circle_outline_rounded,
        color: AppColors.primary,
        size: 28.w,
      ),
    );
  }

  Widget selectedSongsPreview(BuildContext playctx, List<SongWithFavorite> value) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.7),
          builder: (BuildContext context) {
            return BlocProvider(
              create: (context) => FavoriteSongCubit(),
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
                child: Container(
                    padding: EdgeInsets.all(17.w).copyWith(right: 6.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff21fd6e), Color.fromARGB(255, 30, 26, 26)],
                        stops: [0.01, 0.75],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Songs to add',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Scrollbar(
                          trackVisibility: true,
                          thumbVisibility: true,
                          child: SizedBox(
                            height: 172.h,
                            child: ValueListenableBuilder<List<SongWithFavorite>>(
                              valueListenable: _selectedSongs,
                              builder: (context, value, child) {
                                return ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(right: 10.w),
                                  itemCount: value.length,
                                  separatorBuilder: (context, index) => SizedBox(
                                    height: 5.h,
                                  ),
                                  itemBuilder: (context, index) {
                                    return SongTileWidgetDeletable(
                                      songEntity: value[index],
                                      onSelectionChanged: (p0) {},
                                      deleteButtonEvent: () {
                                        if (value.length == 1) {
                                          _selectedSongs.value = List.from(_selectedSongs.value)..removeWhere((song) => song.song.id == value[index].song.id);
                                          Navigator.pop(context);
                                        } else {
                                          _selectedSongs.value = List.from(_selectedSongs.value)..removeWhere((song) => song.song.id == value[index].song.id);
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Container(
                          height: 30.h,
                          width: double.maxFinite,
                          margin: EdgeInsets.only(right: 11.w),
                          child: MaterialButton(
                            onPressed: () async {
                              await playctx.read<PlaylistSongsCubit>().addSongToPlaylist(widget.playlistEntity.id!, _selectedSongs.value, context);
                              customSnackBar(isSuccess: true, text: 'Success adding a song', context: context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            focusColor: Colors.black45,
                            highlightColor: Colors.black12,
                            splashColor: AppColors.darkBackground.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15.sp,
                              ),
                            ),
                            color: value.isNotEmpty ? AppColors.primary : AppColors.darkGrey,
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            child: Text(
                              'Add to playlist',
                              style: TextStyle(
                                fontSize: 17.sp,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                    // child: Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: value.map((song) {
                    //     return SongTileWidgetSelectable(
                    //       songEntity: song,
                    //       isSelected: true,
                    //       onSelectionChanged: (selectedSong) {
                    //         // Handle selection change if needed
                    //       },
                    //     );
                    //   }).toList(),
                    // ),
                    ),
              ),
            );
          },
        );
      },
      child: Container(
        // width: 50.w,
        height: 30.h, // Add a finite height here
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(
            value.length > 3 ? 4 : value.length,
            (index) {
              if (index == 3) {
                return Positioned(
                  left: index * 18.sp,
                  child: Container(
                    padding: EdgeInsets.all(2.sp),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.darkGrey,
                    ),
                    child: CircleAvatar(
                      radius: 12.sp,
                      backgroundColor: AppColors.darkGrey,
                      child: Text(
                        '+${value.length - 3}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Positioned(
                left: index * 18.sp,
                child: Container(
                  padding: EdgeInsets.all(1.sp),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    radius: 13.sp,
                    foregroundImage: CachedNetworkImageProvider(
                      '${AppURLs.supabaseCoverStorage}${value[index].song.artist} - ${value[index].song.title}.jpg',
                      scale: 0.9,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  TabBar _addSongToPlaylistTabBar() {
    return TabBar(
      indicatorPadding: EdgeInsets.symmetric(
        horizontal: 5.w,
      ),
      labelPadding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 5.w,
      ),
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
      ),
      unselectedLabelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12.5.sp),
      controller: _tabController,
      isScrollable: true,
      indicatorColor: AppColors.primary,
      unselectedLabelColor: Colors.grey,
      onTap: (value) {
        setState(() {});
      },
      tabs: const [
        Text(
          'Search for the song',
        ),
        Text(
          'From your favorites',
        ),
      ],
    );
  }

  BlocProvider<SearchSongForPlaylistCubit> _searchSongSection(List<SongWithFavorite> realList) {
    return BlocProvider(
      create: (context) => SearchSongForPlaylistCubit(),
      child: Column(
        children: [
          SizedBox(
            height: 5.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 34, 34, 34).withOpacity(1),
              borderRadius: BorderRadius.circular(7.sp),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please fill with the desired keyword';
                        }
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      focusNode: _focusNode,
                      controller: _searchSongController,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        hintText: 'Find the song to add',
                        hintStyle: TextStyle(fontSize: 14.sp),
                        border: const OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                SizedBox(
                  width: 45.w,
                  child: MaterialButton(
                    color: _isNotEmpty ? Colors.red : Colors.grey,
                    // color: _searchCubit.state is SearchSongForPlaylistLoading || _searchCubit.state is SearchSongForPlaylistLoaded ? Colors.redAccent.shade400 : Colors.grey.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _searchCubit.searchSongByKeyword(_searchSongController.value.text);
                      }
                    },
                    child: Icon(
                      _searchCubit.state is SearchSongForPlaylistInitial ? Icons.search : Icons.close,
                      size: 14.sp,
                    ),
                  ),
                )
              ],
            ),
          ),
          Flexible(
            child: BlocBuilder<SearchSongForPlaylistCubit, SearchSongForPlaylistState>(
              bloc: _searchCubit,
              builder: (context, state) {
                if (state is SearchSongForPlaylistInitial) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade600,
                            ),
                            borderRadius: BorderRadius.circular(10.sp)),
                        height: 100.h,
                        child: Center(
                          child: Text(
                            'Type something to search',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                if (state is SearchSongForPlaylistLoading) {
                  SongWithFavorite emptySong = SongWithFavorite(
                    SongEntity(
                      title: 'data data data',
                      id: 1,
                      artist: 'data data',
                      duration: 1,
                      artistId: 1,
                      playCount: 0,
                      releaseDate: 'data data',
                    ),
                    false,
                  );

                  return Column(
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Skeletonizer(
                        enabled: true,
                        child: SongTileWidgetSelectable(
                          songEntity: emptySong,
                          isLoading: true,
                          onSelectionChanged: (p0) {},
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Skeletonizer(
                        enabled: true,
                        child: SongTileWidgetSelectable(
                          songEntity: emptySong,
                          isLoading: true,
                          onSelectionChanged: (p0) {},
                        ),
                      ),
                    ],
                  );
                }
                if (state is SearchSongForPlaylistLoaded) {
                  final songs = state.songs;

                  if (songs.isEmpty) {
                    return SizedBox(
                      height: 100.h,
                      child: const Center(
                        child: Text('Nothing related to that keyword'),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: songs.take(3).length,
                    padding: EdgeInsets.only(top: 5.h),
                    itemBuilder: (context, index) {
                      var songModel = songs[index];

                      bool isAdded = exceptionalSongs.any((song) => song.song.id == songModel.song.id);
                      bool isSelected = _selectedSongs.value.any(
                        (element) => element.song.id == songModel.song.id,
                      );

                      return ValueListenableBuilder<List<SongWithFavorite>>(
                        valueListenable: _selectedSongs,
                        builder: (context, selectedSongs, child) {
                          return SongTileWidgetControllable(
                            songEntity: songModel,
                            selectedSongsNotifier: _selectedSongs,
                            onSelectionChanged: (selectedSong) {
                              if (isAdded) {
                                customSnackBar(
                                  isSuccess: false,
                                  text: 'This song is already exist in your playlist',
                                  context: context,
                                );
                              } else {
                                if (selectedSong != null) {
                                  _selectedSongs.value = List.from(_selectedSongs.value)..add(selectedSong);
                                } else {
                                  _selectedSongs.value = List.from(_selectedSongs.value)..removeWhere((song) => song.song.id == realList[index].song.id);
                                }
                              }
                            },
                          );

                          // return SongTileWidgetSelectable(
                          //   songEntity: realList[index],
                          //   isSelected: isSelected,
                          //   onSelectionChanged: (selectedSong) {
                          //     setState(() {
                          //       if (selectedSong != null) {
                          //         if (!_selectedSongs.value.contains(selectedSong)) {
                          //           _selectedSongs.value = List.from(_selectedSongs.value)
                          //             ..add(selectedSong);
                          //           selectedSongCount++;
                          //         }
                          //       } else {
                          //         _selectedSongs.value = List.from(_selectedSongs.value)
                          //           ..removeWhere((song) =>
                          //               song.song.id == realList[index].song.id);
                          //         selectedSongCount--;
                          //       }

                          //       print(_selectedSongs.value.length);
                          //     });
                          //   },
                          // );
                        },
                      );

                      return SongTileWidgetSelectable(
                        songEntity: songModel,
                        isSelected: isSelected,
                        onSelectionChanged: (selectedSong) {
                          if (isAdded) {
                            customSnackBar(
                              isSuccess: false,
                              text: 'This song is already exist in your playlist',
                              context: context,
                            );
                          } else {
                            setState(() {
                              if (selectedSong != null) {
                                if (!_selectedSongs.value.contains(selectedSong)) {
                                  _selectedSongs.value = List.from(_selectedSongs.value)..add(selectedSong);
                                  selectedSongCount++;
                                }
                              } else {
                                _selectedSongs.value = List.from(_selectedSongs.value)..removeWhere((song) => song.song.id == realList[index].song.id);
                                _selectedSongs.value = List.from(_selectedSongs.value)
                                  ..removeWhere(
                                    (song) => song.song.id == realList[index].song.id,
                                  );
                                selectedSongCount--;
                                _selectedSongs.notifyListeners(); // Notify UI about changes
                              }
                            });
                          }
                        },
                        isAdded: isAdded,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 6.h,
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _favoriteSongListSection(List<SongWithFavorite> realList) {
  int itemsPerPage = 4;
  int totalPages = (realList.length / itemsPerPage).ceil();
  ValueNotifier<int> currentPage = ValueNotifier<int>(1);

  return Column(
    children: [
      ValueListenableBuilder<int>(
        valueListenable: currentPage,
        builder: (context, page, child) {
          int startIndex = (page - 1) * itemsPerPage;
          int endIndex = startIndex + itemsPerPage;
          List<SongWithFavorite> paginatedList =
              realList.sublist(startIndex, endIndex > realList.length ? realList.length : endIndex);

          return ListView.separated(
            key: ValueKey<int>(page), // <-- Ensure new list rebuilds with different key
            padding: EdgeInsets.zero,
            itemCount: paginatedList.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 6.h,
              );
            },
            itemBuilder: (context, index) {
              SongWithFavorite song = paginatedList[index];
              return ValueListenableBuilder<List<SongWithFavorite>>(
                valueListenable: _selectedSongs,
                builder: (context, selectedSongs, child) {
                  bool isSelected = selectedSongs.any((s) => s.song.id == song.song.id);
                  return SongTileWidgetControllable(
                    songEntity: song,
                    selectedSongsNotifier: _selectedSongs,
                    // isSelected: isSelected, // <-- Pass selected state explicitly
                    onSelectionChanged: (selectedSong) {
                      if (selectedSong != null) {
                        _selectedSongs.value = List.from(_selectedSongs.value)..add(selectedSong);
                      } else {
                        _selectedSongs.value = List.from(_selectedSongs.value)
                          ..removeWhere((s) => s.song.id == song.song.id);
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
      SizedBox(
        height: 5.h,
      ),
      // Pagination
      ValueListenableBuilder(
        valueListenable: currentPage,
        builder: (context, value, child) {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (currentPage.value > 1) {
                      currentPage.value--;
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 16.sp,
                    color: currentPage.value > 1 ? Colors.white : Colors.grey,
                  ),
                ),
                Text(
                  '${currentPage.value} / $totalPages',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (currentPage.value < totalPages) {
                      currentPage.value++;
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color: currentPage.value < totalPages ? Colors.white : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
}


  Future<void> updatePlaylist(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var result = await sl<UpdatePlaylistInfoUseCase>().call(
        params: UpdatePlaylistInfoParams(
          title: _playlistNameController.text.toString(),
          description: _playlistDescController.text.toString(),
          playlistId: widget.playlistEntity.id!,
        ),
      );

      result.fold(
        (l) {
          customSnackBar(isSuccess: false, text: l, context: context);
          Navigator.pop(context, true);
        },
        (r) {
          setState(() {
            playlistName = _playlistNameController.text;
            playlistDesc = _playlistDescController.text;
          });
          customSnackBar(isSuccess: true, text: r, context: context);
          Navigator.pop(context, true);
        },
      );
    } else {}
  }

  Future<void> deletePlaylist({required BuildContext context, required BuildContext playlistContext}) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa ditutup tanpa selesai
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Deleting playlist...",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Melakukan query
    context.read<PlaylistCubit>().deletePlaylist(widget.playlistEntity.id!);
    // Menghapus Dialog Loading
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
