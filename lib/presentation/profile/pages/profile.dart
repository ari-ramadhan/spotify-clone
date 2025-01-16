import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget_selectable.dart';
import 'package:spotify_clone/core/configs/constants/app_methods.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/data/repository/auth/auth_service.dart';
import 'package:spotify_clone/domain/entity/playlist/playlist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/intro/pages/get_started.dart';
import 'package:spotify_clone/presentation/playlist/pages/playlist.dart';
import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_state.dart';
import 'package:spotify_clone/presentation/profile/bloc/followed_artists.dart/followed_song_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/followed_artists.dart/followed_song_state.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_state.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_info/profile_info_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_info/profile_info_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  TextEditingController playlistController = TextEditingController();

  List<SongWithFavorite> selectedSongs = [];

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
            appBar: BasicAppbar(
              backgroundColor: context.isDarkMode ? const Color(0xff2c2b2b) : Colors.white,
              title: Text(
                'Profile',
                style: TextStyle(color: context.isDarkMode ? Colors.white : Colors.black),
              ),
              action: IconButton(
                onPressed: () {
                  showMenuOptions(context);
                },
                icon: Icon(
                  Icons.more_vert,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _profileInfo(context),
                      SizedBox(
                        height: 0.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0).copyWith(right: 5.w),
                        // child: playlistsList(),
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => PlaylistCubit()..getCurrentuserPlaylist(),
                            ),
                            BlocProvider(
                              create: (context) => FavoriteSongCubit()..getFavoriteSongs(),
                            ),
                            BlocProvider(
                              create: (context) => FollowedArtistsCubit()..getFollowedArtists(),
                            ),
                          ],
                          child: BlocBuilder<PlaylistCubit, PlaylistState>(
                            builder: (context, state) => Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h).copyWith(bottom: 0),
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
                                      MaterialButton(
                                        onPressed: () async {
                                          // showAddPlaylistModal(context, '');
                                          blurryDialog(
                                              context: context,
                                              horizontalPadding: 10,
                                              dialogTitle: 'Create a playlist',
                                              content: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                                                    child: playlistTitleField(),
                                                  ),
                                                  SizedBox(
                                                    height: 23.h,
                                                  ),
                                                  Wrap(
                                                    direction: Axis.horizontal,
                                                    children: selectedSongs.map(
                                                      (e) {
                                                        return Container(
                                                          child: Row(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 18.sp,
                                                                backgroundImage: CachedNetworkImageProvider(
                                                                    '${AppURLs.supabaseCoverStorage}${e.song.artist} - ${e.song.title}.jpg'),
                                                              ),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              Text(e.song.title)
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
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
                                                      create: (context) => FavoriteSongCubit()..getFavoriteSongs(),
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
                                                            return Container(
                                                                alignment: Alignment.center, height: 100, child: const Text('Failed to fetch songs'));
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
                                                                  // SizedBox(
                                                                  //   height: 10.h,
                                                                  // ),
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
                                                                          print(
                                                                              'Current Selected Songs: ${selectedSongs.map((s) => s.song.id).toList()}');
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
                                      ),
                                    ],
                                  ),
                                ),
                                // Favorite page button
                                BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
                                  builder: (context, state) {
                                    if (state is FavoriteSongLoaded) {
                                      return MaterialButton(
                                        splashColor: Colors.transparent,
                                        onPressed: () {},
                                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
                                ),
                                // list of playlist
                                (() {
                                  if (state is PlaylistLoaded) {
                                    return state.playlistModel.isNotEmpty
                                        ? Column(
                                            children: [
                                              ElementTitleWidget(
                                                elementTitle: 'Playlists',
                                                limit: 4,
                                                list: state.playlistModel,
                                              ),
                                              ListView.builder(
                                                physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  var playlist = state.playlistModel[index];

                                                  return PlaylistTileWidget(playlist: playlist);
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
                                }()),
                                BlocBuilder<FollowedArtistsCubit, FollowedArtistsState>(
                                  builder: (context, state) {
                                    if (state is FollowedArtistsLoaded) {
                                      return Column(
                                        children: [
                                          ElementTitleWidget(elementTitle: 'Artists followed', list: state.artists, limit: 4),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: state.artists.length,
                                            itemBuilder: (context, index) {
                                              var artist = state.artists[index].artist;

                                              return MaterialButton(
                                                onPressed: () {},
                                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 40.h,
                                                      width: 44.w,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                            '${AppURLs.supabaseArtistStorage}${artist.name!.toLowerCase()}.jpg',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 12.w,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          artist.name!,
                                                          style: TextStyle(fontSize: 14.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 3.h,
                                                        ),
                                                        Text(
                                                          'Artist',
                                                          style: TextStyle(fontSize: 10.sp, color: Colors.white70),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      );
                                    }
                                    return Container();
                                  },
                                )
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

  Future<dynamic> showMenuOptions(BuildContext context) {
    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1, 60.h, 0, 0),
      menuPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12.h,
        ),
      ),
      items: [
        PopupMenuItem(
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              AuthService authService = AuthService();
              await supabase.auth.signOut();
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

  // Widget playlistsList() {
  //   return BlocProvider(
  //     create: (_) => PlaylistCubit()..getCurrentuserPlaylist(),
  //     child: BlocBuilder<PlaylistCubit, PlaylistState>(
  //       builder: (context, state) {
  //         if (state is PlaylistLoading) {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }

  //         if (state is PlaylistFailure) {
  //           return const Center(
  //             child: Text('Please try again'),
  //           );
  //         }

  //         if (state is PlaylistLoaded) {
  //           return ListView.separated(
  //             physics: const NeverScrollableScrollPhysics(),
  //             shrinkWrap: true,
  //             itemBuilder: (context, index) {
  //               var playlist = state.playlistModel[index];

  //               return GestureDetector(
  //                 onTap: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => PlaylistPage(
  //                           playlistEntity: playlist,
  //                         ),
  //                       ));
  //                 },
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Container(
  //                           height: 35.h,
  //                           width: 38.w,
  //                           decoration: BoxDecoration(
  //                               gradient: const RadialGradient(
  //                                 colors: [Color(0xff424648), Color(0xff1c2022)],
  //                                 stops: [0, 1],
  //                                 center: Alignment(0.0, -0.4),
  //                               ),
  //                               borderRadius: BorderRadius.all(Radius.circular(6.sp))),
  //                           child: Padding(
  //                             padding: EdgeInsets.all(8.sp),
  //                             child: SvgPicture.asset(
  //                               AppVectors.playlist,
  //                               color: Colors.white,
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 12.w,
  //                         ),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               playlist.name!,
  //                               style: TextStyle(fontSize: 14.sp),
  //                             ),
  //                             SizedBox(
  //                               height: 3.h,
  //                             ),
  //                             Text(
  //                               playlist.songCount == 0 ? 'Playlist | empty song' : 'Playlist | ${playlist.songCount} songs',
  //                               style: TextStyle(fontSize: 10.sp, color: Colors.white70),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     IconButton(
  //                       onPressed: () {},
  //                       splashRadius: 22.sp,
  //                       icon: Icon(
  //                         Icons.add_circle_outline_rounded,
  //                         size: 26.sp,
  //                         color: AppColors.primary,
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               );
  //             },
  //             separatorBuilder: (context, index) {
  //               return SizedBox(
  //                 height: 10.h,
  //               );
  //             },
  //             itemCount: state.playlistModel.length,
  //           );
  //         }

  //         return Container();
  //       },
  //     ),
  //   );
  // }

  // Future<dynamic> showAddPlaylistModal(BuildContext context, String songId) {
  //   List<SongWithFavorite> selectedSongs = [];

  //   return showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     useSafeArea: true,
  //     isDismissible: true,
  //     // backgroundColor: AppColors.medDarkBackground,
  //     backgroundColor: const Color(0xff192a56),
  //     constraints: BoxConstraints(minHeight: ScreenUtil().screenHeight * 0.8),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(
  //           18.sp,
  //         ),
  //         topRight: Radius.circular(
  //           18.sp,
  //         ),
  //       ),
  //     ),
  //     builder: (BuildContext context) {
  //       // return DraggableScrollableSheet(
  //       //   expand: false,
  //       //   builder: (BuildContext context, ScrollController scrollController) {
  //       return SingleChildScrollView(
  //         child: Container(
  //           padding: const EdgeInsets.all(8),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.max,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   const CloseButton(),
  //                   Text(
  //                     'Add a Playlist',
  //                     style: TextStyle(
  //                       fontSize: 20.sp,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 30.w,
  //                   )
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 23.h,
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 40.w),
  //                 child: playlistTitleField(),
  //               ),
  //               SizedBox(
  //                 height: 23.h,
  //               ),
  //               Wrap(
  //                 direction: Axis.horizontal,
  //                 children: selectedSongs.map(
  //                   (e) {
  //                     return Container(
  //                       child: Row(
  //                         children: [
  //                           CircleAvatar(
  //                             radius: 18.sp,
  //                             backgroundImage: CachedNetworkImageProvider('${AppURLs.supabaseCoverStorage}${e.song.artist} - ${e.song.title}.jpg'),
  //                           ),
  //                           SizedBox(
  //                             width: 5.w,
  //                           ),
  //                           Text(e.song.title)
  //                         ],
  //                       ),
  //                     );
  //                   },
  //                 ).toList(),
  //               ),
  //               MaterialButton(
  //                 onPressed: () async {
  //                   await createPlaylist(context, selectedSongs);
  //                 },
  //                 focusColor: Colors.black45,
  //                 // highlightColor: Colors.black12,
  //                 splashColor: AppColors.primary,
  //                 highlightColor: AppColors.primary,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(
  //                     15.sp,
  //                   ),
  //                   side: BorderSide(
  //                     color: Colors.grey.shade200,
  //                   ),
  //                 ),
  //                 child: Text(
  //                   'Create playlista',
  //                   style: TextStyle(
  //                     fontSize: 14.sp,
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 20.h,
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 6.w),
  //                 child: BlocProvider(
  //                   create: (context) => FavoriteSongCubit()..getFavoriteSongs(),
  //                   child: BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
  //                     builder: (context, state) {
  //                       if (state is FavoriteSongLoading) {
  //                         return Container(
  //                           alignment: Alignment.center,
  //                           height: 100,
  //                           child: const CircularProgressIndicator(
  //                             color: AppColors.primary,
  //                           ),
  //                         );
  //                       }
  //                       if (state is FavoriteSongFailure) {
  //                         return Container(alignment: Alignment.center, height: 100, child: const Text('Failed to fetch songs'));
  //                       }
  //                       if (state is FavoriteSongLoaded) {
  //                         return Container(
  //                           alignment: Alignment.center,
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 'From your favorites',
  //                                 style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
  //                               ),
  //                               SizedBox(
  //                                 height: 10.h,
  //                               ),
  //                               ListView.separated(
  //                                 physics: const NeverScrollableScrollPhysics(),
  //                                 shrinkWrap: true,
  //                                 itemBuilder: (context, index) {
  //                                   var songModel = state.songs[index];

  //                                   return SongTileWidgetSelectable(
  //                                     songEntity: songModel,
  //                                     onSelectionChanged: (selectedSong) {
  //                                       setState(() {
  //                                         if (selectedSong != null) {
  //                                           // Tambahkan jika tidak ada di daftar
  //                                           if (!selectedSongs.contains(selectedSong)) {
  //                                             selectedSongs.add(selectedSong);
  //                                             print('Added: ${selectedSong.song.title}');
  //                                           }
  //                                         } else {
  //                                           // Hapus berdasarkan id jika ada
  //                                           selectedSongs.removeWhere((song) => song.song.id == songModel.song.id);
  //                                           print('Removed: ${songModel.song.title}');
  //                                         }
  //                                       });

  //                                       // Debugging: Tampilkan semua ID lagu yang dipilih
  //                                       print('Current Selected Songs: ${selectedSongs.map((s) => s.song.id).toList()}');
  //                                     },

  //                                     // isSelected: true,
  //                                   );
  //                                 },
  //                                 separatorBuilder: (context, index) {
  //                                   return SizedBox(
  //                                     height: 10.h,
  //                                   );
  //                                 },
  //                                 itemCount: state.songs.length,
  //                               ),
  //                             ],
  //                           ),
  //                         );
  //                       }
  //                       return Container();
  //                     },
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> createPlaylist(BuildContext context, List<SongWithFavorite> selectedSong) async {
    List<int> selectedSongsId = [];
    for (var song in selectedSong) {
      selectedSongsId.add(song.song.id);
    }

    // Menampilkan Loading Dialog
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
        var errorSnackbar = SnackBar(
          content: Text(
            l,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
        );
        ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
        playlistController.clear();
        Navigator.pop(context);
      },
      (r) {
        var successSnackbar = SnackBar(
          content: Text(
            r,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
        playlistController.clear();
        Navigator.pop(context);
      },
    );
  }

  TextField playlistTitleField() {
    return TextField(
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

  Widget _profileInfo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode ? const Color(0xff2c2b2b) : Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60.w),
          bottomRight: Radius.circular(60.w),
        ),
      ),
      height: ScreenUtil().screenHeight / 3.4,
      width: double.infinity,
      child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
        builder: (context, state) {
          if (state is ProfileInfoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProfileInfoLoaded) {
            return Stack(
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
                      Container(
                        height: 80.w,
                        width: 80.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(AppImages.defaultProfile),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        state.userEntity.email!,
                        style: TextStyle(
                            fontSize: 13.sp,
                            // color: const Color.fromARGB(255, 204, 204, 204),
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Text(
                        state.userEntity.fullName!,
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, letterSpacing: 0.3),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          if (state is ProfileInfoFailure) {
            return const Text('Please try again!');
          }

          return Container();
        },
      ),
    );
  }

  Widget _favoriteSongs(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: BlocProvider(
        lazy: false,
        create: (context) => FavoriteSongCubit()..getFavoriteSongs(),
        child: BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
          builder: (context, state) {
            if (state is FavoriteSongLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is FavoriteSongFailure) {
              return const Center(
                child: Text('Please try again'),
              );
            }

            if (state is FavoriteSongLoaded) {
              return state.songs.length < 1
                  ? Container(
                      height: ScreenUtil().screenHeight / 4,
                      alignment: Alignment.center,
                      child: const Text(
                        'You have no songs added to favorite list',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var favoriteSong = state.songs[index];
                        return SongTileWidget(
                          songList: state.songs,
                          index: index,
                          onSelectionChanged: (isSelected) => setState(() => isSelected = isSelected),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10.h,
                        );
                      },
                      itemCount: state.songs.length);
            }

            return Container();
          },
        ),
      ),
    );
  }
}

class ElementTitleWidget extends StatelessWidget {
  final String elementTitle;
  final List<dynamic> list;
  final double limit;
  const ElementTitleWidget({
    required this.elementTitle,
    required this.list,
    required this.limit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      padding: EdgeInsets.symmetric(horizontal: 10.w).copyWith(right: 6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                elementTitle,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.arrow_drop_down_rounded,
                color: AppColors.primary,
              )
            ],
          ),
          list.length >= limit
              ? Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}

class PlaylistTileWidget extends StatelessWidget {
  const PlaylistTileWidget({
    super.key,
    required this.playlist,
  });

  final PlaylistEntity playlist;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // fullscreenDialog: true,
            builder: (context) => PlaylistPage(
              playlistEntity: playlist,
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40.h,
                width: 44.w,
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
                child: Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: SvgPicture.asset(
                    AppVectors.playlist,
                    color: Colors.white,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name!,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    playlist.songCount == 0 ? 'Playlist | empty song' : 'Playlist | ${playlist.songCount} songs',
                    style: TextStyle(fontSize: 10.sp, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
