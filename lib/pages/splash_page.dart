import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:it_home/pages/main_pages/MainPage.dart';
import 'dart:math';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => new SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  List imgList = [
    'lib/images/splash_1.jpg',
    'lib/images/splash_2.jpg',
    'lib/images/splash_3.jpg',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImageList();
  }

  void dispose() {
    super.dispose();
  }

  void loadImageList() {}
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new SplashScreen(
          seconds: 4,
          navigateAfterSeconds: new AfterSplash(),
//          title: new Text(
//            'Welcome In SplashScreen',
//            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
//          ),
//          image: new Image.asset('lib/images/splash_1.jpg'),
//          backgroundColor: Colors.white,
//          styleTextUnderTheLoader: new TextStyle(),
////        photoSize: 1080.0,
//          onClick: () {
//            print("Flutter Egypt");
//          },
//          loaderColor: Colors.red,
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/images/splash_1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IndexPage();
  }
}
