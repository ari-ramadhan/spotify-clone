import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/data/repository/auth/auth_service.dart';
import 'package:spotify_clone/domain/entity/auth/user.dart';
import 'package:spotify_clone/presentation/home/pages/home.dart';
import 'package:spotify_clone/presentation/search/search_page.dart';
import 'package:spotify_clone/testing/profile_test_page.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  String fullName = '';
  String email = '';
  // String userId = '';
  bool isCurrentUser = false;

  Future getUserInfo() async {
    List<String>? userInfo = await AuthService().getUserLoggedInInfo();
    if (userInfo != null) {
      setState(() {
        email = userInfo[1];
        fullName = userInfo[2];
      });
    }
    return userInfo![0];
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const HomePage(),
        const SearchPage(),
        // ProfileTestPage()
        ProfilePage(
          hideBackButton: true,
          userEntity: UserWithStatus(
              userEntity: UserEntity(
                  userId: supabase.auth.currentUser!.id,
                  fullName: fullName,
                  email: email),
              isFollowed: false),
        ),
      ][_selectedIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            indent: 0,
            color: Colors.white,
            thickness: 0.1,
            height: 0.1,
          ),
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color.fromARGB(255, 22, 21, 21),
            selectedItemColor: AppColors.primary,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            unselectedItemColor: Colors.white70,
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_rounded,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search_rounded,
                  ),
                  label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.my_library_music_sharp,
                  ),
                  label: 'My Library'),
            ],
          ),
        ],
      ),
    );
  }
}
