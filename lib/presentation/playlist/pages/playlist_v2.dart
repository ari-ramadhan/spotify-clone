import 'package:spotify_clone/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify_clone/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify_clone/common/widgets/favorite_button/playlist_song_tile_widget.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget_selectable.dart';
import 'package:spotify_clone/core/configs/constants/app_methods.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/playlist/playlist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/domain/usecases/playlist/delete_playlist.dart';
import 'package:spotify_clone/domain/usecases/playlist/update_playlist_info.dart';
import 'package:spotify_clone/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_cubit.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_state.dart';
import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_state.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_state.dart';

class PlaylistTest extends StatefulWidget {
  final PlaylistEntity playlistEntity;
  PlaylistTest({
    Key? key,
    required this.playlistEntity,
  }) : super(key: key);

  @override
  State<PlaylistTest> createState() => _PlaylistTestState();
}

class _PlaylistTestState extends State<PlaylistTest> {
  String playlistName = '';
  String playlistDesc = '';

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
              create: (context) => PlaylistSongsCubit()..getPlaylistSongs(widget.playlistEntity.id!),
            ),
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
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade700,
                                    ),
                                    child: (() {
                                      if (state is PlaylistSongsFailure) {
                                        return Center(
                                          child: Text(
                                            playlistName[0],
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
                                                  playlistName![0],
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
                                                    return Image.network('${AppURLs.supabaseCoverStorage}${e.song.artist} - ${e.song.title}.jpg');
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
                                            blurryDialog(
                                                context: context,
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
                                                              validator: (value) {},
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
                                          },
                                          child: const Text('Edit Playlist Info')),
                                      PopupMenuItem(
                                          child: const Text('Delete playlist'),
                                          onTap: () {
                                            blurryDialog(
                                              context: context,
                                              dialogTitle: 'Delete this playlist',
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
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(vertical: 4.h),
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 1,
                                                        height: 15.h,
                                                        color: Colors.white,
                                                      ),
                                                      Expanded(
                                                        child: MaterialButton(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
                                                          onPressed: () {
                                                            deletePlaylist(context);
                                                          },
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(vertical: 4.h),
                                                            child: Text(
                                                              'Confirm',
                                                              style: TextStyle(fontSize: 16.sp, color: Colors.red),
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
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                playlistName!,
                                style: TextStyle(
                                  fontSize: playlistName!.length < 17 ? 23.sp : 18.sp,
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
                                      "~ ${playlistDesc}",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white54,
                                        height: 1,
                                      ),
                                    ),
                              playlistDesc.isEmpty
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                      height: 10.h,
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
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
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
                                        return IconButton(
                                          iconSize: 20.sp,
                                          onPressed: () async {
                                            setState(() {
                                              selectedSongs = [];
                                            });

                                            await blurryDialog(
                                              context: context,
                                              dialogTitle: 'Add songs',
                                              content: Container(
                                                width: double.maxFinite,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'From your favorites',
                                                      style: TextStyle(fontSize: 16.sp),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    BlocProvider(
                                                      create: (context) => FavoriteSongCubit()..getFavoriteSongs(),
                                                      child: BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
                                                        builder: (context, state) {
                                                          if (state is FavoriteSongLoading) {
                                                            return const CircularProgressIndicator();
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

                                                            return ListView.separated(
                                                              itemCount: realList.length,
                                                              shrinkWrap: true,
                                                              separatorBuilder: (context, index) {
                                                                return SizedBox(
                                                                  height: 6.h,
                                                                );
                                                              },
                                                              itemBuilder: (context, index) {
                                                                return SongTileWidgetSelectable(
                                                                  songEntity: realList[index],
                                                                  onSelectionChanged: (selectedSong) {
                                                                    setState(() {
                                                                      if (selectedSong != null) {
                                                                        // Tambahkan jika tidak ada di daftar
                                                                        if (!selectedSongs.contains(selectedSong)) {
                                                                          selectedSongs.add(selectedSong);
                                                                          print('Added: ${selectedSong.song.title}');
                                                                        }
                                                                      } else {
                                                                        // Hapus berdasarkan id jika ada
                                                                        selectedSongs.removeWhere((song) => song.song.id == realList[index].song.id);
                                                                        print('Removed: ${realList[index].song.title}');
                                                                      }
                                                                    });

                                                                    // Debugging: Tampilkan semua ID lagu yang dipilih
                                                                    print('Current Selected Songs: ${realList.length}');
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
                                                            style: TextStyle(color: Colors.red),
                                                          )
                                                        : const SizedBox.shrink(),
                                                    SizedBox(
                                                      height: 12.h,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          '${selectedSongs.length} song selected',
                                                          style: TextStyle(fontSize: 16.sp, color: Colors.white),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.centerRight,
                                                          child: MaterialButton(
                                                            onPressed: () async {
                                                              await playctx
                                                                  .read<PlaylistSongsCubit>()
                                                                  .addSongToPlaylist(widget.playlistEntity.id!, selectedSongs, context);
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
                                                            color: selectedSongs.isNotEmpty ? AppColors.primary : AppColors.darkGrey,
                                                            padding: EdgeInsets.symmetric(vertical: 5.h),
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
                                      margin: EdgeInsets.only(right: 10.w),
                                      padding: EdgeInsets.all(5.h),
                                      decoration: BoxDecoration(
                                        color: state.songs.isEmpty ? Colors.grey : AppColors.primary,
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

                              return state.songs.isNotEmpty
                                  ? SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListView.separated(
                                            padding: EdgeInsets.only(left: 13.w, top: 5.h),
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              var songs = state.songs[index];
                                              bool isFavorite = state.songs[index].isFavorite;

                                              return Padding(
                                                padding: EdgeInsets.only(right: 2.w),
                                                child: PlaylistSongTileWidget(
                                                  songList: state.songs,
                                                  index: index,
                                                  playlistId: widget.playlistEntity.id!,
                                                  suffixActionButton: PopupMenuButton(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.sp)),
                                                    menuPadding: EdgeInsets.zero,
                                                    elevation: 0,
                                                    iconSize: 16.sp,
                                                    splashRadius: 15.sp,
                                                    offset: Offset(-11.w, 32.h),
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        height: 28.h,
                                                        // padding: EdgeInsets.zero,
                                                        textStyle: TextStyle(fontSize: 12.sp),
                                                        onTap: () {
                                                          context.read<PlaylistSongsCubit>().removeSongFromPlaylist(widget.playlistEntity.id!, songs);
                                                        },
                                                        value: 'Remove',
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.playlist_remove_rounded,
                                                              size: 17.sp,
                                                              color: Colors.redAccent,
                                                            ),
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            const Text(
                                                              'Remove',
                                                              style: TextStyle(color: Colors.redAccent),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        height: 28.h,
                                                        onTap: () {
                                                          context.read<PlaylistSongsCubit>().toggleFavoriteStatus(songs.song.id);
                                                          sl<AddOrRemoveFavoriteSongUseCase>().call(params: songs.song.id);
                                                        },
                                                        textStyle: TextStyle(fontSize: 12.sp),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              songs.isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                                              size: 17.sp,
                                                              color: songs.isFavorite ? AppColors.primary : IconThemeData().color,
                                                            ),
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            Text(
                                                              songs.isFavorite ? 'Remove from favorite' : 'Add to favorite',
                                                              style: TextStyle(color: songs.isFavorite ? AppColors.primary : Colors.white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
          var errorSnackbar = SnackBar(
            content: Text(
              l,
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
          Navigator.pop(context);
        },
        (r) {
          var successSnackbar = SnackBar(
            content: Text(
              r,
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          );
          setState(() {
            playlistName = _playlistNameController.text;
            playlistDesc = _playlistDescController.text;
          });
          ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
          Navigator.pop(context);
        },
      );
    } else {}
  }

  Future<void> deletePlaylist(BuildContext context) async {
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
              children: const [
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
    var result = await sl<DeletePlaylistUseCase>().call(params: widget.playlistEntity.id!);

    // Menghapus Dialog Loading
    Navigator.of(context, rootNavigator: true).pop();

    // Menampilkan hasil
    result.fold(
      (l) {
        var errorSnackbar = SnackBar(
          content: Text(
            l,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);

        Navigator.pop(context);
      },
      (r) {
        context.read<PlaylistSongsCubit>().getPlaylistSongs(widget.playlistEntity.id!);
        var successSnackbar = SnackBar(
          content: Text(
            r,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }
}

class EditInfoField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String value;
  final FormFieldValidator<String>? validator;

  final bool isExpanded;
  const EditInfoField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    required this.value,
    this.isExpanded = false,
  });

  @override
  State<EditInfoField> createState() => _EditInfoFieldState();
}

class _EditInfoFieldState extends State<EditInfoField> {
  @override
  void dispose() {
    super.dispose();
    widget.controller.clear();
  }

  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isExpanded
        ? TextFormField(
            expands: true,
            minLines: null,
            validator: widget.validator,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: widget.controller,
            decoration: InputDecoration(
              fillColor: AppColors.darkBackground,
              labelText: widget.label,
              labelStyle: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            ),
          )
        : TextFormField(
            minLines: 1,
            maxLines: 1,
            validator: widget.validator,
            keyboardType: TextInputType.text,
            controller: widget.controller,
            decoration: InputDecoration(
              fillColor: AppColors.darkBackground,
              labelText: widget.label,
              labelStyle: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            ),
          );
  }
}


// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:spotify_clone/common/helpers/export.dart';
// import 'package:spotify_clone/common/widgets/favorite_button/playlist_song_tile_widget.dart';
// import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget_selectable.dart';
// import 'package:spotify_clone/core/configs/constants/app_methods.dart';
// import 'package:spotify_clone/core/configs/constants/app_urls.dart';
// import 'package:spotify_clone/domain/entity/playlist/playlist.dart';
// import 'package:spotify_clone/domain/entity/song/song.dart';
// import 'package:spotify_clone/domain/usecases/playlist/add_songs_to_playlist.dart';
// import 'package:spotify_clone/domain/usecases/playlist/delete_playlist.dart';
// import 'package:spotify_clone/domain/usecases/playlist/update_playlist_info.dart';
// import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_cubit.dart';
// import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_state.dart';
// import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_cubit.dart';
// import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_state.dart';
// import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_cubit.dart';
// import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_state.dart';
// import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

// class PlaylistTest extends StatefulWidget {
//   final PlaylistEntity playlistEntity;
//   PlaylistTest({
//     Key? key,
//     required this.playlistEntity,
//   }) : super(key: key);

//   @override
//   State<PlaylistTest> createState() => _PlaylistTestState();
// }

// class _PlaylistTestState extends State<PlaylistTest> {
//   String playlistName = '';
//   String playlistDesc = '';

//   final TextEditingController _playlistNameController = TextEditingController();
//   final TextEditingController _playlistDescController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   List<SongWithFavorite> exceptionalSongs = [];
//   List<SongWithFavorite> selectedSongs = [];

//   @override
//   void initState() {
//     super.initState();
//     selectedSongs.clear();
//     playlistName = widget.playlistEntity.name!;
//     playlistDesc = widget.playlistEntity.description!;
//   }

//   final TextEditingController _controller = TextEditingController();

//   bool isShowSelectedSongError = false;
//   @override
//   Widget build(BuildContext context) {
//     // Merandomkan list
//     AppColors.gradientList.shuffle();

//     // Mengambil elemen acak
//     Map<String, Color> gradientAcak = AppColors.gradientList.first;

//     return Scaffold(
//       backgroundColor: AppColors.medDarkBackground,
//       body: MultiBlocProvider(
//           providers: [
//             BlocProvider(
//               create: (context) => PlaylistSongsCubit()..getPlaylistSongs(widget.playlistEntity.id!),
//             ),
//             BlocProvider(
//               create: (context) => FavoriteSongCubit()..getFavoriteSongs(),
//             )
//           ],
//           child:
//               // BlocBuilder(
//               //   builder: (context, state) {
//               //     return
//               SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 24.w),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 height: 16.h,
//                               ),
//                               Text(
//                                 playlistName!,
//                                 style: TextStyle(
//                                   fontSize: playlistName!.length < 17 ? 23.sp : 18.sp,
//                                   fontWeight: FontWeight.w800,
//                                   letterSpacing: 0.4,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5.h,
//                               ),
//                               playlistDesc.isEmpty
//                                   ? const SizedBox.shrink()
//                                   : Text(
//                                       "~ ${playlistDesc}",
//                                       style: TextStyle(
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.white54,
//                                         height: 1,
//                                       ),
//                                     ),
//                               playlistDesc.isEmpty
//                                   ? SizedBox.shrink()
//                                   : SizedBox(
//                                       height: 3.h,
//                                     ),
//                               SizedBox(
//                                 height: 15.h,
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5.h,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 13.w),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
//                                     builder: (playctx, state) {
//                                       if (state is PlaylistSongsLoaded) {
//                                         return IconButton(
//                                           onPressed: () async {
//                                             await showDialog(
//                                               context: context,
//                                               builder: (context) {
//                                                 return AlertDialog(
//                                                   title: const Text('Add Song by Keyword'),
//                                                   content: SizedBox(
//                                                     height: 300,
//                                                     child: BlocProvider(
//                                                       create: (context) => FavoriteSongCubit()..getFavoriteSongs(),
//                                                       child: BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
//                                                         builder: (context, state) {
//                                                           if (state is FavoriteSongLoading) {
//                                                             return const CircularProgressIndicator();
//                                                           }
//                                                           if (state is FavoriteSongFailure) {
//                                                             return const Center(
//                                                               child: Text('failed'),
//                                                             );
//                                                           }
//                                                           if (state is FavoriteSongLoaded) {
//                                                             state.songs.removeWhere(
//                                                               (song) {
//                                                                 return exceptionalSongs.any(
//                                                                   (excludeSong) {
//                                                                     return excludeSong.song.id == song.song.id;
//                                                                   },
//                                                                 );
//                                                               },
//                                                             );

//                                                             List<SongWithFavorite> realList = state.songs;

//                                                             return SingleChildScrollView(
//                                                               child: Column(
//                                                                 children: realList
//                                                                     .map(
//                                                                       (e) => SongTileWidgetSelectable(
//                                                                         songEntity: e,
//                                                                         onSelectionChanged: (selectedSong) {
//                                                                           setState(() {
//                                                                             if (selectedSong != null) {
//                                                                               // Tambahkan jika tidak ada di daftar
//                                                                               if (!selectedSongs.contains(selectedSong)) {
//                                                                                 selectedSongs.add(selectedSong);
//                                                                                 print('Added: ${selectedSong.song.title}');
//                                                                               }
//                                                                             } else {
//                                                                               // Hapus berdasarkan id jika ada
//                                                                               selectedSongs.removeWhere((song) => song.song.id == e.song.id);
//                                                                               print('Removed: ${e.song.title}');
//                                                                             }
//                                                                           });

//                                                                           // Debugging: Tampilkan semua ID lagu yang dipilih
//                                                                           print('Current Selected Songs: ${realList.length}');
//                                                                         },
//                                                                       ),
//                                                                     )
//                                                                     .toList(),
//                                                               ),
//                                                             );

//                                                             return ListView.separated(
//                                                               itemCount: realList.length,
//                                                               shrinkWrap: true,
//                                                               separatorBuilder: (context, index) {
//                                                                 return SizedBox(
//                                                                   height: 6.h,
//                                                                 );
//                                                               },
//                                                               itemBuilder: (context, index) {
//                                                                 return SongTileWidgetSelectable(
//                                                                   songEntity: realList[index],
//                                                                   onSelectionChanged: (selectedSong) {
//                                                                     setState(() {
//                                                                       if (selectedSong != null) {
//                                                                         // Tambahkan jika tidak ada di daftar
//                                                                         if (!selectedSongs.contains(selectedSong)) {
//                                                                           selectedSongs.add(selectedSong);
//                                                                           print('Added: ${selectedSong.song.title}');
//                                                                         }
//                                                                       } else {
//                                                                         // Hapus berdasarkan id jika ada
//                                                                         selectedSongs.removeWhere((song) => song.song.id == realList[index].song.id);
//                                                                         print('Removed: ${realList[index].song.title}');
//                                                                       }
//                                                                     });

//                                                                     // Debugging: Tampilkan semua ID lagu yang dipilih
//                                                                     print('Current Selected Songs: ${realList.length}');
//                                                                   },
//                                                                 );
//                                                               },
//                                                             );
//                                                           }

//                                                           return Container();
//                                                         },
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   actions: [
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         Navigator.pop(context);
//                                                       },
//                                                       child: const Text('Cancel'),
//                                                     ),
//                                                     ElevatedButton(
//                                                       onPressed: () async {
//                                                         // await context.read<PlaylistSongsCubit>().addSongByKeyword(
//                                                         //       widget.playlistEntity.id!,
//                                                         //       _controller.text,
//                                                         //       state.songs,
//                                                         //     );
//                                                         // Navigator.pop(context);
//                                                         await playctx
//                                                             .read<PlaylistSongsCubit>()
//                                                             .addSongToPlaylist(widget.playlistEntity.id!, selectedSongs, context);
//                                                         Navigator.pop(context);
//                                                       },
//                                                       child: const Text('Add'),
//                                                     ),
//                                                   ],
//                                                 );
//                                               },
//                                             );
//                                             context.read<PlaylistSongsCubit>().getPlaylistSongs(widget.playlistEntity.id!);
//                                           },
//                                           splashRadius: 22.sp,
//                                           icon: Icon(
//                                             Icons.add_circle_outline_rounded,
//                                             color: AppColors.primary,
//                                             size: 28.w,
//                                           ),
//                                         );
//                                       }
//                                       return Container();
//                                     },
//                                   ),
//                                   IconButton(
//                                     splashRadius: 22.sp,
//                                     onPressed: () {},
//                                     icon: Icon(
//                                       Icons.more_horiz_rounded,
//                                       color: Colors.white70,
//                                       size: 28.w,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
//                                 builder: (context, state) {
//                                   if (state is PlaylistSongsLoading) {
//                                     return Container();
//                                   }
//                                   if (state is PlaylistFailure) {
//                                     return Container(
//                                       margin: EdgeInsets.only(right: 10.w),
//                                       padding: EdgeInsets.all(5.h),
//                                       decoration: const BoxDecoration(
//                                         color: Colors.grey,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: IconButton(
//                                         onPressed: () {},
//                                         icon: Icon(
//                                           Icons.play_disabled_rounded,
//                                           size: 25.h,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                   if (state is PlaylistSongsLoaded) {
//                                     return Container(
//                                       margin: EdgeInsets.only(right: 10.w),
//                                       padding: EdgeInsets.all(5.h),
//                                       decoration: BoxDecoration(
//                                         color: state.songs.isEmpty ? Colors.grey : AppColors.primary,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: IconButton(
//                                         onPressed: () {},
//                                         icon: Icon(
//                                           Icons.play_arrow_rounded,
//                                           size: 25.h,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                   return Container();
//                                 },
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),

//                 // Body Scrollable
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.only(top: 10.h),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Album Songs
//                         BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
//                           builder: (context, state) {
//                             if (state is PlaylistSongsLoading) {
//                               return Container(
//                                 height: 100.h,
//                                 width: double.infinity,
//                                 alignment: Alignment.center,
//                                 child: const CircularProgressIndicator(
//                                   color: AppColors.primary,
//                                 ),
//                               );
//                             }
//                             if (state is PlaylistSongsFailure) {
//                               return Container(
//                                 height: 100.h,
//                                 width: double.infinity,
//                                 alignment: Alignment.center,
//                                 child: const Text('Failed to fetch songs'),
//                               );
//                             }
//                             if (state is PlaylistSongsLoaded) {
//                               exceptionalSongs = state.songs;

//                               return state.songs.isNotEmpty
//                                   ? SingleChildScrollView(
//                                       child: Column(
//                                         children: [
//                                           ListView.separated(
//                                             padding: EdgeInsets.only(left: 22.w, top: 5.h),
//                                             physics: const NeverScrollableScrollPhysics(),
//                                             shrinkWrap: true,
//                                             itemBuilder: (context, index) {
//                                               var songs = state.songs[index];
//                                               return Padding(
//                                                 padding: EdgeInsets.only(right: 10.w),
//                                                 child: PlaylistSongTileWidget(
//                                                   songList: state.songs,
//                                                   index: index,
//                                                   playlistId: widget.playlistEntity.id!,
//                                                   suffixActionButton: PopupMenuButton(
//                                                     menuPadding: EdgeInsets.zero,
//                                                     elevation: 0,
//                                                     splashRadius: 20.sp,
//                                                     offset: Offset(-20.w, 38.h),
//                                                     itemBuilder: (context) => [
//                                                       PopupMenuItem(
//                                                         onTap: () {
//                                                           context.read<PlaylistSongsCubit>().removeSongFromPlaylist(widget.playlistEntity.id!, songs);
//                                                         },
//                                                         value: 'Delete',
//                                                         child: const Text('Delete'),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             separatorBuilder: (context, index) {
//                                               return SizedBox(
//                                                 height: 13.h,
//                                               );
//                                             },
//                                             itemCount: state.songs.length,
//                                           ),
//                                           state.songs.length < 7
//                                               ? Container(
//                                                   height: 100.h,
//                                                   width: double.infinity,
//                                                   alignment: Alignment.center,
//                                                   child: const Text(
//                                                     'No other songs',
//                                                     style: TextStyle(
//                                                       fontStyle: FontStyle.italic,
//                                                       color: Colors.white54,
//                                                     ),
//                                                   ),
//                                                 )
//                                               : const SizedBox.shrink()
//                                         ],
//                                       ),
//                                     )
//                                   : Container(
//                                       alignment: Alignment.center,
//                                       height: 200.h,
//                                       child: const Text(
//                                         'No songs added to this playlist',
//                                         style: TextStyle(
//                                           fontStyle: FontStyle.italic,
//                                           color: Colors.white54,
//                                         ),
//                                       ),
//                                     );
//                             }

//                             return Container();
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           )
//           //   },
//           // ),
//           ),
//     );
//   }

//   Future<void> addSongsToPlaylist(BuildContext context) async {
//     List selectedSongsId = [];
//     for (var song in selectedSongs) {
//       selectedSongsId.add(song.song.id);
//     }
//     await context.read<PlaylistSongsCubit>().addSongToPlaylist(widget.playlistEntity.id!, selectedSongs, context);
//     Navigator.pop(context);
//   }

//   Future<void> updatePlaylist(BuildContext context) async {
//     if (_formKey.currentState!.validate()) {
//       var result = await sl<UpdatePlaylistInfoUseCase>().call(
//         params: UpdatePlaylistInfoParams(
//           title: _playlistNameController.text.toString(),
//           description: _playlistDescController.text.toString(),
//           playlistId: widget.playlistEntity.id!,
//         ),
//       );

//       result.fold(
//         (l) {
//           var errorSnackbar = SnackBar(
//             content: Text(
//               l,
//               style: const TextStyle(color: Colors.black),
//             ),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           );
//           ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
//           Navigator.pop(context);
//         },
//         (r) {
//           var successSnackbar = SnackBar(
//             content: Text(
//               r,
//               style: const TextStyle(color: Colors.black),
//             ),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//           );
//           setState(() {
//             playlistName = _playlistNameController.text;
//             playlistDesc = _playlistDescController.text;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
//           Navigator.pop(context);
//         },
//       );
//     } else {}
//   }

//   Future<void> deletePlaylist(BuildContext context) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Tidak bisa ditutup tanpa selesai
//       builder: (BuildContext context) {
//         return const AlertDialog(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           content: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: const [
//                 CircularProgressIndicator(color: Colors.white),
//                 SizedBox(height: 10),
//                 Text(
//                   "Deleting playlist...",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );

//     // Melakukan query
//     var result = await sl<DeletePlaylistUseCase>().call(params: widget.playlistEntity.id!);

//     // Menghapus Dialog Loading
//     Navigator.of(context, rootNavigator: true).pop();

//     // Menampilkan hasil
//     result.fold(
//       (l) {
//         var errorSnackbar = SnackBar(
//           content: Text(
//             l,
//             style: const TextStyle(color: Colors.black),
//           ),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         );
//         ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);

//         Navigator.pop(context);
//       },
//       (r) {
//         context.read<PlaylistSongsCubit>().getPlaylistSongs(widget.playlistEntity.id!);
//         var successSnackbar = SnackBar(
//           content: Text(
//             r,
//             style: const TextStyle(color: Colors.black),
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//         );
//         ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
//         Navigator.pop(context);
//         Navigator.pop(context);
//       },
//     );
//   }
// }

// class EditInfoField extends StatefulWidget {
//   final TextEditingController controller;
//   final String label;
//   final String value;
//   final FormFieldValidator<String>? validator;

//   final bool isExpanded;
//   const EditInfoField({
//     super.key,
//     required this.controller,
//     required this.label,
//     required this.validator,
//     required this.value,
//     this.isExpanded = false,
//   });

//   @override
//   State<EditInfoField> createState() => _EditInfoFieldState();
// }

// class _EditInfoFieldState extends State<EditInfoField> {
//   @override
//   void dispose() {
//     super.dispose();
//     widget.controller.clear();
//   }

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.text = widget.value;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.isExpanded
//         ? TextFormField(
//             expands: true,
//             minLines: null,
//             validator: widget.validator,
//             maxLines: null,
//             keyboardType: TextInputType.multiline,
//             controller: widget.controller,
//             decoration: InputDecoration(
//               fillColor: AppColors.darkBackground,
//               labelText: widget.label,
//               labelStyle: const TextStyle(
//                 color: Colors.white70,
//                 fontWeight: FontWeight.w500,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.sp),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.blue),
//                 borderRadius: BorderRadius.circular(10.sp),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.sp),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: AppColors.primary),
//                 borderRadius: BorderRadius.circular(10.sp),
//               ),
//               contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
//             ),
//           )
//         : TextFormField(
//             minLines: 1,
//             maxLines: 1,
//             validator: widget.validator,
//             keyboardType: TextInputType.text,
//             controller: widget.controller,
//             decoration: InputDecoration(
//               fillColor: AppColors.darkBackground,
//               labelText: widget.label,
//               labelStyle: const TextStyle(
//                 color: Colors.white70,
//                 fontWeight: FontWeight.w500,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.sp),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.blue),
//                 borderRadius: BorderRadius.circular(10.sp),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.sp),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: AppColors.primary),
//                 borderRadius: BorderRadius.circular(10.sp),
//               ),
//               contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
//             ),
//           );
//   }
// }
