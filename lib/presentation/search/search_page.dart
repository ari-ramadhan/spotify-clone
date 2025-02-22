import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/common/widgets/artist/artist_tile_widget.dart';
import 'package:spotify_clone/common/widgets/song_tile/song_tile_widget.dart';
import 'package:spotify_clone/common/widgets/user/user_tile_widget.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/domain/entity/album/album.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';
import 'package:spotify_clone/domain/entity/auth/user.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';
import 'package:spotify_clone/presentation/album/page/artist_album.dart';
import 'package:spotify_clone/presentation/artist_page/pages/artist_page.dart';
import 'package:spotify_clone/presentation/search/bloc/popular_song/popular_song_cubit.dart';
import 'package:spotify_clone/presentation/search/bloc/popular_song/popular_song_state.dart';
import 'package:spotify_clone/presentation/search/bloc/search_cubit.dart';
import 'package:spotify_clone/presentation/search/bloc/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isNotEmpty = false;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isShowChipSearch = false;

  final SearchCubit searchCubit = SearchCubit();
  final PopularSongCubit popularSongCubit = PopularSongCubit();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _isNotEmpty = _searchController.text.isNotEmpty;
      });
    });
    _focusNode = FocusNode();

    // Listen for focus changes
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
      } else {}
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: _isShowChipSearch
                    ? Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 18.sp,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 6.h,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.sp),
                                color: AppColors.primary,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Favorite artist\'s popular songs',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isShowChipSearch = false;
                                      });
                                    },
                                    child: SizedBox(
                                      width: 20.w,
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Container(
                              // margin: EdgeInsets.symmetric(horizontal: 17.w),
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 34, 34, 34)
                                    .withOpacity(1),
                                borderRadius: BorderRadius.circular(7.sp),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 18.sp,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      focusNode: _focusNode,
                                      controller: _searchController,
                                      onChanged: (value) {
                                        if (value.length >= 4) {
                                          searchCubit.search(value);
                                        }
                                      },
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.4),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 5.6.h),
                                        hintText: 'Find all about it..',
                                        hintStyle: TextStyle(fontSize: 14.sp),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  _isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            _searchController.clear();
                                            searchCubit.search('');
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 18.sp,
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            minWidth: 40.w,
                            child: const Text('Cancel'),
                          )
                        ],
                      ),
              ),
              SizedBox(
                height: 15.h,
              ),
              _isFocused &&
                      _searchController.value.text.isEmpty &&
                      !_isShowChipSearch
                  ? ListTile(
                      onTap: () {
                        if (!_isShowChipSearch) {
                          popularSongCubit.getPopularSongFromFavArtists();
                        }

                        setState(() {
                          _isShowChipSearch = !_isShowChipSearch;
                        });
                      },
                      leading: const Icon(
                        Icons.star_border_purple500_outlined,
                        color: Colors.white70,
                      ),
                      trailing: const Icon(Icons.saved_search_sharp),
                      title: const Text(
                        'Songs from your Favorite Artists',
                      ),
                      subtitle:
                          const Text('most popular songs based on your taste'),
                    )
                  : _isShowChipSearch
                      ? BlocBuilder<PopularSongCubit, PopularSongState>(
                          bloc: popularSongCubit,
                          builder: (context, state) {
                            if (state is PopularSongLoading) {
                              // return Container(
                              //   child: CircularProgressIndicator(),
                              // );
                              return Column(
                                children: [
                                  const EntityTitleSearch(
                                      title: 'Various songs from',
                                      icons: Icons.music_note),
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    spacing: 8.w,
                                    runSpacing: 6.h,
                                    children: const [
                                      SkeletonPopularArtistTile(),
                                      SkeletonPopularArtistTile(),
                                      SkeletonPopularArtistTile(),
                                      SkeletonPopularArtistTile(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  const SkeletonPlaylistTile(
                                    isRounded: true,
                                    isCircle: false,
                                  ),
                                  const SkeletonPlaylistTile(
                                    isRounded: true,
                                    isCircle: false,
                                  ),
                                  const SkeletonPlaylistTile(
                                    isRounded: true,
                                    isCircle: false,
                                  ),
                                  const SkeletonPlaylistTile(
                                    isRounded: true,
                                    isCircle: false,
                                  ),
                                ],
                              );
                            }
                            if (state is PopularSongError) {
                              return SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text('Error: ${state.message}'),
                                ),
                              );
                            }
                            if (state is PopularSongLoaded) {
                              final results = state.results;
                              results.songs.map((e) => e.song).toList();
                              results.songs.shuffle();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const EntityTitleSearch(
                                      title: 'Various songs from',
                                      icons: Icons.music_note),
                                  Padding(
                                    padding: EdgeInsets.only(left: 17.w),
                                    child: Wrap(
                                      spacing: 8.w,
                                      runSpacing: 6.h,
                                      alignment: WrapAlignment.start,
                                      children: results.artists.map(
                                        (e) {
                                          return GestureDetector(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ArtistPage(artistId: e.id!),
                                              ),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(3.sp)
                                                  .copyWith(right: 10.w),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.sp),
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xff005c97),
                                                    Color(0xff363795)
                                                  ],
                                                  stops: [0, 1],
                                                  begin: Alignment.bottomRight,
                                                  end: Alignment.topLeft,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 10.sp,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                      '${AppURLs.supabaseArtistStorage}${e.name!.toLowerCase()}.jpg',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 6.w,
                                                  ),
                                                  Text(
                                                    e.name!,
                                                    style: TextStyle(
                                                      fontSize: 12.5.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: results.songs.length,
                                    itemBuilder: (context, index) {
                                      return SongTileWidget(
                                        index: index,
                                        songList: results.songs,
                                        isShowArtist: true,
                                        isOnSearch: true,
                                        onSelectionChanged: (p0) {},
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        )
                      : BlocBuilder<SearchCubit, SearchState>(
                          bloc: searchCubit,
                          builder: (context, state) {
                            if (state is SearchInitial) {
                              return SizedBox(
                                height: 100.h,
                                child: const Center(
                                  child: Text('Type something to search'),
                                ),
                              );
                            }
                            if (state is SearchLoading) {
                              return const Column(
                                children: [
                                  SkeletonPlaylistTile(
                                    isRounded: true,
                                    isCircle: false,
                                  ),
                                  SkeletonPlaylistTile(
                                    isRounded: true,
                                    isCircle: false,
                                  ),
                                  SkeletonPlaylistTile(
                                    isRounded: true,
                                    isCircle: false,
                                  ),
                                  SkeletonPlaylistTile(
                                    isRounded: true,
                                    isCircle: false,
                                  ),
                                ],
                              );
                            }
                            if (state is SearchLoaded) {
                              final results = state.results;
                              final songs =
                                  results['songs'] as List<SongWithFavorite>;
                              final artists =
                                  results['artists'] as List<ArtistEntity>;
                              final albums =
                                  results['albums'] as List<AlbumWithArtist>;
                              final users =
                                  results['users'] as List<UserWithStatus>;

                              return ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  if (songs.isNotEmpty) ...[
                                    const EntityTitleSearch(
                                      title: 'Songs',
                                      icons: Icons.music_note,
                                    ),
                                    ...songs.map((song) => SongTileWidget(
                                          index: songs.indexOf(song),
                                          songList: songs,
                                          onSelectionChanged: (p0) {},
                                          isOnSearch: true,
                                          isShowArtist: true,
                                        )),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                  ],
                                  if (artists.isNotEmpty) ...[
                                    const EntityTitleSearch(
                                      title: 'Artists',
                                      icons:
                                          Icons.star_border_purple500_outlined,
                                    ),
                                    ...artists.map((artist) => ArtistTileWidget(
                                          artist: artist,
                                          isOnSearch: true,
                                        )),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                  ],
                                  if (albums.isNotEmpty) ...[
                                    const EntityTitleSearch(
                                      title: 'Albums',
                                      icons: Icons.album,
                                    ),
                                    ...albums.map((album) {
                                      // return ListTile(title: Text(album.name!));
                                      return AlbumListWidget(
                                          album: album.albumEntity,
                                          artist: album.artistEntity);
                                    }),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                  ],
                                  if (users.isNotEmpty) ...[
                                    const EntityTitleSearch(
                                      title: 'Users',
                                      icons: Icons.person_2_rounded,
                                    ),
                                    ...users.map((user) =>
                                        UserTileWidget(userEntity: user)),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                  ],
                                ],
                              );

                              // return ListView.builder(
                              //   shrinkWrap: true,
                              //   itemCount: _isNotEmpty ? state.songs.length : 0,
                              //   itemBuilder: (context, index) {
                              //     var song = state.songs[index].song;

                              //     return SongTileWidget(
                              //       index: index,
                              //       songList: state.songs,
                              //       isShowArtist: true,
                              //       isOnSearch: true,
                              //       onSelectionChanged: (p0) {},
                              //     );
                              //   },
                              // );
                            }
                            return Container();
                          },
                        )
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonPopularArtistTile extends StatelessWidget {
  const SkeletonPopularArtistTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3.sp).copyWith(right: 10.w),
      width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Skeletonizer(
            enabled: true,
            child: CircleAvatar(
              radius: 10.sp,
              backgroundColor: Colors.grey.shade800,
            ),
          ),
          SizedBox(
            width: 6.w,
          ),
          Skeletonizer(
            enabled: true,
            child: Text(
              'data data',
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AlbumListWidget extends StatelessWidget {
  final ArtistEntity artist;
  final AlbumEntity album;
  const AlbumListWidget({
    super.key,
    required this.artist,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistAlbum(
              artist: artist,
              album: album,
            ),
          ),
        );
      },
      splashColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 5.h)
          .copyWith(right: 6.5.w),
      child: Row(
        children: [
          Container(
            height: 40.h,
            width: 44.w,
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  '${AppURLs.supabaseAlbumStorage}${artist.name} - ${album.name}.jpg',
                ),
              ),
            ),
          ),
          SizedBox(
            width: 14.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.name!,
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  children: [
                    Text(
                      'Album',
                      style: TextStyle(fontSize: 10.sp, color: Colors.white70),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Icon(
                        Icons.circle,
                        color: Colors.white70,
                        size: 5.sp,
                      ),
                    ),
                    Text(
                      artist.name!,
                      style: TextStyle(fontSize: 10.sp, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
              ),
              SizedBox(
                width: 10.w,
              )
            ],
          )
        ],
      ),
    );
  }
}

class EntityTitleSearch extends StatelessWidget {
  final String title;
  final IconData icons;
  const EntityTitleSearch({
    required this.title,
    required this.icons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 17.w,
      ).copyWith(bottom: 10.h),
      child: Row(
        children: [
          Icon(
            icons,
            size: 15.sp,
            color: Colors.white70,
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: Colors.white70)),
        ],
      ),
    );
  }
}
