import 'package:flutter/material.dart';
import 'package:kiddie_care_app/pages/Book/display_booking.dart';
import 'package:kiddie_care_app/pages/Parent/parent_profile.dart';
import 'package:kiddie_care_app/pages/Saved/saved_page.dart';
import 'package:kiddie_care_app/pages/Search/caregiver_search.dart';
import 'package:kiddie_care_app/pages/Search/parent_search.dart';

class AppNavigationBar extends StatefulWidget {
  final String userRole; // Add this parameter
  const AppNavigationBar({super.key, required this.userRole});

  @override
  // ignore: library_private_types_in_public_api
  _AppNavigationBarState createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  // final List<Widget> _pages = [
  //   //const CaregiverSearch(), //for babysitter/childcarecentres
  //   const ParentSearch(), //only for parent
  //   const SavePerson(), //share between 3 roles
  //   const DisplayBookingPage(), //share between 3 roles
  //   const ParentProfile(), //share between 3 roles
  // ];
  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    // Use widget.userRole to access the logged-in user's role
    final userRole = widget.userRole;

    // Conditionally set the pages based on user's role
    if (userRole == 'parents') {
      _pages = [
        const ParentSearch(),
        const SavePerson(),
        const DisplayBookingPage(),
        const ParentProfile(),
      ];
    } else {
      _pages = [
        const CaregiverSearch(),
        const SavePerson(),
        const DisplayBookingPage(),
        const ParentProfile(),
      ];
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
