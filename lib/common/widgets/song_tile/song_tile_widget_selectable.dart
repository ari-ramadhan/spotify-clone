import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

class SongTileWidgetSelectable extends StatefulWidget {
  final SongWithFavorite songEntity;
  final bool isSelected;
  final bool isLoading;
  final Function(SongWithFavorite?) onSelectionChanged;

  const SongTileWidgetSelectable(
      {super.key,
      required this.songEntity,
      this.isSelected = false,
      required this.onSelectionChanged,
      this.isLoading = false});

  @override
  State<SongTileWidgetSelectable> createState() =>
      _SongTileWidgetSelectableState();
}

class _SongTileWidgetSelectableState extends State<SongTileWidgetSelectable> {
  bool isSelected = false;
  SongWithFavorite emptySong = SongWithFavorite(
      SongEntity(
          title: 'data data data',
          id: 1,
          artist: 'data data',
          duration: 1,
          artistId: 1,
          releaseDate: 'data data',
          playCount: 0),
      false);

  @override
  void initState() {
    super.initState();
    isSelected = isSelected;
  }

  void toggleSelected() {
    setState(() {
      isSelected = !isSelected;
      widget.onSelectionChanged(isSelected ? widget.songEntity : null);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        color: isSelected ? AppColors.darkGrey : AppColors.darkBackground,
        border: Border.all(color: Colors.white),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: InkWell(
        onTap: () {
          widget.isLoading ? null : toggleSelected();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 28.h,
                  width: 31.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.sp),
                    image: widget.isLoading
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(widget.isLoading
                                ? emptySong.song.title
                                : '${AppURLs.supabaseCoverStorage}${widget.songEntity.song.artist} - ${widget.songEntity.song.title}.jpg'),
                          ),
                  ),
                ),
                SizedBox(
                  width: 7.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180.w,
                      child: Text(
                        widget.isLoading
                            ? emptySong.song.title
                            : widget.songEntity.song.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: textColor,
                            fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      widget.isLoading
                          ? emptySong.song.artist
                          : widget.songEntity.song.artist,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: textColor,
                          fontSize: 9.sp),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Text(
                  widget.isLoading
                      ? emptySong.song.duration.toString()
                      : widget.songEntity.song.duration.toString(),
                  style: TextStyle(color: textColor, fontSize: 11.sp),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  padding: EdgeInsets.all(2.sp),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.darkBackground),
                  child: Icon(
                    isSelected ? Icons.check : Icons.playlist_add,
                    color: Colors.white,
                    size: 11.sp,
                  ),
                ),
                SizedBox(
                  width: 7.w,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
