import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/data/repository/auth/auth_service.dart';
import 'package:spotify_clone/testing/cubit.dart';
import 'testing/cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_clone/core/configs/constants/app_key.dart';
import 'package:spotify_clone/core/configs/theme/app_theme.dart';
import 'package:spotify_clone/data/repository/auth/auth_service.dart';
import 'package:spotify_clone/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/allSong_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/news_songs_cubit.dart';
import 'package:spotify_clone/presentation/home/pages/home_navigation.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_info/profile_info_cubit.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify_clone/presentation/splash/pages/splash.dart';
import 'package:spotify_clone/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
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
            BlocProvider(create: (_) => ProfileInfoCubit()..getUser()),
            BlocProvider(create: (_) => NewsSongsCubit()..getNewsSongs()),
            BlocProvider(create: (_) => AllSongCubit()..getAllSong()),
            BlocProvider(create: (_) => PlaylistSongsCubit()),
            // BlocProvider(
            //   create: (_) => PlaylistCubit()..getCurrentuserPlaylist(),
            // ),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => MaterialApp(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode,
              debugShowCheckedModeBanner: false,
              // home: Debug(),
              home: _isLoggedIn ? const HomeNavigation() : const SplashPage(),
              // home: ArtistPage(),
            ),
          ),
        );
      },
    );
  }
}
// lib/main.dart

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter BLoC Example',
//       home: BlocProvider(
//         create: (context) => ItemCubit(),
//         child: ItemListScreen(),
//       ),
//     );
//   }
// }

// class ItemListScreen extends StatelessWidget {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Item List'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: BlocBuilder<ItemCubit, ItemState>(
//               builder: (context, state) {
//                 if (state is ItemLoaded) {
//                   return ListView.builder(
//                     itemCount: state.items.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(state.items[index]),
//                       );
//                     },
//                   );
//                 }
//                 return Center(child: Text('No items yet.'));
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(labelText: 'Add Item'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: () {
//                     if (_controller.text.isNotEmpty) {
//                       context.read<ItemCubit>().addItem(_controller.text);
//                       _controller.clear();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
