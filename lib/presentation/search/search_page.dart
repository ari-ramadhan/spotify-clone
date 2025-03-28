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
import 'package:spotify_clone/presentation/profile/pages/export.dart';
import 'package:spotify_clone/presentation/search/bloc/popular_song/popular_song_cubit.dart';
import 'package:spotify_clone/presentation/search/bloc/popular_song/popular_song_state.dart';
import 'package:spotify_clone/presentation/search/bloc/recent_search/albums/recent_albums_cubit.dart';
import 'package:spotify_clone/presentation/search/bloc/recent_search/albums/recent_albums_state.dart';
import 'package:spotify_clone/presentation/search/bloc/recent_search/artist/recent_artists_cubit.dart';
import 'package:spotify_clone/presentation/search/bloc/recent_search/artist/recent_artists_state.dart';
import 'package:spotify_clone/presentation/search/bloc/recent_search/playlists/recent_playlists_cubit.dart';
import 'package:spotify_clone/presentation/search/bloc/recent_search/playlists/recent_playlists_state.dart';
import 'package:spotify_clone/presentation/search/bloc/recent_search/recent_search_cubit.dart';
import 'package:spotify_clone/presentation/search/bloc/recent_search/recent_search_state.dart';
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
              _searchBar(),
              SizedBox(
                height: 15.h,
              ),
              _isFocused &&
                      _searchController.value.text.isEmpty &&
                      !_isShowChipSearch
                  ? _initialSearchStateWidgets()
                  : _isShowChipSearch
                      ? _FavoriteArtistsSongsBuilder(
                          popularSongCubit: popularSongCubit)
                      : _SearchResultBuilder(
                          searchCubit: searchCubit,
                          searchController: _searchController)
            ],
          ),
        ),
      ),
    );
  }

  Column _initialSearchStateWidgets() {
    return Column(
      children: [
        BlocProvider(
          create: (context) => RecentSearchCubit()..getRecentSearchKeyword(),
          child: BlocBuilder<RecentSearchCubit, RecentSearchState>(
            builder: (context, state) {
              if (state is RecentSearchLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey.shade600,
                  ),
                );
              }
              if (state is RecentSearchLoaded) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.format_list_bulleted_rounded),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'Recent Searches',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.white),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () async {
                              context
                                  .read<RecentSearchCubit>()
                                  .deleteAllRecentSearchKeyword();
                            },
                            child: Text(
                              'Delete all',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.results.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var recentSearchKeyword = state.results[index];

                        return ListTile(
                          onTap: () {
                            // setState(() {
                            _searchController.text = recentSearchKeyword;
                            // });
                            searchCubit.search(recentSearchKeyword);
                          },
                          title: Text(
                            recentSearchKeyword,
                          ),
                          leading: const Icon(
                            Icons.history,
                            color: Colors.white70,
                          ),
                          titleTextStyle:
                              TextStyle(color: Colors.grey, fontSize: 13.sp),
                          trailing: SizedBox(
                            height: 25.sp,
                            width: 25.sp,
                            child: IconButton(
                              onPressed: () {
                                context
                                    .read<RecentSearchCubit>()
                                    .deleteRecentSearchKeyword(
                                        recentSearchKeyword);
                              },
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                              ),
                              splashRadius: 25.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
        ListTile(
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
            'Songs from your favorite artists',
          ),
          subtitle: const Text('most popular songs based on your taste'),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Padding(
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
                _FavoriteArtistsSongsSearchChip(
                  closeIconOntap: () {
                    setState(() {
                      _isShowChipSearch = false;
                    });
                  },
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
                      color:
                          const Color.fromARGB(255, 34, 34, 34).withOpacity(1),
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
                              setState(() {});
                            },
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.4),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 5.6.h),
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
                _isFocused
                    ? Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: MaterialButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _searchController.clear();
                            _focusNode.unfocus();
                            searchCubit.emit(SearchInitial());
                            popularSongCubit.emit(PopularSongInitial());
                          },
                          minWidth: 40.w,
                          child: const Text('Cancel'),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
    );
  }
}

