import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/core/configs/assets/app_images.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/presentation/home/widgets/news_songs.dart';
import 'package:spotify_clone/presentation/home/widgets/playlist.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBackButton: true,
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 34.h,
          width: 34.w,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: carousel(),
            ),
            _tabs(),
            SizedBox(
              height: 203.h,
              child: TabBarView(
                controller: _tabController,
                children: [
                  const NewsSongs(),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ),
            const Playlist()
          ],
        ),
      ),
    );
  }

  Widget carousel() {
    List items = [
      {'card': AppVectors.homeTopCard1, 'artist': AppImages.homeArtist1},
      {'card': AppVectors.homeTopCard2, 'artist': AppImages.homeArtist2},
      {'card': AppVectors.homeTopCard3, 'artist': AppImages.homeArtist3},
    ];

    return CarouselSlider(
        carouselController: CarouselSliderController(),
        items: items.map(
          (e) {
            return Container(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 26.h),
                    child: Align(
                      child: SvgPicture.asset(
                        e['card'],
                        height: 135.h,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.only(top: e['artist'] == AppImages.homeArtist3 ? 10.h : 0),
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: Container(
                          height: e['artist'] == AppImages.homeArtist3 ? 121.h : 131.h,
                          child: Image.asset(
                            e['artist'],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ).toList(),
        options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            viewportFraction: 1,
            height: 135.h,
            autoPlayAnimationDuration: const Duration(milliseconds: 1200)));
  }

  Widget _tabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: AppColors.primary,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 30.w),
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      padding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: _tabController.index == 0 ? 10.sp : 16.sp).copyWith(bottom: 17.h),
      tabs: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ).copyWith(left: 0),
          child: Text(
            'News',
            style: TextStyle(fontSize: 17.2.sp, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          child: Text(
            'Videos',
            style: TextStyle(fontSize: 17.2.sp, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 6.w,
          ),
          child: Text(
            'Artist',
            style: TextStyle(fontSize: 17.2.sp, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          child: Text(
            'Podcast',
            style: TextStyle(fontSize: 17.2.sp, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
