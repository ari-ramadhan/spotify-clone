import 'package:spotify_clone/core/configs/constants/app_key.dart';

class AppURLs {

  static const supabaseCoverStorage = '${AppKey.YOUR_SUPABASE_URL}/storage/v1/object/public/songs/covers/';
  static const supabaseSongStorage = '${AppKey.YOUR_SUPABASE_URL}/storage/v1/object/public/songs/songs/';
  static const supabaseArtistStorage = '${AppKey.YOUR_SUPABASE_URL}/storage/v1/object/public/songs/artist/';
  static const supabaseAlbumStorage = '${AppKey.YOUR_SUPABASE_URL}/storage/v1/object/public/songs/albums/';
  static const supabaseThisIsMyStorage = '${AppKey.YOUR_SUPABASE_URL}/storage/v1/object/public/songs/thisIsMy/';
  static const defaultProfile = 'https://cdn-icons-png.flaticon.com/128/1177/1177568.png';


}
