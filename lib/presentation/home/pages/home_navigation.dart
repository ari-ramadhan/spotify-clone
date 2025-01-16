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
    // Scaffold(),
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
      body: _pages[_selectedIndex],
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
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.assistant,
                  ),
                  label: 'Premium'),
            ],
          ),
        ],
      ),
    );
  }
}
