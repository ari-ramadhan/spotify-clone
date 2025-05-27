import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/presentation/profile/pages/export.dart';

class PlaylistListPage extends StatefulWidget {
  final List<PlaylistEntity> playlists;
  const PlaylistListPage({super.key, required this.playlists});

  @override
  _PlaylistListPageState createState() => _PlaylistListPageState();
}

class _PlaylistListPageState extends State<PlaylistListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlists'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add your action for adding a new playlist
            },
          ),
        ],
      ),
      body: Expanded(
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: widget.playlists.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: [
                      Container(
                        height: 90.h,
                        width: 90.h,
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
                        child: Center(
                          child: SvgPicture.asset(
                            AppVectors.playlist,
                            height: 45.w,
                            width: 45.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        widget.playlists[index].name!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
