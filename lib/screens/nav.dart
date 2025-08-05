import 'package:flutter/material.dart';

import '../screens/home_page.dart';
import '../screens/profile.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {

  int navigationIndex = 0;
  List<Widget> pages = <Widget>[
    HomePage(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[navigationIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              navigationIndex = index;
            });
          },
          currentIndex: navigationIndex,

          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle),
                label: "Profile"
            )

          ]),
    );
  }
}