class _SearchResultBuilder extends StatelessWidget {
  const _SearchResultBuilder({
    required this.searchCubit,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final SearchCubit searchCubit;
  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      bloc: searchCubit,
      builder: (context, state) {
        if (state is SearchInitial) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60.h,
                child: const Center(
                  child: Text('Type something to search'),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      AppColors.darkBackground.withOpacity(1),
                      AppColors.darkGrey,
                      AppColors.darkGrey
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_searchController.text.isEmpty) ...[
                      SizedBox(
                        height: 50.h,
                      ),
                      const _RecentArtists(),
                      SizedBox(
                        height: 20.h,
                      ),
                      const _RecentAlbums(),
                      SizedBox(
                        height: 20.h,
                      ),
                      const _RecentPlaylists(),
                      SizedBox(
                        height: 50.h,
                      ),
                    ],
                  ],
                ),
              )
            ],
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
          final songs = results['songs'] as List<SongWithFavorite>;
          final artists = results['artists'] as List<ArtistEntity>;
          final albums = results['albums'] as List<AlbumWithArtist>;
          final users = results['users'] as List<UserWithStatus>;

          if (songs.isEmpty &&
              artists.isEmpty &&
              albums.isEmpty &&
              users.isEmpty) {
            return SizedBox(
              height: 100.h,
              child: const Center(
                child: Text('Nothing related to that keyword'),
              ),
            );
          }

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
                      searchKeyword: _searchController.text,
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
                  icons: Icons.star_border_purple500_outlined,
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
                  return AlbumListWidget(
                      album: album.albumEntity, artist: album.artistEntity);
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
                ...users.map((user) => UserTileWidget(userEntity: user)),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ],
          );
        }
        return Container();
      },
    );
  }
}

class _FavoriteArtistsSongsBuilder extends StatelessWidget {
  const _FavoriteArtistsSongsBuilder({
    required this.popularSongCubit,
  });

  final PopularSongCubit popularSongCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularSongCubit, PopularSongState>(
      bloc: popularSongCubit,
      builder: (context, state) {
        if (state is PopularSongLoading) {
          // return Container(
          //   child: CircularProgressIndicator(),
          // );
          return Column(
            children: [
              const EntityTitleSearch(
                  title: 'Various songs from', icons: Icons.music_note),
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
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
                  title: 'Various songs from', icons: Icons.music_note),
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
                            builder: (context) => ArtistPage(artistId: e.id!),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(3.sp).copyWith(right: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.sp),
                            gradient: const LinearGradient(
                              colors: [Color(0xff005c97), Color(0xff363795)],
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
                                backgroundImage: CachedNetworkImageProvider(
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
                                  fontWeight: FontWeight.w500,
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
                physics: const NeverScrollableScrollPhysics(),
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
    );
  }
}

class _FavoriteArtistsSongsSearchChip extends StatefulWidget {
  final GestureTapCallback closeIconOntap;

  const _FavoriteArtistsSongsSearchChip({
    required this.closeIconOntap,
  });

  @override
  State<_FavoriteArtistsSongsSearchChip> createState() =>
      _FavoriteArtistsSongsSearchChipState();
}

class _FavoriteArtistsSongsSearchChipState
    extends State<_FavoriteArtistsSongsSearchChip> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 6.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.sp),
          color: AppColors.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              onTap: widget.closeIconOntap,
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
    );
  }
}

