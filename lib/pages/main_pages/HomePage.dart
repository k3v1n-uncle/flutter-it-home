import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:it_home/pages/news_list_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsTab {
  String text;
  NewsList newsList;
  NewsTab(this.text, this.newsList);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<NewsTab> myTabs = <NewsTab>[
    new NewsTab('最新', new NewsList(newsType: 'news')), //拼音就是参数值
    new NewsTab('精读', new NewsList(newsType: 'jingdu')),
    new NewsTab('原创', new NewsList(newsType: 'original')),
    new NewsTab('评测室', new NewsList(newsType: 'labs')),
    new NewsTab('发布会', new NewsList(newsType: 'live')),
    new NewsTab('阳台', new NewsList(newsType: 'balcony')),
    new NewsTab('手机', new NewsList(newsType: 'phone')),
    new NewsTab('数码', new NewsList(newsType: 'digi')),
    new NewsTab('VR', new NewsList(newsType: 'vr')),
    new NewsTab('智能汽车', new NewsList(newsType: 'auto')),
    new NewsTab('电脑', new NewsList(newsType: 'pc')),
    new NewsTab('京东精选', new NewsList(newsType: 'jd')),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2220)..init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBar(
          title: Image(
            width: ScreenUtil.getInstance().setWidth(160),
            height: ScreenUtil.getInstance().setHeight(65),
            image: AssetImage('lib/images/ithome_logo.png'),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs.map((NewsTab item) {
              return new Tab(text: item.text ?? '');
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
        preferredSize:
            Size.fromHeight(ScreenUtil.getInstance().setHeight(2220) * 0.1),
      ),
      body: new TabBarView(
        physics: ScrollPhysics(),
        controller: _tabController,
        children: myTabs.map((item) {
          return item.newsList; //使用参数值
        }).toList(),
      ),
    );
  }
}
