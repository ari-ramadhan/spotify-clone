import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/usecases/search/set_recent_search_keyword.dart';
import 'package:spotify_clone/presentation/profile/pages/export.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

class SongTileWidget extends StatefulWidget {
  final List<SongWithFavorite> songList;
  final bool isOnHome;
  final bool isShowArtist;
  final int index;
  final bool isOnSearch;
  final String searchKeyword;
  final bool showAction;
  final Function(bool) onSelectionChanged;

  const SongTileWidget(
      {super.key,
      this.isOnHome = false,
      this.showAction = true,
      required this.index,
      required this.songList,
      this.isShowArtist = false,
      this.searchKeyword = '',
      required this.onSelectionChanged,
      this.isOnSearch = false});

  @override
  State<SongTileWidget> createState() => _SongTileWidgetState();
}

class _SongTileWidgetState extends State<SongTileWidget> {
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
    isSelected = isSelected;
  }

  void toggleSelected() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    SongWithFavorite songEntity = widget.songList[widget.index];
    Color textColor = Colors.white;
    String songDuration =
        songEntity.song.duration.toString().replaceAll('.', ':');

    return InkWell(
      splashColor: Colors.transparent,
      onTap: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SongPlayerPage(
              songs: widget.songList,
              startIndex: widget.index,
            ),
          ),
        );

        if (widget.isOnSearch && widget.searchKeyword.isNotEmpty) {
          sl<SetRecentSearchKeywordUseCase>()
              .call(params: widget.searchKeyword);
        }
        // Kode sebelumnya
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 17.w, vertical: 6.h).copyWith(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                widget.isOnHome
                    ? Container(
                        height: 40.h,
                        width: 44.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.isDarkMode
                              ? AppColors.darkGrey
                              : const Color(0xffE6E6E6),
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: context.isDarkMode
                              ? const Color(0xff959595)
                              : const Color(0xff555555),
                        ),
                      )
                    : Container(
                        height: 40.h,
                        width: 44.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.sp),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                                '${AppURLs.supabaseCoverStorage}${songEntity.song.artist} - ${songEntity.song.title}.jpg'),
                          ),
                        ),
                      ),
                SizedBox(
                  width: 14.w,
                ),
                SizedBox(
                  width: widget.isOnSearch ? 230.w : 180.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        songEntity.song.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: textColor,
                            fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        widget.isOnHome || widget.isShowArtist
                            ? songEntity.song.artist
                            : NumberFormat.decimalPattern()
                                .format(songEntity.song.playCount),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11.sp),
                      ),
                    ],
                  ),
                )
              ],
            ),
            widget.isOnHome
                ? Row(
                    children: [
                      Text(
                        songDuration.length == 3
                            ? '${songDuration}0'
                            : songDuration,
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      FavoriteButton(songs: songEntity)
                    ],
                  )
                : widget.isOnSearch
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          Text(
                            songDuration.length == 3
                                ? '${songDuration}0'
                                : songDuration,
                            style: TextStyle(
                              color: textColor,
                            ),
                          ),
                          SizedBox(
                            width: widget.showAction ? 10.w : 0,
                          ),
                          widget.showAction
                              ? SizedBox(
                                  height: 21.sp,
                                  width: 21.sp,
                                  child: IconButton(
                                    onPressed: () {
                                      blurryDialogForSongTile(
                                          context: context, song: songEntity);
                                    },
                                    splashRadius: 21.sp,
                                    padding: const EdgeInsets.all(0),
                                    icon: Icon(
                                      Icons.playlist_add,
                                      size: 21.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}
