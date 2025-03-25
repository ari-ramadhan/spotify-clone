import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/home/bloc/recent_songs/recent_songs_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/recent_songs/recent_songs_state.dart';

class RecentSongs extends StatefulWidget {
  const RecentSongs({super.key});

  @override
  State<RecentSongs> createState() => _RecentSongsState();
}

class _RecentSongsState extends State<RecentSongs> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecentSongsCubit()..getRecentSongs(),
      child: BlocBuilder<RecentSongsCubit, RecentSongsState>(
        builder: (context, state) {
          if (state is RecentSongsLoading) {
            return Column(
              children: [
                Skeletonizer(
                  textBoneBorderRadius:
                      TextBoneBorderRadius(BorderRadius.circular(0)),
                  enabled: true,
                  child: Padding(
                    padding: EdgeInsets.only(left: 22.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.history,
                          size: 18.sp,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          'Recently Played',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                const SkeletonPlaylistTile(
                  isCircle: false,
                  isRounded: true,
                  extraPadding: 4,
                ),
                const SkeletonPlaylistTile(
                  isCircle: false,
                  isRounded: true,
                  extraPadding: 4,
                ),
                const SkeletonPlaylistTile(
                  isCircle: false,
                  isRounded: true,
                  extraPadding: 4,
                ),
                const SkeletonPlaylistTile(
                  isCircle: false,
                  isRounded: true,
                  extraPadding: 4,
                ),
              ],
            );
          }

          if (state is RecentSongsLoaded && state.songs.isNotEmpty) {
            return Container(
              // padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 22.w)
              //     .copyWith(right: 15.w, top: 20.h),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.history,
                              size: 18.sp,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              'Recently Played',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  _songs(state.songs)
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _songs(List<SongWithFavorite> songs) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(left: 6.w),
      shrinkWrap: true,
      itemCount: songs.length,
      itemBuilder: (context, index) {
        // bool isFav = true;

        var songTitle = songs[index].song.title;
        if (songs[index].song.title.length > 25) {
          songTitle = "${songTitle.substring(0, 22)}..";
        }

        return SongTileWidget(
          songList: songs,
          isOnHome: false,
          showAction: false,
          isShowArtist: true,
          index: index,
          onSelectionChanged: (isSelected) {},
        );
      },
    );
  }
}
