import 'package:app/pages/Auth/Home/Setting.dart';
import 'package:app/pages/Auth/Home/Tasks.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/Auth/Home/Profile.dart'; // Importa la página Profile


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          TasksPage(),
          ProfilePage(),
          SettingPAge(), // Muestra la página Profile
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 40,),

            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,size: 40,),
            label: '',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,size: 40,),
            label: '',
          ),
        ],
        currentIndex: _currentIndex,
        elevation: 0,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,

            );
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
