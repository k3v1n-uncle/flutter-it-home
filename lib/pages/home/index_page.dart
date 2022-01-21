import 'package:flutter/material.dart';
import 'package:it_home_flutter/pages/home/home_page.dart';
import 'package:it_home_flutter/pages/user/user_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentIndex = 0;

  List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: '')
  ];
  List<Widget> _pages = [MyHomePage(), UserPage()];

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
