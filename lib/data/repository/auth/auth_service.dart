import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/core/configs/constants/app_key_feature.dart';
import 'package:spotify_clone/data/models/auth/user.dart';

class AuthService {
  // Save login status
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppKeysFeature.SF_IS_LOGGED_IN, isLoggedIn);
  }

  Future saveUserLoggedInInfo(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(AppKeysFeature.SF_USER_INFO, [
      user.userId.toString(),
      user.email.toString(),
      user.fullName.toString()
    ]);
  }

  Future<List<String>?> getUserLoggedInInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(AppKeysFeature.SF_USER_INFO);
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppKeysFeature.SF_IS_LOGGED_IN) ??
        false; // Default to false if not set
  }

  // Logout function
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppKeysFeature.SF_IS_LOGGED_IN, false);
    await prefs.clear();
  }
}
