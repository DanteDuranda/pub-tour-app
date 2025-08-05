import 'package:flutter/material.dart';

import '../screens/login_page.dart';
import '../screens/registration_page.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {

  int navigationIndex = 0;
  List<Widget> pages = <Widget>[
    LoginScreen(),
    RegistrationScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(navigationIndex),
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
                icon: Icon(Icons.login_outlined),
                label: "Login"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.app_registration_outlined),
                label: "Registration"
            )
          ]),
    );
  }
}
