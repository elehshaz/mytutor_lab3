import 'package:flutter/material.dart';
import 'subjectpage.dart';
import 'tutorpage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const List<Widget> page = <Widget>[
    SubjectPage(),
    TutorPage(), 
  ];

  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
         child: page.elementAt(selectedItem),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false, 
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Subject',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tutors',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up),
            label: 'Favourite',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.pages),
            label: 'Subscribe',
            ),
          ],
        
        currentIndex : selectedItem,
        onTap: _onItemTap,
        ),
      );

  }

  void _onItemTap(int index) {
    setState(() {
       selectedItem = index; 
      }
    );
  }
}
