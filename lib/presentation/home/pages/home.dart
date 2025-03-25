import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/data/repository/auth/auth_service.dart';
import 'package:spotify_clone/presentation/album/page/artist_album.dart';
import 'package:spotify_clone/presentation/home/bloc/top_album/top_album_state.dart';
import 'package:spotify_clone/presentation/home/widgets/hot_artists.dart';
import 'package:spotify_clone/presentation/home/widgets/recent_songs.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_cubit.dart';

import '../bloc/top_album/top_album_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String fullName = '';
  String email = '';
  String userId = '';
  bool isCurrentUser = false;
  Future getUserInfo() async {
    List<String>? userInfo = await AuthService().getUserLoggedInInfo();
    if (userInfo != null) {
      setState(() {
        userId = userInfo[0];
        email = userInfo[1];
        fullName = userInfo[2];
        // isCurrentUser = userInfo[0] == widget.anotherUserId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // Updated length to 2
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SongPlayerCubit(),
      child: Scaffold(
        // backgroundColor: AppColors.black,
        appBar: BasicAppbar(
          leading: Container(
            margin: EdgeInsets.only(left: 13.w),
            child: IconButton.outlined(
              onPressed: () {},
              splashRadius: 20.sp,
              icon: const Icon(
                Icons.search_rounded,
              ),
            ),
          ),
          action: Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: IconButton(
              splashRadius: 20.sp,
              // color: Colors.green,
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          hideBackButton: true,
          title: SvgPicture.asset(
            AppVectors.logo,
            height: 34.h,
            width: 34.w,
          ),
        ),
        body: SingleChildScrollView(
          physics: const PageScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: 20.h,
              // ),
              carousel(),
              _tabs(),
              SizedBox(
                height: 170.h,
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    NewsSongs(),
                    HotArtists(),
                    // Container(
                    //   alignment: Alignment.center,
                    //   child: Text(
                    //     'Comming soon..',
                    //     style: TextStyle(fontSize: 20.sp, color: Colors.grey),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              const RecentSongs(),
              SizedBox(
                height: 27.h,
              ),

              const TopAlbum(),
              SizedBox(
                height: 30.h,
              )
            ],
          ),
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
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                    padding: EdgeInsets.only(
                        top: e['artist'] == AppImages.homeArtist3 ? 10.h : 0),
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: SizedBox(
                        height: e['artist'] == AppImages.homeArtist3
                            ? 121.h
                            : 131.h,
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
        autoPlayAnimationDuration: const Duration(
          milliseconds: 1200,
        ),
      ),
    );
  }

  Widget _tabs() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorSize: TabBarIndicatorSize.label,

          indicatorColor: Colors.transparent,
          // indicatorPadding: EdgeInsets.symmetric(horizontal: 30.w),
          labelColor: context.isDarkMode ? Colors.white : Colors.black,
          padding: EdgeInsets.symmetric(
                  vertical: 8.h,
                  horizontal: _tabController.index == 0 ? 10.sp : 16.sp)
              .copyWith(bottom: 10.h),
          tabs: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.w,
              ),
              child: Text(
                'News',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.w,
              ),
              child: Text(
                'Hot Artists',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopAlbum extends StatelessWidget {
  const TopAlbum({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopAlbumsCubit, TopAlbumsState>(
      builder: (context, state) {
        final isLoading = state is TopAlbumsLoading;
        final isLoaded = state is TopAlbumsLoaded;
        final albums = isLoaded ? (state).albums : [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                'Most Popular Album',
                style: TextStyle(
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            GridView.builder(
              itemCount: isLoading ? 6 : albums.take(6).length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18.w,
                crossAxisSpacing: 18.w,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final album = isLoaded ? albums[index].albumEnitity : null;
                final artist = isLoaded ? albums[index].artistEntity : null;

                return Skeletonizer(
                  enabled: isLoading,
                  child: GestureDetector(
                    onTap: isLoading
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ArtistAlbum(
                                  artist: artist!,
                                  album: album!,
                                ),
                              ),
                            );
                          },
                    child: Container(
                      height: 100.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.sp),
                        image: isLoading
                            ? null
                            : DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: NetworkImage(
                                  '${AppURLs.supabaseAlbumStorage}${artist?.name} - ${album?.name}.jpg',
                                ),
                              ),
                        color: isLoading
                            ? Colors.grey[800]
                            : null, // Background warna saat loading
                      ),
                      child: Stack(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.all(10.sp).copyWith(bottom: 15.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.sp),
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.grey.shade900.withOpacity(0),
                                  Colors.grey.shade900.withOpacity(0.7),
                                  Colors.grey.shade900.withOpacity(1),
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.library_music,
                                  color: AppColors.primary,
                                  size: 20.sp,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isLoading
                                          ? 'Loading...'
                                          : album?.name ?? '',
                                      style: TextStyle(
                                        fontSize:
                                            (album?.name?.length ?? 0) > 15
                                                ? 12.sp
                                                : 14.sp,
                                        color: Colors.white,
                                        height: (album?.name?.length ?? 0) > 15
                                            ? 1.2
                                            : 0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 16.sp,
                                          width: 16.sp,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: isLoading
                                                ? null
                                                : DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      '${AppURLs.supabaseArtistStorage}${artist?.name?.toLowerCase()}.jpg',
                                                    ),
                                                  ),
                                            color: isLoading
                                                ? Colors.grey[400]
                                                : null, // Warna placeholder untuk skeleton
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Text(
                                            isLoading
                                                ? 'Loading...'
                                                : artist?.name ?? '',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
