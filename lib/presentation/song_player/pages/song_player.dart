import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/data/models/artist/artist.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/presentation/artist_page/pages/artist_page.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerPage extends StatefulWidget {
  final List<SongWithFavorite> songs;
  final int startIndex;

  const SongPlayerPage({
    Key? key,
    required this.songs,
    required this.startIndex,
  }) : super(key: key);

  @override
  _SongPlayerPageState createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.startIndex;

    // Memulai pemutaran lagu baru
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playNewSong();
    });
  }

  void _playNewSong() {
    context.read<SongPlayerCubit>().setPlaylist(
          widget.songs
              .map((song) =>
                  '${AppURLs.supabaseSongStorage}${song.song.artist} - ${song.song.title}.mp3')
              .toList(),
          currentIndex,
        );
  }

  void _changeSong(int newIndex) {
    if (newIndex >= 0 && newIndex < widget.songs.length) {
      setState(() {
        currentIndex = newIndex;
      });
      // Memutar lagu baru
      _playNewSong();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Akses context di sini lebih aman
    // Misalnya untuk mengakses Navigator atau lainnya
  }

  @override
  void dispose() {
    super.dispose();
    // Hindari mengakses context di sini
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.songs[currentIndex];

    return Scaffold(
      appBar: BasicAppbar(
        onTap: () async {
          Navigator.pop(context);
        },
        title: Text(
          'Now playing',
          style: TextStyle(
              fontSize: 16.sp,
              color: context.isDarkMode ? Colors.white : Colors.black),
        ),
        action: IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_vert_rounded,
              color: context.isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
        child: Column(
          children: [
            _songCover(song),
            SizedBox(height: 20.h),
            _songDetail(song),
            SizedBox(height: 24.h),
            _songPlayer(),
          ],
        ),
      ),
    );
  }

  Widget _songPlayer() {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return const CircularProgressIndicator();
        }
        if (state is SongPlayerLoaded) {
          return Column(
            children: [
              Slider(
                thumbColor: AppColors.grey,
                activeColor: AppColors.grey,
                inactiveColor: AppColors.darkGrey,
                value: context
                    .read<SongPlayerCubit>()
                    .songPosition
                    .inSeconds
                    .toDouble(),
                min: 0,
                max: context
                    .read<SongPlayerCubit>()
                    .songDuration
                    .inSeconds
                    .toDouble(),
                onChanged: (value) {
                  context
                      .read<SongPlayerCubit>()
                      .seekTo(Duration(seconds: value.toInt()));
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(
                      context.read<SongPlayerCubit>().songPosition)),
                  Text(formatDuration(
                      context.read<SongPlayerCubit>().songDuration)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    iconSize: 36,
                    onPressed: () {
                      _changeSong(currentIndex - 1);
                    },
                  ),
                  SizedBox(
                    width: 14.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<SongPlayerCubit>().playOrPauseSong();
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: Icon(
                        context.read<SongPlayerCubit>().audioPlayer.playing
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: context.isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 14.w,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    iconSize: 36,
                    onPressed: () {
                      _changeSong(currentIndex + 1);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _songCover(SongWithFavorite song) {
    return Container(
      height: ScreenUtil().screenHeight / 2.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            '${AppURLs.supabaseCoverStorage}${song.song.artist} - ${song.song.title}.jpg',
          ),
        ),
      ),
    );
  }

  Widget _songDetail(SongWithFavorite song) {
    var title = song.song.title;
    if (title.length > 26) {
      title = "${title.substring(0, 24)}..";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.sp),
            ),
            SizedBox(height: 3.h),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ArtistPage(
                      artistId: song.song.artistId,
                    ),
                  ),
                );
              },
              child: Text(
                song.song.artist,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white60,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
        FavoriteButton(songs: song, isBigger: true),
      ],
    );
  }
}

String formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

