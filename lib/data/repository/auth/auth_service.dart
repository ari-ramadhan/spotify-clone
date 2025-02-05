import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/data/models/auth/user.dart';

class AuthService {
  // Save login status
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future saveUserLoggedInInfo (UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('userInfo', [user.userId.toString(), user.email.toString(), user.fullName.toString()]);
  }

  Future<List<String>?> getUserLoggedInInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('userInfo');
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Default to false if not set
  }

  // Logout function
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.clear();
  }
}
