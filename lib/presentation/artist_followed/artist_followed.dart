import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/presentation/profile/bloc/followed_artists.dart/followed_song_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/followed_artists.dart/followed_song_state.dart';

class ArtistFollowed extends StatelessWidget {
  const ArtistFollowed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        title: Text('Artists Followed'),
      ),
      body: Column(
        children: [
          BlocProvider(
            create: (context) => FollowedArtistsCubit(),
            child: BlocBuilder<FollowedArtistsCubit, FollowedArtistsState>(
              builder: (context, state) {
                if (state is FollowedArtistsLoading) {
                  return Container(
                    height: 200.h,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }
                if (state is FollowedArtistsLoaded) {
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 13.w),
                    shrinkWrap: true,

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.w,
                      crossAxisCount: 2,
                    ),
                    itemCount: state.artists.length,
                    itemBuilder: (context, index) {
                      var artistList = state.artists[index].artist;

                      return Container(
                        padding: EdgeInsets.all(10.sp),
                        height: 80.h,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.3,
                              ),
                              // spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(3, 3) // changes position of shadow
                              ,
                            ),
                          ],
                          color: const Color.fromARGB(115, 54, 54, 54),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: 10.sp,
                                backgroundImage: NetworkImage(
                                  '${AppURLs.supabaseArtistStorage}${artistList.name!.toLowerCase()}.jpg',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 18.h,
                            ),
                            Text(
                              artistList.name!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              'Artist',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 10.sp,
                            )
                          ],
                        ),
                      );
                    },
                  );
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
