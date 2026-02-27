import 'package:devstrix/core/constants/app_constants.dart';
import 'package:devstrix/presentation/views/home/home_screen.dart';
import 'package:devstrix/presentation/views/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Text('Library', style: TextStyle(color: Colors.white)),
      ),
    ),
    const Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Text('Journal', style: TextStyle(color: Colors.white)),
      ),
    ),
    const Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Text('Recommend', style: TextStyle(color: Colors.white)),
      ),
    ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(canvasColor: AppColors.black),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              backgroundColor: AppColors.black,
              selectedItemColor: AppColors.primaryPink,
              unselectedItemColor: AppColors.textGrey,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart),
                  label: 'Library',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book_outlined),
                  activeIcon: Icon(Icons.book),
                  label: 'Journal',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fitness_center),
                  activeIcon: Icon(Icons.fitness_center),
                  label: 'Recommend',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
