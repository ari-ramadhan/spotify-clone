import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

class SongTileWidgetSelectable extends StatefulWidget {
  final SongWithFavorite songEntity;
  final bool isSelected;
  final Function(SongWithFavorite?) onSelectionChanged;

  const SongTileWidgetSelectable(
      {super.key,
      required this.songEntity,
      this.isSelected = false,
      required this.onSelectionChanged});

  @override
  State<SongTileWidgetSelectable> createState() =>
      _SongTileWidgetSelectableState();
}

class _SongTileWidgetSelectableState extends State<SongTileWidgetSelectable> {
  bool isSelected = false;
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
    Color textColor = isSelected ? Colors.black : Colors.white;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        color: isSelected ? Colors.white : Colors.grey.shade700,
        border: Border.all(color: Colors.white),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: InkWell(
        onTap: () {
          toggleSelected();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 34.h,
                  width: 38.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.sp),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          '${AppURLs.supabaseCoverStorage}${widget.songEntity.song.artist} - ${widget.songEntity.song.title}.jpg'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 14.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.songEntity.song.title,
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
                      widget.songEntity.song.artist,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: textColor,
                          fontSize: 11.sp),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Text(
                  widget.songEntity.song.duration.toString(),
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  padding: EdgeInsets.all(4.sp),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 7, 5, 5),
                  ),
                  child: Icon(
                    isSelected ? Icons.check : Icons.playlist_add,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
