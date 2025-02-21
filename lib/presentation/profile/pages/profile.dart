import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/data/models/auth/user.dart';
import 'package:spotify_clone/domain/usecases/user/update_username.dart';

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

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  TextEditingController playlistController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final GlobalKey<FormState> _editProfileKey = GlobalKey();
  final GlobalKey<FormState> _createPlaylistKey = GlobalKey();

  List<SongWithFavorite> selectedSongs = [];

  String fullName = '';
  String email = '';
  String userId = '';
  bool isCurrentUser = false;

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
    context.read<AvatarCubit>().getUserAvatar();
  }

  @override
  void dispose() {
    super.dispose();
    playlistController.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _profileInfo(context),
                      // _testing(),
                      SizedBox(
                        height: 0.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0).copyWith(right: 5.w),
                        // child: playlistsList(),
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => PlaylistCubit()..getCurrentuserPlaylist(isCurrentUser ? '' : widget.userEntity.userEntity.userId!),
                            ),
                            BlocProvider(
                              create: (context) => FavoriteSongCubit()..getFavoriteSongs(isCurrentUser ? '' : widget.userEntity.userEntity.userId!),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  FollowedArtistsCubit()..getFollowedArtists(isCurrentUser ? '' : widget.userEntity.userEntity.userId!),
                            ),
                          ],
                          child: BlocBuilder<PlaylistCubit, PlaylistState>(
                            key: const ValueKey(PlaylistState),
                            builder: (context, state) => Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: isCurrentUser ? 5.h : 10.h)
                                      .copyWith(bottom: isCurrentUser ? 0 : 10.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'My Library',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: context.isDarkMode ? AppColors.grey : AppColors.darkGrey),
                                      ),
                                      isCurrentUser ? createPlaylistButton(context) : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                // Favorite page button
                                favoriteSongsButton(),
                                // list of playlists
                                playlistListBuilder(state),
                                // list of followed artists
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
              ],
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
                      itemCount: state.artists.length,
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

  MaterialButton createPlaylistButton(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        // showAddPlaylistModal(context, '');
        blurryDialog(
            context: context,
            onClosed: () {
              Navigator.pop(context);
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
                  ),
                ),
                SizedBox(
                  height: 23.h,
                ),
                MaterialButton(
                  onPressed: () async {
                    await createPlaylist(context, selectedSongs);
                  },
                  focusColor: Colors.black45,
                  // highlightColor: Colors.black12,
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
                    'Create playlist',
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: BlocProvider(
                    create: (context) => FavoriteSongCubit()..getFavoriteSongs(isCurrentUser ? '' : widget.userEntity.userEntity.userId!),
                    child: BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
                      builder: (context, state) {
                        if (state is FavoriteSongLoading) {
                          return Container(
                            alignment: Alignment.center,
                            height: 100,
                            child: const CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }
                        if (state is FavoriteSongFailure) {
                          return Container(alignment: Alignment.center, height: 100, child: const Text('Failed to fetch songs'));
                        }
                        if (state is FavoriteSongLoaded) {
                          return Container(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From your favorites',
                                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                                ),
                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 10.w),
                                  itemCount: state.songs.take(5).length,
                                  itemBuilder: (context, index) {
                                    var songModel = state.songs[index];

                                    return SongTileWidgetSelectable(
                                      songEntity: songModel,
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
                                            selectedSongs.removeWhere((song) => song.song.id == songModel.song.id);
                                            print('Removed: ${songModel.song.title}');
                                          }
                                        });

                                        // Debugging: Tampilkan semua ID lagu yang dipilih
                                        print('Current Selected Songs: ${selectedSongs.map((s) => s.song.id).toList()}');
                                      },

                                      // isSelected: true,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 6.h,
                                    );
                                  },
                                )
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                )
              ],
            ));
      },
      focusColor: Colors.black45,
      // highlightColor: Colors.black12,
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
    );
  }

  Widget playlistListBuilder(PlaylistState state) {
    if (state is PlaylistLoading) {
      return Container(
        alignment: Alignment.center,
        height: 100.h,
        child: const CircularProgressIndicator(
          color: AppColors.primary,
        ),
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
                  onTap: () {},
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
                          // MaterialPageRoute(
                          //   // fullscreenDialog: true,
                          //   builder: (context) => PlaylistPage(
                          //     playlistEntity: playlist,
                          //     userEntity: isCurrentUser ? UserEntity(email: email, fullName: fullName, userId: userId) : widget.userEntity.userEntity,
                          //   ),
                          // ),
                          MaterialPageRoute(
                            builder: (context) => PlaylistPage(
                              playlistEntity: playlist, // Pass the playlist object
                              userEntity: isCurrentUser ? UserEntity(email: email, fullName: fullName, userId: userId) : widget.userEntity.userEntity,
                              onPlaylistDeleted: () {

                                // Refresh PlaylistView
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
        if (state is FavoriteSongLoaded) {
          return MaterialButton(
            splashColor: Colors.transparent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyFavorite(
                    length: state.songs.length,
                    userEntity: isCurrentUser ? UserEntity(email: email, fullName: fullName, userId: userId) : widget.userEntity.userEntity,
                  ),
                ),
              );
            },
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
            child: Row(
              children: [
                Container(
                  // padding: EdgeInsets.all(1.sp),
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
                    Text(
                      'My Favorites',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      'Playlist | ${state.songs.length} songs',
                      style: TextStyle(fontSize: 10.sp, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
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

  Future<void> createPlaylist(BuildContext context, List<SongWithFavorite> selectedSong) async {
    List<int> selectedSongsId = selectedSong.map((e) => e.song.id).toList();

    // Menampilkan Loading Dialog
    if (_createPlaylistKey.currentState!.validate()) {
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
                    "Creating playlist...",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      );

      var result2 = await context
          .read<PlaylistCubit>()
          .createPlaylist(playlistTitle: playlistController.text.toString(), playlistDesc: '', isPublic: true, selectedSongsId: selectedSongsId);

      Navigator.of(context, rootNavigator: true).pop();

      // Menampilkan hasil
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
    }
  }

  TextFormField playlistTitleField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'fill the playlist name';
        }
        return null;
      },
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
                    // Profile Image Preview BEFORE
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
                                    // context.read<AvatarCubit>().pickImage();
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
                    // Profile Image Preview AFTER
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

                // if (state is AvatarUploading)
                //   const Padding(
                //     padding: EdgeInsets.all(20.0),
                //     child: CircularProgressIndicator(),
                //   ),

                // Error Message Display
                if (state is AvatarError)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(state.message, style: const TextStyle(color: Colors.red)),
                  ),

                SizedBox(
                  height: 10.h,
                ),
                // Edit Profile textfield
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
                          customSnackBar(isSuccess: false, text: r, context: context);
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
              )),
      ],
      child: BlocBuilder<FollowerCubit, FollowerState>(
        builder: (context, state) {
          if (state is FollowerLoading) {
            return Container(
              alignment: Alignment.center,
              height: 100.h,
              child: const CircularProgressIndicator(
                color: AppColors.darkGrey,
              ),
            );
          }
          if (state is FollowerFailure) {
            return Container(
              alignment: Alignment.center,
              height: 100.h,
              child: const Text('Failed to get follower statistic'),
            );
          }

          if (state is FollowerLoaded) {
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
                          child: SvgPicture.asset(
                            AppVectors.profilePattern,
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          isCurrentUser
                              ? currentUserProfileImage()
                              : SizedBox(
                                  height: 92.sp,
                                  width: 92.sp,
                                  child: ClipOval(
                                    child: widget.userEntity.userEntity.avatarUrl != ''
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
                          SizedBox(
                            height: isCurrentUser ? 10.h : 0,
                          ),
                          isCurrentUser
                              ? Text(
                                  email,
                                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w300, letterSpacing: 0.3),
                                )
                              : const SizedBox.shrink(),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            isCurrentUser ? fullName : widget.userEntity.userEntity.fullName!,
                            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, letterSpacing: 0.3),
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          !isCurrentUser ? FollowUserButton(user: widget.userEntity) : const SizedBox.shrink(),
                          SizedBox(
                            height: 4.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FollowCount(
                                count: state.followEntity.following!.count,
                                title: 'Following',
                              ),
                              FollowCount(
                                count: state.followEntity.follower!.count,
                                title: 'Followers',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          )
                        ],
                      ),
                    ),
                  ],
                ));
          }
          return Container();
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
              decoration: BoxDecoration(color: Colors.grey.shade700, shape: BoxShape.circle),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 65.sp,
                ),
              ),
            ),
            state is AvatarLoaded || state is AvatarInitial
                ? Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      state is AvatarLoaded
                          ? CircleAvatar(radius: 46.sp, backgroundImage: NetworkImage(state.imageUrl) // Ini sekarang akan selalu update,
                              )
                          : const SizedBox(),
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
                          // height: 20.sp,
                          child: Icon(
                            Icons.edit,
                            size: 15.sp,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  )
                : state is AvatarPicked
                    ? ClipOval(
                        child: state.imageUrl,
                      )
                    : const SizedBox.shrink()
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
}
