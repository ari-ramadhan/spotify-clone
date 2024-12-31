import 'package:get_it/get_it.dart';
import 'package:spotify_clone/data/repository/album/album_repository_impl.dart';
import 'package:spotify_clone/data/repository/artist/artist_repository_impl.dart';
import 'package:spotify_clone/data/repository/auth/auth_repository_impl.dart';
import 'package:spotify_clone/data/repository/song/song_repository_impl.dart';
import 'package:spotify_clone/data/sources/album/album_supabase_service.dart';
import 'package:spotify_clone/data/sources/artist/artist_supabase_service.dart';
import 'package:spotify_clone/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify_clone/data/sources/song/song_supabase_service.dart';
import 'package:spotify_clone/domain/repository/album/album.dart';
import 'package:spotify_clone/domain/repository/artist/artist.dart';
import 'package:spotify_clone/domain/repository/auth/auth.dart';
import 'package:spotify_clone/domain/repository/song/song.dart';
import 'package:spotify_clone/domain/usecases/album/get_artist_album.dart';
import 'package:spotify_clone/domain/usecases/artist/get_all_artist.dart';
import 'package:spotify_clone/domain/usecases/artist/get_artist_info.dart';
import 'package:spotify_clone/domain/usecases/auth/get_user.dart';
import 'package:spotify_clone/domain/usecases/auth/signin.dart';
import 'package:spotify_clone/domain/usecases/auth/signup.dart';
import 'package:spotify_clone/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:spotify_clone/domain/usecases/song/get_album_songs.dart';
import 'package:spotify_clone/domain/usecases/song/get_artist_songs.dart';
import 'package:spotify_clone/domain/usecases/song/get_play_list.dart';
import 'package:spotify_clone/domain/usecases/song/is_favorite_song.dart';
import 'package:spotify_clone/domain/usecases/song/news_songs.dart';
import 'package:spotify_clone/domain/usecases/song/user_favorite_songs.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies () async {

  // auth
  sl.registerSingleton<AuthSupabaseService>(
    AuthSupabaseServiceImpl()
  );
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl()
  );
  sl.registerSingleton<SignUpUseCase>(
    SignUpUseCase()
  );
  sl.registerSingleton<SignInUseCase>(
    SignInUseCase()
  );
  sl.registerSingleton<GetUserUseCase>(
    GetUserUseCase()
  );

  // songs
  sl.registerSingleton<SongRepository>(
    SongRepositoryImpl()
  );
  sl.registerSingleton<SongSupabaseService>(
    SongSupabaseServiceImpl()
  );
  sl.registerSingleton<GetNewsSongsUseCase>(
    GetNewsSongsUseCase()
  );
  sl.registerSingleton<GetPlaylistUseCase>(
    GetPlaylistUseCase()
  );
  sl.registerSingleton<GetUserFavoriteSongUseCase>(
    GetUserFavoriteSongUseCase()
  );
  sl.registerSingleton<AddOrRemoveFavoriteSongUseCase>(
    AddOrRemoveFavoriteSongUseCase()
  );
  sl.registerSingleton<IsFavoriteSongUseCase>(
    IsFavoriteSongUseCase()
  );
  sl.registerSingleton<GetArtistSongsUseCase>(
    GetArtistSongsUseCase()
  );
  sl.registerSingleton<GetAlbumSongsUseCase>(
    GetAlbumSongsUseCase()
  );

  // artist
  sl.registerSingleton<ArtistRepository>(
    ArtistRepositoryImpl()
  );
  sl.registerSingleton<ArtistSupabaseService>(
    ArtistSupabaseServiceImpl()
  );
  sl.registerSingleton<GetArtistInfoUseCase>(
    GetArtistInfoUseCase()
  );
  sl.registerSingleton<GetAllArtistUseCase>(
    GetAllArtistUseCase()
  );

  // album
  sl.registerSingleton<AlbumRepository>(
    AlbumRepositoryImpl()
  );
  sl.registerSingleton<AlbumSupabaseService>(
    AlbumSupabaseServiceImpl()
  );
  sl.registerSingleton<GetArtistAlbumUseCase>(
    GetArtistAlbumUseCase()
  );

}
