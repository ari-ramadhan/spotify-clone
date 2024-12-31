import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/core/configs/assets/app_images.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/data/repository/auth/auth_service.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/auth/pages/sign_in.dart';
import 'package:spotify_clone/presentation/intro/pages/get_started.dart';
import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_state.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_info/profile_info_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_info/profile_info_state.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
            appBar: BasicAppbar(
              backgroundColor:
                  context.isDarkMode ? const Color(0xff2c2b2b) : Colors.white,
              title: Text(
                'Profile',
                style: TextStyle(
                    color: context.isDarkMode ? Colors.white : Colors.black),
              ),
              action: IconButton(
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(1, 60.h, 0, 0),
                    menuPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12.h,
                      ),
                    ),
                    items: [
                      PopupMenuItem(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            AuthService authService = AuthService();
                            await supabase.auth.signOut();
                            await authService.logout();

                            Future.delayed(
                              const Duration(seconds: 4),
                              () {},
                            );
                            setState(() {
                              isLoading = false;
                            });

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GetStartedPage()),
                              (Route<dynamic> route) =>
                                  false, // Menghapus semua halaman sebelumnya
                            );
                          },
                          child: const Text('Sign Out')),
                    ],
                  );
                },
                icon: Icon(
                  Icons.more_vert,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _profileInfo(context),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 18.h),
                        child: Text(
                          'YOUR FAVORITES',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: context.isDarkMode
                                  ? AppColors.grey
                                  : AppColors.darkGrey),
                        ),
                      ),
                      _favoriteSongs(context),
                      SizedBox(
                        height: 20.h,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            height: double.infinity,
            width: double.infinity,
            color: AppColors.darkBackground,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: Container(
        // alignment: Alignment.center,

        decoration: BoxDecoration(
          color: context.isDarkMode ? const Color(0xff2c2b2b) : Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60.w),
            bottomRight: Radius.circular(60.w),
          ),
        ),
        height: ScreenUtil().screenHeight / 3.4,
        width: double.infinity,
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
          builder: (context, state) {
            if (state is ProfileInfoLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ProfileInfoLoaded) {
              return Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(AppVectors.profilePattern),
                      RotatedBox(
                        quarterTurns: 90,
                        child: SvgPicture.asset(
                          AppVectors.profilePattern,
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 70.w,
                          width: 70.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(AppImages.defaultProfile),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          state.userEntity.email!,
                          style: TextStyle(
                              fontSize: 13.sp,
                              // color: const Color.fromARGB(255, 204, 204, 204),
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.3),
                        ),
                        SizedBox(
                          height: 21.h,
                        ),
                        Text(
                          state.userEntity.fullName!,
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            if (state is ProfileInfoFailure) {
              return const Text('Please try again!');
            }

            return Container(
                // child: Text('aaaaaaaaaa'),
                );
          },
        ),
      ),
    );
  }

  Widget _favoriteSongs(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: BlocProvider(
        lazy: false,
        create: (context) => FavoriteSongCubit()..getFavoriteSongs(),
        child: BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
          builder: (context, state) {
            if (state is FavoriteSongLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is FavoriteSongFailure) {
              return const Center(
                child: Text('Please try again'),
              );
            }

            if (state is FavoriteSongLoaded) {
              return state.songs.length < 1
                  ? Container(
                      height: ScreenUtil().screenHeight / 4,
                      alignment: Alignment.center,
                      child: const Text(
                        'You have no songs added to favorite list',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var favoriteSong = state.songs[index];

                        print(state.songs);

                        return favoriteSongTile(context, favoriteSong);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10.h,
                        );
                      },
                      itemCount: state.songs.length);
            }

            return Container();
          },
        ),
      ),
    );
  }

  GestureDetector favoriteSongTile(
      BuildContext context, SongEntity favoriteSong) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SongPlayerPage(
                  songEntity: SongWithFavorite(favoriteSong, true),
                )));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 46.h,
                width: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            '${AppURLs.supabaseCoverStorage}${favoriteSong.artist} - ${favoriteSong.title}.jpg'))),
              ),
              SizedBox(
                width: 18.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: ScreenUtil().screenWidth / 2.4,
                    child: Text(
                      favoriteSong.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    favoriteSong.artist,
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 11.sp),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              Text(
                favoriteSong.duration.toString().replaceAll('.', ':'),
                style: TextStyle(fontSize: 12.5.sp),
              ),
              SizedBox(
                width: 10.w,
              ),
              IconButton(
                  splashRadius: 20.w,
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz))
              // FavoriteButton(songs: favoriteSong)
            ],
          )
        ],
      ),
    );
  }
}
