import 'package:flutter/material.dart';
import 'package:it_home/pages/member_page.dart';
import 'package:it_home/pages/found_page.dart';
import 'package:it_home/pages/contact_page.dart';
import 'package:it_home/pages/main_pages/HomePage.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentIndex = 0;

  List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
        icon: Icon(Icons.chrome_reader_mode), title: Text('资讯')),
    BottomNavigationBarItem(icon: Icon(Icons.whatshot), title: Text('辣品')),
    BottomNavigationBarItem(
        icon: Icon(Icons.supervised_user_circle), title: Text('圈子')),
    BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('我的'))
  ];
  List<Widget> _pages = [
    MyHomePage(),
    FoundPage(),
    MemberPage(),
    ContactPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color(0xfff44f44),
        iconSize: 24.0,
        type: BottomNavigationBarType.fixed,
        items: _items,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
