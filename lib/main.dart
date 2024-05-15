import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logistics/LoginScreen.dart';
import 'package:logistics/ImageCodeWorkPath.dart';
import 'package:logistics/ImageToArrayofDecode64.dart';
import 'package:logistics/theOrder.dart';
import 'home.dart';
import 'services.dart';
import 'activity.dart';
import 'account.dart';

// ignore: deprecated_member_use
DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("user");

void main() {
  runApp( SignUpApp());//SignUpApp
}
// ignore: deprecated_member_use
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPLT App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: LoginScreen(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    OrdersPage(),
    Activity(),
    Account(),
    ImageCode(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pages[_currentIndex], // Display the selected screen here
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'My Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Image',
            ),
          ],
        ),
      ),
    );
  }
}
