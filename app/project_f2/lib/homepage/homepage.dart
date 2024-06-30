import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project_f2/chatpage/chatpage.dart';
import 'package:project_f2/foryoupage/fyp.dart';
import 'package:project_f2/mytoppage/mytoppage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ForYouPage(),
    ChatPage(),
    MyTopMusic(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          _pages[_selectedIndex],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double
                  .infinity, // This makes the container fill the width of its parent
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(1),
                  ],
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                child: GNav(
                  mainAxisAlignment: MainAxisAlignment.center,
                  color: Colors.white,
                  activeColor: Colors.white,
                  gap: 12,
                  duration: Durations.long4,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  selectedIndex: _selectedIndex,
                  backgroundColor: Colors.black.withOpacity(0),
                  padding: const EdgeInsets.all(18),
                  tabs: [
                    GButton(
                      icon: _selectedIndex == 0
                          ? Icons.home
                          : Icons.home_outlined,
                      iconColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                    ),
                    GButton(
                      icon: _selectedIndex == 1
                          ? Icons.chat_bubble
                          : Icons.chat_bubble_outline,
                      iconColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    ),
                    GButton(
                      icon: _selectedIndex == 2
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      iconColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
