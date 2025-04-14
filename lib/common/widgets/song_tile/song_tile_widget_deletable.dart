import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

class SongTileWidgetDeletable extends StatefulWidget {
  final SongWithFavorite songEntity;
  final GestureTapCallback deleteButtonEvent;
  final Function(SongWithFavorite?) onSelectionChanged;

  const SongTileWidgetDeletable({
    super.key,
    required this.songEntity,
    required this.onSelectionChanged,
    required this.deleteButtonEvent,
  });

  @override
  State<SongTileWidgetDeletable> createState() =>
      _SongTileWidgetDeletableState();
}

class _SongTileWidgetDeletableState extends State<SongTileWidgetDeletable> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white;

    return InkWell(
        child: IntrinsicHeight(
      // Tambahkan IntrinsicHeight di sini
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment
            .stretch, // Ubah crossAxisAlignment menjadi stretch
        children: [
          Expanded(
            // Bungkus bagian kiri dengan Expanded
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                color: AppColors.darkBackground,
                border: Border.all(color: Colors.white),
              ),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Row(
                children: [
                  Container(
                    width: 31.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.sp),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            '${AppURLs.supabaseCoverStorage}${widget.songEntity.song.artist} - ${widget.songEntity.song.title}.jpg'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 7.w,
                  ),
                  Expanded(
                    // Bungkus Column dengan Expanded agar teks tidak overflow
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Agar teks berada di tengah vertikal
                      children: [
                        Text(
                          widget.songEntity.song.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: textColor,
                              fontSize: 12.sp),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
              color: AppColors.darkBackground,
              shape: BoxShape.circle
            ),
            child: GestureDetector(
              onTap: widget.deleteButtonEvent,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(6.sp),
                child: Icon(
                  Icons.remove,
                  color: Colors.red,
                  size: 16.sp,
                ),
              ),
            ),
          ),
          // SizedBox(
          //   width: 7.w,
          // )
        ],
      ),
    ));
  }
}
