import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:spotify_clone/presentation/search/bloc/search_cubit.dart';
import 'package:spotify_clone/presentation/search/bloc/search_state.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isNotEmpty = false;
  late FocusNode _focusNode;
  bool _isFocused = false;

  final SearchCubit searchCubit = SearchCubit();

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
        print('TextField is focused');
      } else {
        print('TextField is not focused');
      }
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
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 17.w),
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 34, 34, 34),
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
                            Container(
                              margin: EdgeInsets.all(4.sp),
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.sp),
                                color: Colors.grey,
                              ),
                              child: Text('Favorite artist\'s popular songs'),
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
                    SizedBox(
                      width: 10.w,
                    ),
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      minWidth: 40.w,
                      child: Text('Cancel'),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              _isFocused && _searchController.value.text.isEmpty
                  ? Container(
                      child: Text('data'),
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
                          return const Center(
                            child: CircularProgressIndicator(),
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
                                ...users.map(
                                    (user) => UserTileWidget(userEntity: user)),
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
