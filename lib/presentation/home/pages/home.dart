import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
  // List<Map<String, dynamic>> _items = [];

  // Future fetchData() async {
  //   final response = await supabase
  //       .from('songs')
  //       .select('*');

  //   setState(() {
  //     _items = response;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // fetchData();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBackButton: true,
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: carousel(),
            ),
            _tabs(),
            SizedBox(
              height: 270,
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
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(
                      e['card'],
                      height: 135,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: e['artist'] == AppImages.homeArtist3 ? 0 : 8,
                    top: e['artist'] == AppImages.homeArtist3 ? 20 : 0,
                    right: 10,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: SizedBox(
                        height:
                            e['artist'] == AppImages.homeArtist3 ? 140 : 168,
                        child: Image.asset(
                          e['artist'],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ).toList(),
        options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            viewportFraction: 1,
            height: 170,
            autoPlayAnimationDuration: const Duration(milliseconds: 1200)));
  }

  // Widget _homeTopCard() {
  //   return Center(
  //     child: SizedBox(
  //       height: 170,

  //       // width: MediaQuery.of(context).size.width / 0.3,

  //       // width: double.infinity,
  //       child: Stack(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(top: 30),
  //             child: Align(
  //               alignment: Alignment.topCenter,
  //               child: SvgPicture.asset(
  //                 AppVectors.homeTopCard,
  //                 height: 135,
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(bottom: 5, right: 20),
  //             child: Align(
  //               alignment: Alignment.topRight,
  //               child: Padding(
  //                 padding: const EdgeInsets.only(right: 0),
  //                 child: SizedBox(
  //                   // height: 180,
  //                   child: Image.asset(
  //                     AppImages.homeArtist,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _tabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: AppColors.primary,
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 30),
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      padding: EdgeInsets.symmetric(
          vertical: 24, horizontal: _tabController.index == 0 ? 10 : 16),
      tabs: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ).copyWith(left: 0),
          child: const Text(
            'News',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            'Videos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 6,
          ),
          child: Text(
            'Artist',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            'Podcast',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
