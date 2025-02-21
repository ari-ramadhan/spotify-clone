import 'package:get_it/get_it.dart';
import 'package:spotify_clone/data/repository/album/album_repository_impl.dart';
import 'package:spotify_clone/data/repository/artist/artist_repository_impl.dart';
import 'package:spotify_clone/data/repository/auth/auth_repository_impl.dart';
import 'package:spotify_clone/data/repository/playlist/playlist_repository.dart';
import 'package:spotify_clone/data/repository/song/song_repository_impl.dart';
import 'package:spotify_clone/data/sources/album/album_supabase_service.dart';
import 'package:spotify_clone/data/sources/artist/artist_supabase_service.dart';
import 'package:spotify_clone/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify_clone/data/sources/playlist/playlist_supabase_service.dart';
import 'package:spotify_clone/data/sources/song/song_supabase_service.dart';
import 'package:spotify_clone/domain/repository/album/album.dart';
import 'package:spotify_clone/domain/repository/artist/artist.dart';
import 'package:spotify_clone/domain/repository/auth/auth.dart';
import 'package:spotify_clone/domain/repository/playlist/playlist.dart';
import 'package:spotify_clone/domain/repository/song/song.dart';
import 'package:spotify_clone/domain/repository/user/user.dart';
import 'package:spotify_clone/domain/usecases/album/get_all_songs.dart';
import 'package:spotify_clone/domain/usecases/album/get_artist_album.dart';
import 'package:spotify_clone/domain/usecases/album/get_top_albums.dart';
import 'package:spotify_clone/domain/usecases/artist/follow_unfollow_artist.dart';
import 'package:spotify_clone/domain/usecases/artist/get_all_artist.dart';
import 'package:spotify_clone/domain/usecases/artist/get_artist_info.dart';
import 'package:spotify_clone/domain/usecases/artist/get_followed_artists.dart';
import 'package:spotify_clone/domain/usecases/artist/get_recommended_artist_based_on_playlist.dart';
import 'package:spotify_clone/domain/usecases/artist/hot_artists.dart';
import 'package:spotify_clone/domain/usecases/artist/is_following_artist.dart';
import 'package:spotify_clone/domain/usecases/auth/get_user.dart';
import 'package:spotify_clone/domain/usecases/auth/signin.dart';
import 'package:spotify_clone/domain/usecases/auth/signup.dart';
import 'package:spotify_clone/domain/usecases/playlist/add_new_playlist.dart';
import 'package:spotify_clone/domain/usecases/playlist/add_songs_to_playlist.dart';
import 'package:spotify_clone/domain/usecases/playlist/batch_add_to_playlist.dart';
import 'package:spotify_clone/domain/usecases/playlist/delete_playlist.dart';
import 'package:spotify_clone/domain/usecases/playlist/delete_song_from_playlist.dart';
import 'package:spotify_clone/domain/usecases/playlist/get_currentUser_playlist.dart';
import 'package:spotify_clone/domain/usecases/playlist/add_song_by_keyword.dart';
import 'package:spotify_clone/domain/usecases/playlist/update_playlist_info.dart';
import 'package:spotify_clone/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:spotify_clone/domain/usecases/song/add_recent_song.dart';
import 'package:spotify_clone/domain/usecases/song/get_album_songs.dart';
import 'package:spotify_clone/domain/usecases/song/get_artist_single_songs.dart';
import 'package:spotify_clone/domain/usecases/song/get_artist_songs.dart';
import 'package:spotify_clone/domain/usecases/song/get_play_list.dart';
import 'package:spotify_clone/domain/usecases/song/get_playlist_songs.dart';
import 'package:spotify_clone/domain/usecases/song/get_recent_songs.dart';
import 'package:spotify_clone/domain/usecases/song/is_favorite_song.dart';
import 'package:spotify_clone/domain/usecases/song/news_songs.dart';
import 'package:spotify_clone/domain/usecases/song/popular_songs_from_fav_artist.dart';
import 'package:spotify_clone/domain/usecases/song/search_song.dart';
import 'package:spotify_clone/domain/usecases/song/search_song_by_keyword.dart';
import 'package:spotify_clone/domain/usecases/song/user_favorite_songs.dart';
import 'package:spotify_clone/domain/usecases/user/check_following_status.dart';
import 'package:spotify_clone/domain/usecases/user/follow_user.dart';
import 'package:spotify_clone/domain/usecases/user/get_followerAndFollowing.dart';
import 'package:spotify_clone/domain/usecases/user/update_favorite_genres.dart';
import 'package:spotify_clone/domain/usecases/user/update_username.dart';
import 'package:spotify_clone/domain/usecases/user/upload_profile_picture.dart';
import 'data/repository/user/user_repository_impl.dart';
import 'data/sources/user/user_supabase_service.dart';

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
  sl.registerSingleton<GetAllSongsUseCase>(
    GetAllSongsUseCase()
  );
  sl.registerSingleton<GetPlaylistSongsUseCase>(
    GetPlaylistSongsUseCase()
  );
  sl.registerSingleton<SearchSongByKeywordUseCase>(
    SearchSongByKeywordUseCase()
  );
  sl.registerSingleton<GetRecentSongsUseCase>(
    GetRecentSongsUseCase()
  );
  sl.registerSingleton<AddRecentSongUseCase>(
    AddRecentSongUseCase()
  );
  sl.registerSingleton<SearchSongUseCase>(
    SearchSongUseCase()
  );
  sl.registerSingleton<PopularSongsFromFavArtistUseCase>(
    PopularSongsFromFavArtistUseCase()
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
  sl.registerSingleton<FollowUnfollowArtistUseCase>(
    FollowUnfollowArtistUseCase()
  );
  sl.registerSingleton<IsFollowingArtistUseCase>(
    IsFollowingArtistUseCase()
  );
  sl.registerSingleton<GetRecommendedArtistBasedOnPlaylistUseCase>(
    GetRecommendedArtistBasedOnPlaylistUseCase()
  );
  sl.registerSingleton<GetFollowedArtistsUseCase>(
    GetFollowedArtistsUseCase()
  );
  sl.registerSingleton<GetArtistSingleSongs>(
    GetArtistSingleSongs()
  );
  sl.registerSingleton<HotArtistsUseCase>(
    HotArtistsUseCase()
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
  sl.registerSingleton<GetTopAlbumsUseCase>(
    GetTopAlbumsUseCase()
  );

  // playlist
  sl.registerSingleton<PlaylistRepository>(
    PlaylistRepositoryImpl()
  );
  sl.registerSingleton<PlaylistSupabaseService>(
    PlaylistSupabaseServiceImpl()
  );
  sl.registerSingleton<GetCurrentuserPlaylistUseCase>(
    GetCurrentuserPlaylistUseCase()
  );
  sl.registerSingleton<AddNewPlaylistUseCase>(
    AddNewPlaylistUseCase()
  );
  sl.registerSingleton<UpdatePlaylistInfoUseCase>(
    UpdatePlaylistInfoUseCase()
  );
  sl.registerSingleton<AddSongsToPlaylistUseCase>(
    AddSongsToPlaylistUseCase()
  );
  sl.registerSingleton<DeletePlaylistUseCase>(
    DeletePlaylistUseCase()
  );
  sl.registerSingleton<AddSongByKeywordUseCase>(
    AddSongByKeywordUseCase()
  );
  sl.registerSingleton<DeleteSongFromPlaylistUseCase>(
    DeleteSongFromPlaylistUseCase()
  );
  sl.registerSingleton<BatchAddToPlaylistUseCase>(
    BatchAddToPlaylistUseCase()
  );

  // user
  sl.registerSingleton<UserRepository>(
    UserRepositoryImpl()
  );
  sl.registerSingleton<UserSupabaseService>(
    UserSupabaseServiceImpl()
  );
  sl.registerSingleton<GetFollowerandfollowingUseCase>(
    GetFollowerandfollowingUseCase()
  );
  sl.registerSingleton<FollowUserUseCase>(
    FollowUserUseCase()
  );
  sl.registerSingleton<CheckFollowingStatusUseCase>(
    CheckFollowingStatusUseCase()
  );
  sl.registerSingleton<UploadProfilePictureUseCase>(
    UploadProfilePictureUseCase()
  );
  sl.registerSingleton<UpdateUsernameUseCase>(
    UpdateUsernameUseCase()
  );
  sl.registerSingleton<UpdateFavoriteGenresUseCase>(
    UpdateFavoriteGenresUseCase()
  );


}
