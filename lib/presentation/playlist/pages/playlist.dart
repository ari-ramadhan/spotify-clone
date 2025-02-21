import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/favorite_button/playlist_song_tile_widget.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget_selectable.dart';
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

class _PlaylistPageState extends State<PlaylistPage> {
  String playlistName = '';
  String playlistDesc = '';

  late Map<String, Color> gradientAcak;

  double paddingAddition = 4;

  final TextEditingController _playlistNameController = TextEditingController();
  final TextEditingController _playlistDescController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<SongWithFavorite> exceptionalSongs = [];
  List<SongWithFavorite> selectedSongs = [];

  @override
  void initState() {
    super.initState();
    selectedSongs.clear();
    playlistName = widget.playlistEntity.name!;
    playlistDesc = widget.playlistEntity.description!;
    AppColors.gradientList.shuffle();
    gradientAcak = AppColors.gradientList.first;
  }

  bool isShowSelectedSongError = false;
  @override
  Widget build(BuildContext context) {
    int selectedSongCount = 0;

    return Scaffold(
      backgroundColor: AppColors.medDarkBackground,
      body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PlaylistSongsCubit()
                ..getPlaylistSongs(widget.playlistEntity.id!),
            ),
            BlocProvider(
              create: (context) => FavoriteSongCubit()..getFavoriteSongs(''),
            ),
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
                                    AppColors.medDarkBackground
                                        .withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: Center(
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
                                    child: (() {
                                      if (state is PlaylistSongsFailure) {
                                        return Center(
                                            child: SvgPicture.asset(
                                          AppVectors.playlist,
                                          height: 90.w,
                                          width: 90.w,
                                          color: Colors.white,
                                        ));
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
                                                child: SvgPicture.asset(
                                                  AppVectors.playlist,
                                                  height: 90.w,
                                                  width: 90.w,
                                                  color: Colors.white,
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
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 7.w),
                          child: Row(
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
                                    position:
                                        RelativeRect.fromLTRB(1, 60.h, 0, 0),
                                    // color: AppColors.darkBackground,
                                    menuPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        8.h,
                                      ),
                                    ),
                                    items: [
                                      PopupMenuItem(
                                          onTap: () async {
                                            blurryDialog(
                                                context: context,
                                                horizontalPadding: 21,
                                                onClosed: () {
                                                  Navigator.pop(context);
                                                },
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        children: [
                                                          EditInfoField(
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return 'You must add some title';
                                                              }
                                                              return null;
                                                            },
                                                            value: playlistName,
                                                            controller:
                                                                _playlistNameController,
                                                            label: 'Title',
                                                          ),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          SizedBox(
                                                            height: 80.h,
                                                            width: double
                                                                .maxFinite,
                                                            child:
                                                                EditInfoField(
                                                              validator:
                                                                  (value) {
                                                                    return null;
                                                                  },
                                                              value:
                                                                  playlistDesc,
                                                              isExpanded: true,
                                                              controller:
                                                                  _playlistDescController,
                                                              label:
                                                                  'Description',
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
                                                        await updatePlaylist(
                                                            context);
                                                      },
                                                      focusColor:
                                                          Colors.black45,
                                                      highlightColor:
                                                          Colors.black12,
                                                      splashColor: AppColors
                                                          .darkBackground
                                                          .withOpacity(0.3),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          15.sp,
                                                        ),
                                                      ),
                                                      color: AppColors.primary,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5.h),
                                                      child: Text(
                                                        'Update',
                                                        style: TextStyle(
                                                            fontSize: 17.sp),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                dialogTitle:
                                                    'Edit playlist Info');
                                          },
                                          child:
                                              const Text('Edit Playlist Info')),
                                      PopupMenuItem(
                                          child: const Text('Delete playlist'),
                                          onTap: () {
                                            blurryDialog(
                                              onClosed: () {
                                                Navigator.pop(context);
                                              },
                                              context: context,
                                              dialogTitle:
                                                  'Delete this playlisttt',
                                              horizontalPadding: 21,
                                              content: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Confirm to delete this playlist?',
                                                    style: TextStyle(
                                                        fontSize: 16.sp),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: MaterialButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.sp)),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4.h),
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .white70),
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
                                                        create:
                                                            (contextPlaylist) =>
                                                                PlaylistCubit(),
                                                        lazy: true,
                                                        child: BlocBuilder<
                                                            PlaylistCubit,
                                                            PlaylistState>(
                                                          builder:
                                                              (contextPlaylist,
                                                                      state) =>
                                                                  Expanded(
                                                            child:
                                                                MaterialButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15.sp)),
                                                              onPressed: () {
                                                                deletePlaylist(
                                                                    context:
                                                                        context,
                                                                    playlistContext:
                                                                        contextPlaylist);
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            4.h),
                                                                child: Text(
                                                                  'Confirm',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.sp,
                                                                      color: Colors
                                                                          .red),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 13.w + paddingAddition.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                playlistName,
                                style: TextStyle(
                                  fontSize:
                                      playlistName.length < 17 ? 21.sp : 17.sp,
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
                                    ' 2019',
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w + paddingAddition.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BlocBuilder<PlaylistSongsCubit,
                                      PlaylistSongsState>(
                                    builder: (playctx, state) {
                                      if (state is PlaylistSongsLoaded) {
                                        return IconButton(
                                          iconSize: 20.sp,
                                          onPressed: () async {
                                            setState(() {
                                              selectedSongs = [];
                                            });

                                            await blurryDialog(
                                              context: context,
                                              horizontalPadding: 21,
                                              dialogTitle: 'Add songs',
                                              onClosed: () {
                                                Navigator.pop(context);
                                              },
                                              content: SizedBox(
                                                width: double.maxFinite,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'From your favorites',
                                                      style: TextStyle(
                                                          fontSize: 16.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    BlocProvider(
                                                      create: (context) =>
                                                          FavoriteSongCubit()
                                                            ..getFavoriteSongs(
                                                                ''),
                                                      child: BlocBuilder<
                                                          FavoriteSongCubit,
                                                          FavoriteSongState>(
                                                        builder:
                                                            (context, state) {
                                                          if (state
                                                              is FavoriteSongLoading) {
                                                            return const CircularProgressIndicator();
                                                          }
                                                          if (state
                                                              is FavoriteSongFailure) {
                                                            return const Center(
                                                              child: Text(
                                                                  'failed'),
                                                            );
                                                          }
                                                          if (state
                                                              is FavoriteSongLoaded) {
                                                            state.songs
                                                                .removeWhere(
                                                              (song) {
                                                                return exceptionalSongs
                                                                    .any(
                                                                  (excludeSong) {
                                                                    return excludeSong
                                                                            .song
                                                                            .id ==
                                                                        song.song
                                                                            .id;
                                                                  },
                                                                );
                                                              },
                                                            );

                                                            List<SongWithFavorite>
                                                                realList =
                                                                state.songs;

                                                            return ListView
                                                                .separated(
                                                              itemCount:
                                                                  realList
                                                                      .length,
                                                              shrinkWrap: true,
                                                              separatorBuilder:
                                                                  (context,
                                                                      index) {
                                                                return SizedBox(
                                                                  height: 6.h,
                                                                );
                                                              },
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return SongTileWidgetSelectable(
                                                                  songEntity:
                                                                      realList[
                                                                          index],
                                                                  onSelectionChanged:
                                                                      (selectedSong) {
                                                                    setState(
                                                                        () {
                                                                      if (selectedSong !=
                                                                          null) {
                                                                        // Tambahkan jika tidak ada di daftar
                                                                        if (!selectedSongs
                                                                            .contains(selectedSong)) {
                                                                          selectedSongs
                                                                              .add(selectedSong);
                                                                          setState(
                                                                              () {
                                                                            selectedSongCount++;
                                                                          });
                                                                          print(
                                                                              'Added: ${selectedSong.song.title}');
                                                                        }
                                                                      } else {
                                                                        // Hapus berdasarkan id jika ada
                                                                        selectedSongs.removeWhere((song) =>
                                                                            song.song.id ==
                                                                            realList[index].song.id);
                                                                        setState(
                                                                            () {
                                                                          selectedSongCount--;
                                                                        });
                                                                        print(
                                                                            'Removed: ${realList[index].song.title}');
                                                                      }
                                                                    });

                                                                    // Debugging: Tampilkan semua ID lagu yang dipilih
                                                                    print(
                                                                        'Current Selected Songs: ${realList.length}');
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          }

                                                          return Container();
                                                        },
                                                      ),
                                                    ),
                                                    isShowSelectedSongError
                                                        ? const Text(
                                                            'please select at least 1 song',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    SizedBox(
                                                      height: 12.h,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          '$selectedSongCount song selected',
                                                          style: TextStyle(
                                                              fontSize: 16.sp,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: MaterialButton(
                                                            onPressed:
                                                                () async {
                                                              await playctx
                                                                  .read<
                                                                      PlaylistSongsCubit>()
                                                                  .addSongToPlaylist(
                                                                      widget
                                                                          .playlistEntity
                                                                          .id!,
                                                                      selectedSongs,
                                                                      context);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            focusColor:
                                                                Colors.black45,
                                                            highlightColor:
                                                                Colors.black12,
                                                            splashColor: AppColors
                                                                .darkBackground
                                                                .withOpacity(
                                                                    0.3),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                15.sp,
                                                              ),
                                                            ),
                                                            color: selectedSongs
                                                                    .isNotEmpty
                                                                ? AppColors
                                                                    .primary
                                                                : AppColors
                                                                    .darkGrey,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        5.h),
                                                            child: Text(
                                                              'Add',
                                                              style: TextStyle(
                                                                fontSize: 17.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
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
                              BlocBuilder<PlaylistSongsCubit,
                                  PlaylistSongsState>(
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
                                        color: state.songs.isEmpty
                                            ? Colors.grey
                                            : AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SongPlayerPage(
                                                          songs: state.songs,
                                                          startIndex: 0)));
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
                              exceptionalSongs = state.songs;

                              // getting artist name by the playlist song's artist name and removes the dupe
                              List<String> artistsName = state.songs
                                  .map((e) => e.song.artist)
                                  .toSet()
                                  .toList();

                              return state.songs.isNotEmpty
                                  ? SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListView.builder(
                                            // padding: EdgeInsets.only(
                                            //   left: 13.w + paddingAddition.w,
                                            // ),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return PlaylistSongTileWidget(
                                                index: index,
                                                songList: state.songs,
                                                playlistId:
                                                    widget.playlistEntity.id!,
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
                                                      color: Colors.white54,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 16.w, right: 22.w),
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
                                            create: (context) =>
                                                GetRecommendedArtistsCubit()
                                                  ..getRecommendedArtists(
                                                      artistsName),
                                            child: BlocBuilder<
                                                GetRecommendedArtistsCubit,
                                                GetRecommendedArtistsState>(
                                              builder: (context, state) {
                                                if (state
                                                    is GetRecommendedArtistsLoading) {
                                                  return Container(
                                                    height: 100.h,
                                                    alignment: Alignment.center,
                                                    child:
                                                        const CircularProgressIndicator(
                                                      color: AppColors.primary,
                                                    ),
                                                  );
                                                }
                                                if (state
                                                    is GetRecommendedArtistsFailure) {
                                                  return Container(
                                                      height: 100.h,
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                          'Failed getting your artists recommendations'));
                                                }
                                                if (state
                                                    is GetRecommendedArtistsLoaded) {
                                                  return SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: List.generate(
                                                        state.artists.length,
                                                        (index) {
                                                          ArtistEntity
                                                              artistList =
                                                              state.artists[
                                                                  index];

                                                          return Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: 12.w,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator
                                                                        .pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                ArtistPage(artistId: artistList.id!),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            5.h),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          10.w,
                                                                      vertical:
                                                                          10.h,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black.withOpacity(
                                                                              0.3,
                                                                            ),
                                                                            blurRadius:
                                                                                10,
                                                                            offset:
                                                                                const Offset(3, 3),
                                                                          ),
                                                                        ],
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            115,
                                                                            54,
                                                                            54,
                                                                            54),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.sp)),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                50.sp,
                                                                            backgroundImage:
                                                                                NetworkImage(
                                                                              '${AppURLs.supabaseArtistStorage}${artistList.name!.toLowerCase()}.jpg',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              18.h,
                                                                        ),
                                                                        Text(
                                                                          artistList
                                                                              .name!,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12.sp,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              4.h,
                                                                        ),
                                                                        Text(
                                                                          'Artist',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11.sp,
                                                                            color:
                                                                                Colors.white70,
                                                                            fontWeight:
                                                                                FontWeight.w500,
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

  Future<void> deletePlaylist(
      {required BuildContext context,
      required BuildContext playlistContext}) async {
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
    var result =
        context.read<PlaylistCubit>().deletePlaylist(widget.playlistEntity.id!);
    // Menghapus Dialog Loading
    Navigator.of(context, rootNavigator: true).pop();

    // Menampilkan hasil
    // result.fold(
    //   (l) {
    //     customSnackBar(isSuccess: false, text: l, context: context);

    //     Navigator.pop(context);
    //   },
    //   (r) {
    //     context
    //         .read<PlaylistSongsCubit>()
    //         .getPlaylistSongs(widget.playlistEntity.id!);
    //     customSnackBar(isSuccess: true, text: r, context: context);
    //     Navigator.pop(context);
    //     Navigator.pop(context);
    //   },
    // );
  }


}
