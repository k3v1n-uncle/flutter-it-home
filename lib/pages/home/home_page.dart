import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:it_home_flutter/pages/home/news_list_page.dart';

class NewsTab {
  String text;
  NewsList newsList;
  NewsTab(this.text, this.newsList);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<NewsTab> myTabs = <NewsTab>[
    NewsTab('最新', NewsList(newsType: 'news')), //拼音就是参数值
    NewsTab('精读', NewsList(newsType: 'jingdu')),
    NewsTab('原创', NewsList(newsType: 'original')),
    NewsTab('评测室', NewsList(newsType: 'labs')),
    NewsTab('发布会', NewsList(newsType: 'live')),
    NewsTab('阳台', NewsList(newsType: 'balcony')),
    NewsTab('手机', NewsList(newsType: 'phone')),
    NewsTab('数码', NewsList(newsType: 'digi')),
    NewsTab('VR', NewsList(newsType: 'vr')),
    NewsTab('智能汽车', NewsList(newsType: 'auto')),
    NewsTab('电脑', NewsList(newsType: 'pc')),
    NewsTab('京东精选', NewsList(newsType: 'jd')),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Colors.white,
          title: Image(
            width: ScreenUtil().setWidth(160),
            height: ScreenUtil().setHeight(65),
            image: const AssetImage('assets/images/ithome_logo.png'),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs.map((NewsTab item) {
              return Tab(text: item.text);
            }).toList(),
            indicatorColor: Color(0xfff44f44),
            labelColor: Color(0xfff44f44),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
            ),
            unselectedLabelColor: Color(0xff353535),
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
          ),
          actions: <Widget>[
            Icon(
              Icons.date_range,
              color: Color(0xff656565),
            ),
            SizedBox(
              width: 10.0,
            ),
            Icon(
              Icons.search,
              color: Color(0xff656565),
            ),
            SizedBox(
              width: 10.0,
            ),
            Icon(
              Icons.more_vert,
              color: Color(0xff656565),
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
        preferredSize: Size.fromHeight(ScreenUtil().setHeight(2220) * 0.1),
      ),
      body: TabBarView(
        physics: ScrollPhysics(),
        controller: _tabController,
        children: myTabs.map((item) {
          return item.newsList; //使用参数值
        }).toList(),
      ),
    );
  }
}
