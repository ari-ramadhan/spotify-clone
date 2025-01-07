import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/presentation/home/pages/home.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({Key? key}) : super(key: key);

  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  final List<Widget> _pages = [
    const HomePage(),
    Scaffold(
      body: Center(
        child: Container(
          child: const Text('Hallo'),
        ),
      ),
    ),
    const ProfilePage(),
    Scaffold(
      body: Center(
        child: Container(
          child: const Text('Hallo'),
        ),
      ),
    ),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: _pages[_selectedIndex],
//       body: PersistentTabView(
//         context,

//         backgroundColor: Colors.grey.shade900,
//         confineToSafeArea: true,
//         resizeToAvoidBottomInset: false,
//         navBarStyle: NavBarStyle.style7,

// // padding: EdgeInsets.symmetric(vertical: 10.h),
//         items: [
//           navBarItem(icon: Icons.home_rounded, title: 'Home'),
//           navBarItem(icon: Icons.search_rounded, title: 'Search'),
//           navBarItem(icon: Icons.person_rounded, title: 'Profile'),
//           navBarItem(icon: Icons.ac_unit_rounded, title: 'Premium'),
//         ],
//         screens: _pages,
//       ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.grey.shade900,
        showUnselectedLabels: true,
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
                Icons.person_rounded,
              ),
              label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.assistant,
              ),
              label: 'Premium'),
        ],
      ),
    );
  }

  PersistentBottomNavBarItem navBarItem(
      {required IconData icon, required String title}) {
    return PersistentBottomNavBarItem(
      icon: Icon(
        icon,
      ),
      title: title,
      iconSize: 22.sp,
      activeColorPrimary: AppColors.primary,
      activeColorSecondary: Colors.white,
      inactiveColorPrimary: Colors.white60,
      contentPadding: 1,
      textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    );
  }
}