// class SongPlayerPage extends StatelessWidget {
//   final List<SongWithFavorite> songList;
//   final int index;
//   SongPlayerPage({
//     super.key,
//     required this.songList,
//     required this.index,
//   });

//   bool showNavBar = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BasicAppbar(
//         onTap: () async {
//           Navigator.pop(context);
//         },
//         title: Text(
//           'Now playing',
//           style: TextStyle(
//               fontSize: 16.sp,
//               color: context.isDarkMode ? Colors.white : Colors.black),
//         ),
//         action: IconButton(
//           onPressed: () {},
//           icon: Icon(Icons.more_vert_rounded,
//               color: context.isDarkMode ? Colors.white : Colors.black),
//         ),
//       ),
//       body: BlocProvider(
//         create: (context) => SongPlayerCubit()
//           ..loadSong(
//               '${AppURLs.supabaseSongStorage}${songList[index].song.artist} - ${songList[index].song.title}.mp3'),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
//           child: Column(
//             children: [
//               _songCover(context),
//               SizedBox(
//                 height: 20.h,
//               ),
//               _songDetail(context),
//               SizedBox(
//                 height: 24.h,
//               ),
//               _songPlayer(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _songCover(BuildContext context) {
//     return Container(
//       height: ScreenUtil().screenHeight / 2.4,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           image: DecorationImage(
//             fit: BoxFit.cover,
//             image: NetworkImage(
//               '${AppURLs.supabaseCoverStorage}${songList[index].song.artist} - ${songList[index].song.title}.jpg',
//             ),
//           )),
//     );
//   }

//   Widget _songDetail(BuildContext context) {
//     var title = songList[index].song.title;
//     if (songList[index].song.title.length > 26) {
//       title = "${title.substring(0, 24)}..";
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.sp),
//             ),
//             SizedBox(
//               height: 3.h,
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => ArtistPage(
//                       artistId: songList[index].song.artistId,
//                     ),
//                   ),
//                 );
//               },
//               child: Text(
//                 songList[index].song.artist,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white60,
//                   // letterSpacing: 0.6,
//                   fontSize: 15.sp,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         FavoriteButton(
//           songs: songList[index],
//           isBigger: true,
//         )
//       ],
//     );
//   }

  // Widget _songPlayer(BuildContext context) {
  //   return BlocBuilder<SongPlayerCubit, SongPlayerState>(
  //     builder: (context, state) {
  //       if (state is SongPlayerLoading) {
  //         return const CircularProgressIndicator();
  //       }
  //       if (state is SongPlayerLoaded) {
  //         return Column(
  //           children: [
  //             Slider(
  //               thumbColor: AppColors.grey,
  //               activeColor: AppColors.grey,
  //               inactiveColor: AppColors.darkGrey,
  //               value: context
  //                   .read<SongPlayerCubit>()
  //                   .songPosition
  //                   .inSeconds
  //                   .toDouble(),
  //               min: 0,
  //               max: context
  //                   .read<SongPlayerCubit>()
  //                   .songDuration
  //                   .inSeconds
  //                   .toDouble(),
  //               onChanged: (value) {},
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   formatDuration(
  //                       context.read<SongPlayerCubit>().songPosition),
  //                 ),
  //                 Text(
  //                   formatDuration(
  //                       context.read<SongPlayerCubit>().songDuration),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 context.read<SongPlayerCubit>().playOrPauseSong();
  //               },
  //               child: Container(
  //                 height: 60,
  //                 width: 60,
  //                 decoration: const BoxDecoration(
  //                     shape: BoxShape.circle, color: AppColors.primary),
  //                 child: Icon(
  //                   context.read<SongPlayerCubit>().audioPlayer.playing
  //                       ? Icons.pause
  //                       : Icons.play_arrow,
  //                   color: context.isDarkMode ? Colors.black : Colors.white,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 30,
  //             ),
  //           ],
  //         );
  //       }

  //       return Container();
  //     },
  //   );
  // }
