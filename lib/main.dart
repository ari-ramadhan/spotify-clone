import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/core/configs/constants/app_key_feature.dart';
import 'package:spotify_clone/data/repository/auth/auth_service.dart';
import 'package:spotify_clone/presentation/genre_picks/pages/genre_picks.dart';
import 'package:spotify_clone/presentation/home/bloc/all_song/allSong_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/hot_artists/hot_artists_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/news_song/news_songs_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/top_album/top_album_cubit.dart';
import 'package:spotify_clone/presentation/home/pages/home_navigation.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_image_upload/profile_image_cubit.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.darkBackground));

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  await Supabase.initialize(
    url: AppKey.YOUR_SUPABASE_URL,
    anonKey: AppKey.YOUR_SUPABASE_ANONKEY,
  );

  await initializeDependencies();

  runApp(const MyApp());
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;
final AuthService _authService = AuthService();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _onBoarded = false;
  bool _onBoardAutoSkip = true;
  int _appOpenedCount = 0;
  String username = '';
  String email = '';

  Future<void> _checkOnBoardStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _onBoarded = prefs.getBool(AppKeysFeature.SF_ONBOARDING_COMPLETE) ?? false;
    _appOpenedCount = prefs.getInt(AppKeysFeature.SF_APP_OPENED_COUNT) ?? 0;

    if (_appOpenedCount == 20) {
      _onBoardAutoSkip = false;
    }
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await _authService.checkLoginStatus();
    if (!mounted) return;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  void initState() {
    _checkLoginStatus();
    _checkOnBoardStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit()),
            BlocProvider(create: (_) => SongPlayerCubit()),
            BlocProvider(create: (_) => NewsSongsCubit()..getNewsSongs()),
            BlocProvider(create: (_) => HotArtistsCubit()..getHotArtists()),
            BlocProvider(create: (_) => TopAlbumsCubit()..getTopAlbums()),
            BlocProvider(create: (_) => AllSongCubit()..getAllSong()),
            BlocProvider(create: (_) => PlaylistCubit()),
            BlocProvider(create: (_) => PlaylistSongsCubit()),
            BlocProvider(create: (_) => AvatarCubit(supabase)),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => MaterialApp(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode,
              debugShowCheckedModeBanner: false,
              home: _isLoggedIn
                  ? _onBoarded || _onBoardAutoSkip
                      ? const HomeNavigation()
                      : const GenrePicks()
                  : const SplashPage(),
              // home: GenrePicks(),
            ),
          ),
        );
      },
    );
  }
}
