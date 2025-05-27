import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget_controllable.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget_deletable.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/data/models/auth/user.dart';
import 'package:spotify_clone/domain/usecases/user/update_username.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_cubit.dart';
import 'package:spotify_clone/presentation/playlist/bloc/search_song/search_song_for_playlist_cubit.dart';
import 'package:spotify_clone/presentation/playlist/bloc/search_song/search_song_for_playlist_state.dart';
import 'package:spotify_clone/presentation/playlist/pages/playlist_list_page.dart';
import 'package:spotify_clone/presentation/profile/bloc/search_song_state.dart';

import 'export.dart';

class ProfilePage extends StatefulWidget {
  final UserWithStatus userEntity;
  final bool hideBackButton;
  const ProfilePage({
    super.key,
    required this.userEntity,
    this.hideBackButton = false,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  TextEditingController playlistController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<SongWithFavorite>> _selectedSongs = ValueNotifier<List<SongWithFavorite>>([]);

  final SearchSongForPlaylistCubit _searchCubit = SearchSongForPlaylistCubit();

  FocusNode _focusNode = FocusNode();
  final FocusNode _playlistNameFocusNode = FocusNode();

  ValueNotifier<bool> playlistNameFocusNotifier = ValueNotifier(false);

  final GlobalKey<FormState> _editProfileKey = GlobalKey();
  final GlobalKey<FormState> _createPlaylistKey = GlobalKey();
  final GlobalKey<FormState> _searchFormKey = GlobalKey();

  TabController? _tabController;

  String fullName = '';
  String email = '';
  String userId = '';
  bool isCurrentUser = false;

  bool _isFocused = false;
  bool _playlistNameFieldIsFocused = false;
  ValueNotifier<bool> _isNotEmpty = ValueNotifier<bool>(false);

  Future getUserInfo() async {
    List<String>? userInfo = await AuthService().getUserLoggedInInfo();
    if (userInfo != null) {
      setState(() {
        userId = userInfo[0];
        email = userInfo[1];
        fullName = userInfo[2];
        isCurrentUser = userInfo[0] == widget.userEntity.userEntity.userId;
        usernameController.text = userInfo[2];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    !isCurrentUser ? context.read<PlaylistCubit>().getCurrentuserPlaylist(widget.userEntity.userEntity.userId!) : null;

    context.read<AvatarCubit>().getUserAvatar();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _tabController?.addListener(() {
      setState(() {});
    });

    _searchController.addListener(() {
      setState(() {
        _isNotEmpty.value = _searchController.text.isNotEmpty;
      });
    });
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    _playlistNameFocusNode.addListener(() {
      setState(() {
        playlistNameFocusNotifier = ValueNotifier<bool>(_playlistNameFocusNode.hasFocus);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    playlistController.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SongWithFavorite> selectedSongs = [];
    return !isLoading
        ? Scaffold(
            appBar: BasicAppbar(
              hideBackButton: widget.hideBackButton,
              backgroundColor: context.isDarkMode ? const Color(0xff2c2b2b) : Colors.white,
              title: Text(
                'Profile',
                style: TextStyle(color: context.isDarkMode ? Colors.white : Colors.black),
              ),
              action: isCurrentUser
                  ? IconButton(
                      onPressed: () {
                        showMenuOptions(context);
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileInfo(context),
                  SizedBox(
                    height: 0.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0).copyWith(right: 5.w),
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => FavoriteSongCubit()..getFavoriteSongs(isCurrentUser ? '' : widget.userEntity.userEntity.userId!),
                        ),
                        BlocProvider(
                          create: (context) => FollowedArtistsCubit()..getFollowedArtists(isCurrentUser ? '' : widget.userEntity.userEntity.userId!),
                        ),
                      ],
                      child: BlocBuilder<PlaylistCubit, PlaylistState>(
                        key: const ValueKey(PlaylistState),
                        builder: (context, state) => Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: isCurrentUser ? 5.h : 10.h).copyWith(bottom: isCurrentUser ? 0 : 10.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'My Library',
                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: context.isDarkMode ? AppColors.grey : AppColors.darkGrey),
                                  ),
                                  isCurrentUser
                                      ? MaterialButton(
                                          onPressed: () async {
                                            blurryDialog(
                                                context: context,
                                                onClosed: () {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    selectedSongs.clear();
                                                    playlistController.clear();
                                                  });
                                                },
                                                horizontalPadding: 10,
                                                dialogTitle: 'Create a playlist',
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Form(
                                                        key: _createPlaylistKey,
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                                                          child: playlistTitleField(),
                                                        )),
                                                    SizedBox(
                                                      height: 23.h,
                                                    ),
                                                    MaterialButton(
                                                      onPressed: () async {
                                                        await (
                                                          BuildContext context,
                                                        ) async {
                                                          if (_createPlaylistKey.currentState!.validate()) {
                                                            Navigator.of(context).pop();
                                                            blurryDialog(
                                                              context: context,
                                                              dialogTitle: 'Select some song',
                                                              isDoubleTitled: true,
                                                              secondTitle: Text(
                                                                playlistController.text.toString(),
                                                                style: TextStyle(fontSize: 20.sp, height: 1, color: AppColors.primary),
                                                              ),
                                                              content: Padding(
                                                                padding: EdgeInsets.symmetric(horizontal: 0.w),
                                                                child: BlocProvider(
                                                                  create: (context) => FavoriteSongCubit()..getFavoriteSongs(isCurrentUser ? '' : widget.userEntity.userEntity.userId!),
                                                                  child: BlocBuilder<FavoriteSongCubit, FavoriteSongState>(builder: (context, state) {
                                                                    final isLoading2 = state is FavoriteSongLoading;
                                                                    final isLoaded = state is FavoriteSongLoaded;
                                                                    final songs = isLoaded ? (state).songs : [];

                                                                    return Container(
                                                                      alignment: Alignment.center,
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          _SongAdditionTabBar(tabController: _tabController),
                                                                          SizedBox(
                                                                            height: 10.h,
                                                                          ),
                                                                          SizedBox(
                                                                            height: 220.h,
                                                                            child: TabBarView(
                                                                              controller: _tabController,
                                                                              children: [
                                                                                _searchSongSection(songs.whereType<SongWithFavorite>().toList()),
                                                                                !isLoading2
                                                                                    ? addFromFavoriteSongsBuild(songs.whereType<SongWithFavorite>().toList())
                                                                                    : Container(
                                                                                        alignment: Alignment.center,
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            const CircularProgressIndicator(
                                                                                              color: AppColors.primary,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 5.h,
                                                                                            ),
                                                                                            Text(
                                                                                              'Loading your favorite songs...',
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontSize: 12.sp,
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10.h,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              ValueListenableBuilder(
                                                                                valueListenable: _selectedSongs,
                                                                                builder: (context, value, child) {
                                                                                  return value.isEmpty
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
                                                                                            GestureDetector(
                                                                                              onTap: () {
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  barrierColor: Colors.black.withOpacity(0.8),
                                                                                                  builder: (BuildContext context) {
                                                                                                    return BlocProvider(
                                                                                                      create: (context) => FavoriteSongCubit(),
                                                                                                      child: Dialog(
                                                                                                        backgroundColor: Colors.black,
                                                                                                        elevation: 0,
                                                                                                        insetPadding: EdgeInsets.symmetric(
                                                                                                          horizontal: 12.w,
                                                                                                          vertical: 12.h,
                                                                                                        ),
                                                                                                        child: Container(
                                                                                                          padding: EdgeInsets.all(17.w).copyWith(right: 6.w),
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: Colors.grey.shade900,
                                                                                                            borderRadius: BorderRadius.circular(10.sp),
                                                                                                          ),
                                                                                                          child: Column(
                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                            children: [
                                                                                                              Row(
                                                                                                                children: [
                                                                                                                  Expanded(
                                                                                                                    child: Text(
                                                                                                                      'Songs to Add',
                                                                                                                      style: TextStyle(
                                                                                                                        fontSize: 18.sp,
                                                                                                                        fontWeight: FontWeight.w500,
                                                                                                                        color: Colors.white,
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
                                                                                                                          child: Icon(
                                                                                                                            Icons.close,
                                                                                                                            color: Colors.grey.shade400,
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
                                                                                                                                _selectedSongs.value = List.from(_selectedSongs.value)
                                                                                                                                  ..removeWhere((song) => song.song.id == value[index].song.id);
                                                                                                                                Navigator.pop(context);
                                                                                                                              } else {
                                                                                                                                _selectedSongs.value = List.from(_selectedSongs.value)
                                                                                                                                  ..removeWhere((song) => song.song.id == value[index].song.id);
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
                                                                                                                    customSnackBar(isSuccess: true, text: 'Success adding a song', context: context);
                                                                                                                    Navigator.pop(context);
                                                                                                                    Navigator.pop(context);
                                                                                                                  },
                                                                                                                  focusColor: Colors.black45,
                                                                                                                  highlightColor: Colors.black12,
                                                                                                                  splashColor: Colors.grey.shade800,
                                                                                                                  shape: RoundedRectangleBorder(
                                                                                                                    borderRadius: BorderRadius.circular(
                                                                                                                      15.sp,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  color: value.isNotEmpty ? Colors.blueAccent : Colors.grey.shade700,
                                                                                                                  padding: EdgeInsets.zero,
                                                                                                                  elevation: 0,
                                                                                                                  child: Text(
                                                                                                                    'Add to Playlist',
                                                                                                                    style: TextStyle(
                                                                                                                      fontSize: 17.sp,
                                                                                                                      color: Colors.white,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              )
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                              child: Container(
                                                                                                width: 100,
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
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                },
                                                                              ),
                                                                              ValueListenableBuilder(
                                                                                valueListenable: _selectedSongs,
                                                                                builder: (context, value, child) => MaterialButton(
                                                                                  onPressed: () async {
                                                                                    List<int> selectedSongsId = _selectedSongs.value.map((e) => e.song.id).toList();

                                                                                    var result2 = await context.read<PlaylistCubit>().createPlaylist(
                                                                                        playlistTitle: playlistController.text.toString(),
                                                                                        playlistDesc: '',
                                                                                        isPublic: true,
                                                                                        selectedSongsId: selectedSongsId);
                                                                                    result2.fold(
                                                                                      (l) {
                                                                                        customSnackBar(isSuccess: false, text: l, context: context);
                                                                                        playlistController.clear();
                                                                                        selectedSongs.clear();

                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      (r) {
                                                                                        customSnackBar(isSuccess: true, text: r, context: context);
                                                                                        playlistController.clear();
                                                                                        selectedSongs.clear();
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  focusColor: Colors.black45,
                                                                                  splashColor: AppColors.primary,
                                                                                  highlightColor: AppColors.primary,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      15.sp,
                                                                                    ),
                                                                                    side: BorderSide(
                                                                                      color: Colors.grey.shade200,
                                                                                    ),
                                                                                  ),
                                                                                  child: Text(
                                                                                    value.isNotEmpty ? 'Create playlist' : 'Add song later',
                                                                                    style: TextStyle(
                                                                                      fontSize: 14.sp,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }),
                                                                ),
                                                              ),
                                                              horizontalPadding: 10,
                                                              onClosed: () {
                                                                playlistController.clear();
                                                                _searchController.clear();
                                                                _selectedSongs.value.clear();
                                                                _searchCubit.restartState();
                                                                Navigator.of(context).pop();
                                                              },
                                                            );
                                                          }
                                                        }(context);
                                                      },
                                                      focusColor: Colors.black45,
                                                      splashColor: AppColors.primary,
                                                      highlightColor: AppColors.primary,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(
                                                          15.sp,
                                                        ),
                                                        side: BorderSide(
                                                          color: Colors.grey.shade200,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'Next',
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(Icons.arrow_forward_ios_rounded, size: 14.sp),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                  ],
                                                ));
                                          },
                                          focusColor: Colors.black45,
                                          splashColor: AppColors.primary,
                                          highlightColor: AppColors.primary,
                                          padding: EdgeInsets.only(right: 10.w, left: 6.w),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15.sp,
                                            ),
                                            side: BorderSide(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.add,
                                                size: 16.sp,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                              Text(
                                                'Create playlist',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                            favoriteSongsButton(),
                            playlistListBuilder(state),
                            artistFollowedBuilder()
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ),
            ),
          )
        : Container(
            height: double.infinity,
            width: double.infinity,
            color: AppColors.darkBackground,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
  }

  BlocBuilder<FollowedArtistsCubit, FollowedArtistsState> artistFollowedBuilder() {
    return BlocBuilder<FollowedArtistsCubit, FollowedArtistsState>(
      builder: (context, state) {
        if (state is FollowedArtistsFailure) {
          return SizedBox(
            height: 100.h,
            child: const Center(
              child: Text('Failed to get your favorite artists'),
            ),
          );
        }

        if (state is FollowedArtistsLoading) {
          return Column(
            children: [
              ElementTitleWidget(
                onTap: () {},
                elementTitle: 'Artist followed',
                limit: 4,
                list: const [],
              ),
              const SkeletonPlaylistTile(
                isRounded: true,
                isCircle: false,
              ),
              const SkeletonPlaylistTile(
                isRounded: true,
                isCircle: false,
              ),
              const SkeletonPlaylistTile(
                isRounded: true,
                isCircle: false,
              ),
              const SkeletonPlaylistTile(
                isRounded: true,
                isCircle: false,
              ),
            ],
          );
        }

        if (state is FollowedArtistsLoaded) {
          return state.artists.isNotEmpty
              ? Column(
                  children: [
                    ElementTitleWidget(
                      elementTitle: 'Artists followed',
                      list: state.artists,
                      limit: 4,
                      onTap: () {},
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.artists.take(4).length,
                      itemBuilder: (context, index) {
                        var artist = state.artists[index].artist;

                        return ArtistTileWidget(artist: artist);
                      },
                    )
                  ],
                )
              : const SizedBox.shrink();
        }
        return Container();
      },
    );
  }

  Widget playlistListBuilder(PlaylistState state) {
    if (state is PlaylistLoading) {
      return Column(
        children: [
          ElementTitleWidget(
            onTap: () {},
            elementTitle: 'Playlists',
            limit: 4,
            list: const [],
          ),
          const SkeletonPlaylistTile(
            isRounded: false,
            isCircle: false,
          ),
          const SkeletonPlaylistTile(
            isRounded: false,
            isCircle: false,
          ),
          const SkeletonPlaylistTile(
            isRounded: false,
            isCircle: false,
          ),
          const SkeletonPlaylistTile(
            isRounded: false,
            isCircle: false,
          ),
        ],
      );
    }
    if (state is PlaylistFailure) {
      return const Center(
        child: Text('Failed to fetch your library'),
      );
    }

    if (state is PlaylistLoaded) {
      return state.playlistModel.isNotEmpty
          ? Column(
              children: [
                ElementTitleWidget(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaylistListPage(playlists: state.playlistModel),
                      ),
                    );
                  },
                  elementTitle: 'Playlists',
                  limit: 4,
                  list: state.playlistModel,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var playlist = state.playlistModel[index];

                    return PlaylistTileWidget(
                      playlist: playlist,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaylistPage(
                              playlistEntity: playlist, // Pass the playlist object
                              userEntity: isCurrentUser ? UserEntity(email: email, fullName: fullName, userId: userId) : widget.userEntity.userEntity,
                              onPlaylistDeleted: () {
                                context.read<PlaylistCubit>().getCurrentuserPlaylist('');
                                Navigator.pop(context); // Pop back to PlaylistView
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  itemCount: state.playlistModel.take(4).length,
                ),
              ],
            )
          : Container(
              alignment: Alignment.center,
              height: 100.h,
              child: const Text(
                'You have no playlist',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white54,
                ),
              ),
            );
    }
    return Container();
  }

  BlocBuilder<FavoriteSongCubit, FavoriteSongState> favoriteSongsButton() {
    return BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
      builder: (context, state) {
        bool isLoading = state is FavoriteSongLoading;
        return MaterialButton(
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyFavorite(
                  length: state is FavoriteSongLoaded ? state.songs.length : 0,
                  userEntity: isCurrentUser ? UserEntity(email: email, fullName: fullName, userId: userId) : widget.userEntity.userEntity,
                ),
              ),
            );
          },
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: 40.h,
                width: 44.w,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfffb3a6a), Color(0xff1c61f5)],
                    stops: [0.3, 1],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 26.sp,
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer(
                    enabled: isLoading,
                    textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(0)),
                    child: Text(
                      'My Favorites',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Skeletonizer(
                    textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(0)),
                    enabled: isLoading,
                    child: Text(
                      'Playlist | ${state is FavoriteSongLoaded ? state.songs.length : 0} songs',
                      style: TextStyle(fontSize: 10.sp, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> showMenuOptions(BuildContext context) {
    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1, 60.h, 0, 0),
      menuPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          5.h,
        ),
      ),
      elevation: 1,
      items: [
        PopupMenuItem(
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              AuthService authService = AuthService();
              await supabase.auth.signOut(scope: SignOutScope.global);
              await authService.logout();

              Future.delayed(
                const Duration(seconds: 4),
                () {},
              );
              setState(() {
                isLoading = false;
              });

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const GetStartedPage()),
                (Route<dynamic> route) => false, // Menghapus semua halaman sebelumnya
              );
            },
            child: const Text('Sign Out')),
      ],
    );
  }

  TextFormField playlistTitleField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'fill the playlist name';
        } else if (value.length > 20) {
          return 'playlist name must be less than 20 characters';
        }
        return null;
      },
      focusNode: _playlistNameFocusNode,
      style: TextStyle(fontSize: 20.sp),
      textAlign: TextAlign.center,
      controller: playlistController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  void _profileEditDialog() {
    void close() {
      Navigator.pop(context);
    }

    blurryDialog(
        context: context,
        onClosed: () async {
          close();
          await context.read<AvatarCubit>().getUserAvatar();
        },
        dialogTitle: 'Edit your profile',
        content: BlocBuilder<AvatarCubit, AvatarState>(
          builder: (context1, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Builder(
                          builder: (context) {
                            final state = context.watch<AvatarCubit>().state;

                            if (state is AvatarLoaded) {
                              return CircleAvatar(
                                radius: 46.sp,
                                backgroundImage: NetworkImage(state.imageUrl),
                              );
                            } else if (state is AvatarPicked) {
                              return ClipOval(child: state.imageUrl);
                            } else {
                              return CircleAvatar(
                                radius: 46.sp,
                                backgroundColor: Colors.grey.shade700,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 70.sp,
                                ),
                              );
                            }
                          },
                        ),
                        state is AvatarPicked
                            ? const SizedBox.shrink()
                            : SizedBox(
                                height: 23.sp,
                                width: 23.sp,
                                child: MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    showMenuAvatar(context, state);
                                  },
                                  color: Colors.blue,
                                  shape: const CircleBorder(),
                                  child: Icon(
                                    state is AvatarLoaded || state is AvatarInitial ? Icons.more_vert : Icons.edit,
                                    size: 15.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                      ],
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    state is AvatarPicked
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_right_alt_outlined,
                                size: 30.sp,
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 46.sp,
                                        backgroundImage: FileImage(state.imageFile),
                                      ),
                                      state is AvatarUploading
                                          ? CircleAvatar(
                                              radius: 46.sp,
                                              child: const Center(
                                                child: CircularProgressIndicator(
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                  SizedBox(
                                    height: 23.sp,
                                    width: 23.sp,
                                    child: MaterialButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        context.read<AvatarCubit>().uploadAvatar(state.imageFile, userId);
                                        Navigator.pop(context);
                                      },
                                      color: AppColors.primary,
                                      shape: const CircleBorder(),
                                      child: Icon(
                                        Icons.done_rounded,
                                        size: 17.sp,
                                        weight: 2,
                                        fill: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                if (state is AvatarError)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(state.message, style: const TextStyle(color: Colors.red)),
                  ),
                SizedBox(
                  height: 10.h,
                ),
                Form(
                  key: _editProfileKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'username must be filled';
                          }
                          return null;
                        },
                        controller: usernameController,
                        style: TextStyle(fontSize: 18.sp),
                        decoration: InputDecoration(
                          hintText: 'fill with desired username',
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                          contentPadding: EdgeInsets.only(bottom: 5.h),
                          border: const UnderlineInputBorder(),
                          errorBorder: const UnderlineInputBorder(),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                MaterialButton(
                  onPressed: () async {
                    if (_editProfileKey.currentState!.validate()) {
                      if (state is AvatarPicked) {
                        context.read<AvatarCubit>().uploadAvatar(state.imageFile, userId);
                      }
                      var result = await sl<UpdateUsernameUseCase>().call(params: usernameController.text);
                      result.fold(
                        (l) {
                          customSnackBar(isSuccess: false, text: l, context: context);
                        },
                        (r) {
                          customSnackBar(isSuccess: true, text: r, context: context);
                          AuthService().saveUserLoggedInInfo(UserModel(userId: userId, email: email, fullName: usernameController.text));
                          getUserInfo();
                          close();
                        },
                      );
                    }
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
                  color: AppColors.primary,
                  minWidth: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    'Confirm changes',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                )
              ],
            );
          },
        ),
        horizontalPadding: 16.w);
  }

  Widget _profileInfo(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FollowerCubit()
            ..getFollowerAndFollowing(
              isCurrentUser ? userId : widget.userEntity.userEntity.userId!,
            ),
        ),
      ],
      child: BlocBuilder<FollowerCubit, FollowerState>(
        builder: (context, state) {
          bool isLoading = state is FollowerLoading;
          return Container(
            decoration: BoxDecoration(
              color: context.isDarkMode ? const Color(0xff2c2b2b) : Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60.w),
                bottomRight: Radius.circular(60.w),
              ),
            ),
            width: double.infinity,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(AppVectors.profilePattern),
                    RotatedBox(
                      quarterTurns: 90,
                      child: SvgPicture.asset(AppVectors.profilePattern),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),
                      isCurrentUser
                          ? currentUserProfileImage()
                          : SizedBox(
                              height: 92.sp,
                              width: 92.sp,
                              child: ClipOval(
                                child: widget.userEntity.userEntity.avatarUrl != null && widget.userEntity.userEntity.avatarUrl!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: widget.userEntity.userEntity.avatarUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.grey.shade700,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                          size: 70.sp,
                                        ),
                                      ),
                              ),
                            ),
                      SizedBox(height: isCurrentUser ? 10.h : 0),
                      Skeletonizer(
                        enabled: isLoading,
                        child: isCurrentUser
                            ? Text(
                                email,
                                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w300, letterSpacing: 0.3),
                              )
                            : const SizedBox.shrink(),
                      ),
                      SizedBox(height: 10.h),
                      Skeletonizer(
                        enabled: isLoading,
                        child: Text(
                          isCurrentUser ? fullName : widget.userEntity.userEntity.fullName ?? '',
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, letterSpacing: 0.3),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Skeletonizer(
                        enabled: isLoading,
                        child: !isCurrentUser ? FollowUserButton(user: widget.userEntity) : const SizedBox.shrink(),
                      ),
                      SizedBox(height: 4.h),
                      Skeletonizer(
                        enabled: isLoading,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FollowCount(
                              count: state is FollowerLoaded ? state.followEntity.following!.count : 0, // Placeholder during loading
                              title: 'Following',
                            ),
                            FollowCount(
                              count: state is FollowerLoaded ? state.followEntity.follower!.count : 0, // Placeholder during loading
                              title: 'Followers',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  BlocBuilder<AvatarCubit, AvatarState> currentUserProfileImage() {
    return BlocBuilder<AvatarCubit, AvatarState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 92.sp,
              height: 92.sp,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 65.sp,
                ),
              ),
            ),
            if (state is AvatarLoaded || state is AvatarInitial)
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  if (state is AvatarLoaded)
                    CircleAvatar(
                      radius: 46.sp,
                      backgroundImage: NetworkImage(state.imageUrl),
                    ),
                  SizedBox(
                    height: 23.sp,
                    width: 23.sp,
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _profileEditDialog();
                      },
                      color: Colors.white,
                      shape: const CircleBorder(),
                      child: Icon(
                        Icons.edit,
                        size: 15.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            else if (state is AvatarPicked)
              ClipOval(
                child: state.imageUrl,
              ),
          ],
        );
      },
    );
  }

  showMenuAvatar(BuildContext context, AvatarState state) {
    showMenu(
      context: context,
      menuPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
      position: RelativeRect.fromLTRB(50.w, context.size!.height * 0.76, 40.w, -100.h),
      items: [
        PopupMenuItem(
          height: 28.h,
          onTap: () {
            context.read<AvatarCubit>().pickImage();
          },
          child: Row(
            children: [
              Icon(
                Icons.upload_rounded,
                color: Colors.blue,
                size: 17.sp,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                'Upload profile picture',
                style: TextStyle(color: Colors.blue, fontSize: 12.sp, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        if (state is AvatarLoaded) ...[
          PopupMenuItem(
            height: 28.h,
            onTap: () {
              context.read<AvatarCubit>().deleteAvatarImage();
            },
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: 17.sp,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  'Remove profile picture',
                  style: TextStyle(color: Colors.red, fontSize: 12.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
          )
        ],
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
                    key: _searchFormKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please fill with the desired keyword';
                        }
                      },
                      focusNode: _focusNode,
                      controller: _searchController,
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
                ValueListenableBuilder(
                  valueListenable: _isNotEmpty,
                  builder: (context, value, child) {
                    return BlocBuilder<SearchSongForPlaylistCubit, SearchSongForPlaylistState>(
                      bloc: _searchCubit,
                      builder: (context, state) {
                        var isLoaded = state is SearchSongForPlaylistLoaded;
                        return SizedBox(
                          width: 45.w,
                          child: MaterialButton(
                            color: isLoaded
                                ? Colors.redAccent.shade700
                                : !value
                                    ? Colors.grey.shade700
                                    : AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
                            onPressed: () async {
                              if (isLoaded) {
                                _searchCubit.restartState();
                                _searchController.clear();
                                _focusNode.unfocus();
                                return;
                              } else {
                                if (_searchFormKey.currentState!.validate()) {
                                  await _searchCubit.searchSongByKeyword(_searchController.value.text);
                                }
                              }
                            },
                            child: Icon(
                              !isLoaded ? Icons.search : Icons.close,
                              size: 14.sp,
                            ),
                          ),
                        );
                      },
                    );
                  },
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
                                if (selectedSong != null) {
                                  _selectedSongs.value = List.from(_selectedSongs.value)..add(selectedSong);
                                } else {
                                  _selectedSongs.value = List.from(_selectedSongs.value)..removeWhere((song) => song.song.id == realList[index].song.id);
                                }
                              });
                        },
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

  Widget addFromFavoriteSongsBuild(List<SongWithFavorite> realList) {
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
            List<SongWithFavorite> paginatedList = realList.sublist(startIndex, endIndex > realList.length ? realList.length : endIndex);

            return ListView.separated(
              key: ValueKey<int>(page),
              padding: EdgeInsets.zero,
              itemCount: paginatedList.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 6.h,
                );
              },
              itemBuilder: (context, index) {
                return ValueListenableBuilder<List<SongWithFavorite>>(
                  valueListenable: _selectedSongs,
                  builder: (context, selectedSongs, child) {
                    return SongTileWidgetControllable(
                      songEntity: paginatedList[index],
                      selectedSongsNotifier: _selectedSongs,
                      onSelectionChanged: (selectedSong) {
                        if (selectedSong != null) {
                          _selectedSongs.value = List.from(_selectedSongs.value)..add(selectedSong);
                        } else {
                          _selectedSongs.value = List.from(_selectedSongs.value)..removeWhere((song) => song.song.id == paginatedList[index].song.id);
                        }
                        setState(() {});
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
                        setState(() {
                          currentPage.value--;
                        });
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
                        setState(() {
                          currentPage.value++;
                        });
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

  Widget selectedSongsPreview(BuildContext playctx, List<SongWithFavorite> value) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.8),
          builder: (BuildContext context) {
            return BlocProvider(
              create: (context) => FavoriteSongCubit(),
              child: Dialog(
                backgroundColor: Colors.black,
                elevation: 0,
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
                child: Container(
                  padding: EdgeInsets.all(17.w).copyWith(right: 6.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Songs to Add',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
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
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.grey.shade400,
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
                            customSnackBar(isSuccess: true, text: 'Success adding a song', context: context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          focusColor: Colors.black45,
                          highlightColor: Colors.black12,
                          splashColor: Colors.grey.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              15.sp,
                            ),
                          ),
                          color: value.isNotEmpty ? Colors.blueAccent : Colors.grey.shade700,
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          child: Text(
                            'Add to Playlist',
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 30.h,
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade800,
                    ),
                    child: CircleAvatar(
                      radius: 12.sp,
                      backgroundColor: Colors.grey.shade800,
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade900,
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
}

class _SongAdditionTabBar extends StatelessWidget {
  const _SongAdditionTabBar({
    super.key,
    required TabController? tabController,
  }) : _tabController = tabController;

  final TabController? _tabController;

  @override
  Widget build(BuildContext context) {
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
      onTap: (value) {},
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
}

class SkeletonPlaylistTile extends StatelessWidget {
  final bool isCircle;
  final bool isRounded;
  final double extraPadding;
  const SkeletonPlaylistTile({
    required this.isCircle,
    required this.isRounded,
    this.extraPadding = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 17.w + extraPadding),
      child: Row(
        children: [
          Skeletonizer(
            enabled: true,
            child: Container(
              height: 40.h,
              width: 44.w,
              decoration: BoxDecoration(shape: isCircle ? BoxShape.circle : BoxShape.rectangle, color: Colors.grey.shade800, borderRadius: BorderRadius.circular(isRounded ? 7.sp : 0)),
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeletonizer(
                textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(0)),
                enabled: true,
                child: Text(
                  'data data data data data data ',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Skeletonizer(
                enabled: true,
                textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(0)),
                child: Text(
                  'Playlist | empty song',
                  style: TextStyle(fontSize: 10.sp, color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