class _RecentArtists extends StatelessWidget {
  const _RecentArtists();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecentArtistsCubit()..getRecentArtists(),
      child: BlocBuilder<RecentArtistsCubit, RecentArtistsState>(
        builder: (context, state) {
          if (state is RecentArtistsLoading) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  4,
                  (index) {
                    return Skeletonizer(
                      enabled: true,
                      child: Container(
                        width: 80.w,
                        // height: 100.h,
                        margin: EdgeInsets.only(
                            left: index == 0 ? 15.w : 0, right: 12.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Container(
                                // width: 80.w,
                                // height: 100.h,
                                margin: EdgeInsets.only(
                                    left: index == 0 ? 15.w : 0, right: 12.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: const Color(0xff353535),
                                      radius: 40.sp,
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    const Text(
                                      'Loading',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
          if (state is RecentArtistsLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Text(
                    'Recent Artists',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.artist.length,
                      (index) {
                        var artist = state.artist[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ArtistPage(artistId: artist.id!),
                            ));
                          },
                          child: Container(
                            width: 80.w,
                            // height: 100.h,
                            margin: EdgeInsets.only(
                                left: index == 0 ? 15.w : 0, right: 12.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                    '${AppURLs.supabaseArtistStorage}${artist.name!.toLowerCase()}.jpg',
                                  ),
                                  radius: 40.sp,
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  artist.name!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class _RecentPlaylists extends StatelessWidget {
  const _RecentPlaylists();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecentPlaylistsCubit()..getRecentPlaylists(),
      child: BlocBuilder<RecentPlaylistsCubit, RecentPlaylistsState>(
        builder: (context, state) {
          if (state is RecentPlaylistsLoading) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  4,
                  (index) {
                    return Skeletonizer(
                      enabled: true,
                      child: Container(
                        width: 80.w,
                        height: 115.h,
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        margin: EdgeInsets.only(
                          left: index == 0 ? 15.w : 0,
                          right: 12.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            SizedBox(
                              child: Text(
                                'Loading...',
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'By',
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey.shade800),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Icon(
                                  Icons.person_rounded,
                                  size: 10.sp,
                                  color: Colors.grey.shade800,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Flexible(
                                  child: Text(
                                    'Loading...',
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.grey.shade800),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
          if (state is RecentPlaylistsLoaded) {
            return state.playlists.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Text(
                          'Recent Playlists',
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      SizedBox(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              state.playlists.length,
                              (index) {
                                var playlist = state.playlists[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlaylistPage(
                                          userEntity: playlist.user.userEntity,
                                          playlistEntity:
                                              state.playlists[index].playlist,
                                          onPlaylistDeleted: () {},
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 80.w,
                                    // height: 115.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                    margin: EdgeInsets.only(
                                      left: index == 0 ? 15.w : 0,
                                      right: 12.w,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 68.h,
                                          width: double.infinity,
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
                                          child: Padding(
                                            padding: EdgeInsets.all(12.sp),
                                            child: SvgPicture.asset(
                                              AppVectors.playlist,
                                              color: Colors.white,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            playlist.playlist.name!,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'By',
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Icon(
                                              Icons.person_rounded,
                                              size: 10.sp,
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Flexible(
                                              child: Text(
                                                playlist
                                                    .user.userEntity.fullName!,
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: AppColors.primary),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink();
          }
          return Container();
        },
      ),
    );
  }
}

class _RecentAlbums extends StatelessWidget {
  const _RecentAlbums();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecentAlbumsCubit()..getRecentAlbums(),
      child: BlocBuilder<RecentAlbumsCubit, RecentAlbumsState>(
          builder: (context, state) {
        if (state is RecentAlbumsError) {
          return SizedBox(
            height: 40.h,
            child: Center(
              child: Text(state.errorMessage),
            ),
          );
        }

        if (state is RecentAlbumsLoading) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                4,
                (index) {
                  return Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: 80.w,
                      height: 115.h,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      margin: EdgeInsets.only(
                        left: index == 0 ? 15.w : 0,
                        right: 12.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          SizedBox(
                            child: Text(
                              'Loading...',
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'Loading...',
                            style: TextStyle(
                                fontSize: 11.sp, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
        if (state is RecentAlbumsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: Text(
                  'Recent Albums',
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    state.albums.length,
                    (index) {
                      var albums = state.albums[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArtistAlbum(
                                artist: albums.artistEntity,
                                album: albums.albumEnitity),
                          ));
                        },
                        child: Container(
                          width: 80.w,
                          // height: 115.h,
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          margin: EdgeInsets.only(
                            left: index == 0 ? 15.w : 0,
                            right: 12.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 73.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '${AppURLs.supabaseAlbumStorage}${albums.artistEntity.name} - ${albums.albumEnitity.name}.jpg',
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ArtistPage(
                                        artistId: albums.artistEntity.id!,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  albums.artistEntity.name!,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: AppColors.primary),
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              SizedBox(
                                child: Text(
                                  albums.albumEnitity.name!,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
        return Container(
          child: const Text('failed'),
        );
      }),
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
