import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/domain/usecases/playlist/batch_add_to_playlist.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_state.dart';
import 'package:spotify_clone/presentation/profile/widgets/PlaylistTileWidget.dart';

void customLoadingSnackBar({required String loadingText, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          SizedBox(
            height: 20.sp,
            width: 20.sp,
            child: const CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            loadingText,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: AppColors.darkBackground,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
    ),
  );
}

void customSnackBar({required bool isSuccess, required String text, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isSuccess ? AppColors.primary : Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
    ),
  );
}

Future<Object?> blurryDialogForSongTile({
  required BuildContext context,
  required SongWithFavorite song,
}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (ctx, anim1, anim2) => Padding(
      padding: EdgeInsets.all(10.sp),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.sp), color: AppColors.medDarkBackground),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.sp),
                        topLeft: Radius.circular(
                          15.sp,
                        ),
                      ),
                      gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.black])),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Add to playlist',
                              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close_rounded),
                              splashRadius: 22.sp,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12.w, bottom: 15.h),
                        child: Row(
                          children: [
                            Container(
                              height: 40.w,
                              width: 40.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      '${AppURLs.supabaseCoverStorage}${song.song.artist} - ${song.song.title}.jpg',
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 9.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Text(
                                    '${song.song.artist}\'s',
                                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white70, fontSize: 11.2.sp),
                                  ),
                                ),
                                Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Text(
                                    song.song.title,
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, letterSpacing: 0.4),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(top: 5.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.format_list_bulleted_add,
                            size: 14.sp,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            'Select a playlist',
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    BlocProvider(
                      create: (context) => PlaylistCubit()..getCurrentuserPlaylist(''),
                      child: BlocBuilder<PlaylistCubit, PlaylistState>(
                        builder: (context, state) {
                          if (state is PlaylistLoading) {
                            return Container(
                              alignment: Alignment.center,
                              height: 100.h,
                              child: const CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          }
                          if (state is PlaylistLoaded) {
                            return state.playlistModel.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.only(top: 5.h),
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var playlist = state.playlistModel[index];

                                      return PlaylistTileWidget(
                                        playlist: playlist,
                                        onTap: () async {
                                          var result = await sl<BatchAddToPlaylistUseCase>()
                                              .call(params: BatchAddToPlaylistParams(playlistId: playlist.id!, songList: [song]));

                                          Navigator.pop(context);

                                          customLoadingSnackBar(loadingText: 'Adding the songs', context: context);

                                          result.fold(
                                            (l) {
                                              customSnackBar(isSuccess: false, text: l, context: context);
                                            },
                                            (r) {
                                              customSnackBar(isSuccess: true, text: r, context: context);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    itemCount: state.playlistModel.take(4).length,
                                  )
                                : Container(
                                    height: 100.h,
                                    margin: EdgeInsets.symmetric(horizontal: 15.w).copyWith(top: 10.h),
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(10.sp), color: const Color.fromARGB(235, 27, 27, 27)),
                                    child: const Center(child: Text('You have no playlist')),
                                  );
                          }

                          return Container();
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
    context: context,
  );
}

Future<Object?> blurryDialogForPlaylist({
  required String backgroundImage,
  required BuildContext context,
  required ArtistEntity artist,
  required List<SongWithFavorite> songList,
}) async {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (ctx, anim1, anim2) => Padding(
      padding: EdgeInsets.all(10.sp),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.sp), color: AppColors.medDarkBackground),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(backgroundImage),
                            alignment: const Alignment(0, -0.2),
                            colorFilter: ColorFilter.mode(AppColors.darkBackground.withOpacity(0.4), BlendMode.color)),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.sp),
                          topRight: Radius.circular(15.sp),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Padding(
                        padding: EdgeInsets.only(left: 12.w, bottom: 15.h),
                        child: Row(
                          children: [
                            Container(
                              height: 50.w,
                              width: 50.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    '${AppURLs.supabaseThisIsMyStorage}${artist.name!.toLowerCase()}.jpg',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 9.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'This is',
                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white70, fontSize: 11.2.sp),
                                ),
                                Text(
                                  '${artist.name}',
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, letterSpacing: 0.4),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.sp),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                    color: Colors.white,
                                    child: Text(
                                      '12 Songs',
                                      style: TextStyle(color: AppColors.darkBackground, fontSize: 8.sp, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: SizedBox(
                        height: 30.h,
                        width: 30.h,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close_rounded),
                          splashRadius: 22.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6.h,
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.format_list_bulleted_add,
                            size: 14.sp,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            'Add this to your playlist',
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    BlocProvider(
                      create: (context) => PlaylistCubit()..getCurrentuserPlaylist(''),
                      child: BlocBuilder<PlaylistCubit, PlaylistState>(
                        builder: (context, state) {
                          if (state is PlaylistLoading) {
                            return Container(
                              alignment: Alignment.center,
                              height: 100.h,
                              child: const CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          }
                          if (state is PlaylistLoaded) {
                            return ListView.builder(
                              padding: EdgeInsets.only(top: 5.h),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var playlist = state.playlistModel[index];

                                return PlaylistTileWidget(
                                  playlist: playlist,
                                  onTap: () async {
                                    var result = await sl<BatchAddToPlaylistUseCase>()
                                        .call(params: BatchAddToPlaylistParams(playlistId: playlist.id!, songList: songList));
                                    Navigator.pop(context);
                                    customLoadingSnackBar(loadingText: 'Adding the songs', context: context);

                                    result.fold(
                                      (l) {
                                        customSnackBar(isSuccess: false, text: l, context: context);
                                      },
                                      (r) {
                                        customSnackBar(isSuccess: true, text: r, context: context);
                                      },
                                    );
                                  },
                                );
                              },
                              itemCount: state.playlistModel.take(4).length,
                            );
                          }

                          return Container();
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
    context: context,
  );
}

Future<Object?> blurryDialog(
    {required BuildContext context,
    required String dialogTitle,
    required Widget content,
    required double horizontalPadding,
    required VoidCallback onClosed}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (ctx, anim1, anim2) => Padding(
      padding: EdgeInsets.all(10.sp),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            // alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w, vertical: 15.h),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.sp), color: AppColors.medDarkBackground),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21.w),
                      child: Text(
                        dialogTitle,
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                      width: 30.h,
                      child: IconButton(
                        onPressed: onClosed,
                        icon: const Icon(Icons.close_rounded),
                        splashRadius: 22.sp,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                content
              ],
            ),
          ),
        ),
      ),
    ),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
    context: context,
  );
}
