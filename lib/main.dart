// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:educharm/controller.dart';
import 'package:educharm/screens/HomePage.dart';
import 'package:educharm/screens/Spelling_bee_screen.dart';
import 'package:educharm/screens/Games_screen.dart';
import 'package:educharm/screens/Activities_screen.dart';
import 'package:educharm/screens/welcome_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Controller(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Educharm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'PartyConfetti',
            fontSize: 60.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: WelcomeScreen(), // Set WelcomeScreen as the initial screen
      debugShowCheckedModeBanner: false,
      routes: {
        '/navigation': (context) => NavigationManager(), // Add this line
      },
    );
  }
}

class NavigationManager extends StatefulWidget {
  const NavigationManager({super.key});

  @override
  _NavigationManagerState createState() => _NavigationManagerState();
}

class _NavigationManagerState extends State<NavigationManager> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    GamesScreen(),
    SpellingBeeScreen(),
    ActivitiesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.blueAccent
            : const Color.fromARGB(255, 2, 39, 61),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.blueAccent),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildNavItem(Icons.home, 'Home Sn', _selectedIndex == 0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(Icons.abc, 'Alpha AR', _selectedIndex == 1),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(
                Icons.videogame_asset, 'Spelling B', _selectedIndex == 2),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(
                Icons.videogame_asset, 'Activities', _selectedIndex == 3),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
