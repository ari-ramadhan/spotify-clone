import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_clone/core/configs/constants/app_key.dart';
import 'package:spotify_clone/core/configs/theme/app_theme.dart';
import 'package:spotify_clone/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:spotify_clone/presentation/home/pages/home.dart';
import 'package:spotify_clone/presentation/splash/pages/splash.dart';
import 'package:spotify_clone/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(MyApp());
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(

      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => MaterialApp(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode,
              debugShowCheckedModeBanner: false,
              // home: HomePage(),
              home: const SplashPage(),
              // home: SplashPage(),
            ),
          ),
        );
      },
    );

    ;
  }
}
