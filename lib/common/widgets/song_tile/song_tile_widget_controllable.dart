import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

//Song tile widget that can listen to value notifier, so it changing UI when it has a change occur to the related to item list
//used for the playlist page inside 'Add song to playlist' section, it tracks the change of the existance status of the corresponding item when other widget gives a changes to it

class SongTileWidgetControllable extends StatefulWidget {
  final SongWithFavorite songEntity;
  final ValueNotifier<List<SongWithFavorite>> selectedSongsNotifier;
  final bool isLoading;
  final Function(SongWithFavorite?) onSelectionChanged;

  const SongTileWidgetControllable({
    super.key,
    required this.songEntity,
    required this.selectedSongsNotifier,
    required this.onSelectionChanged,
    this.isLoading = false,
  });

  @override
  State<SongTileWidgetControllable> createState() =>
      _SongTileWidgetControllableState();
}

class _SongTileWidgetControllableState
    extends State<SongTileWidgetControllable> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.selectedSongsNotifier.value
        .any((song) => song.song.id == widget.songEntity.song.id);

    // Listen to changes in the selectedSongsNotifier
    widget.selectedSongsNotifier.addListener(_updateSelectionState);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.selectedSongsNotifier.removeListener(_updateSelectionState);
    super.dispose();
  }

  void _updateSelectionState() {
    setState(() {
      isSelected = widget.selectedSongsNotifier.value
          .any((song) => song.song.id == widget.songEntity.song.id);
    });
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
    SongWithFavorite songEntity = widget.songEntity;
    String songDuration =
        songEntity.song.duration.toString().replaceAll('.', ':');

    return Opacity(
      opacity: isSelected ? 1 : 0.8,
      child: Container(
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
                              image: CachedNetworkImageProvider(
                                  '${AppURLs.supabaseCoverStorage}${widget.songEntity.song.artist} - ${widget.songEntity.song.title}.jpg'),
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
                          widget.songEntity.song.title,
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
                        widget.songEntity.song.artist,
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
                    songDuration.length == 3
                        ? '${songDuration}0'
                        : songDuration,
                    style: TextStyle(color: textColor, fontSize: 11.sp),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    padding: EdgeInsets.all(2.sp),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.darkBackground),
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
      ),
    );
  }
}
