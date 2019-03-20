import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:it_home/tools/Ajax.dart';
import 'package:it_home/tools/api.dart';

class WeixinPage extends StatefulWidget {
  WeixinPage({Key key}) : super(key: key);

  @override
  WeixinPageState createState() => WeixinPageState();
}

class WeixinPageState extends State<WeixinPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List articleList = [];
  int page = 1;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    loadArticleList();
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future loadArticleList() async {
    String url = Api.swiperList;
    var data = {'pageIndex': 1, 'pageSize': 10};
    var response = await HttpUtil().get(url, data: data);
    print(response);
    setState(() {
//      articleList.addAll(response);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IT之家'),
        bottom: new TabBar(
          tabs: tabs(),
          labelColor: Color(0xfff44f44),
          unselectedLabelColor: Color(0xff353535),
          indicatorColor: Color(0xfff44f44),
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      body: loading
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : new TabBarView(
              controller: _tabController,
              children: <Widget>[
                ListView.builder(
                  padding: new EdgeInsets.all(0.0),
//        itemExtent: 50.0,
                  itemCount: articleList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return newsItem(index);
                  },
                ),
              ],
            ),
    );
  }

  List<Widget> tabs() {
    List<Widget> children = [];
    children.add(
      new Tab(
        text: '最新',
      ),
    );
    children.add(
      new Tab(
        text: '上热评',
      ),
    );
    children.add(
      new Tab(
        text: '精读',
      ),
    );
    return children;
  }

  Widget newsItem(index) {
    return Container(
      width: 200.0,
      child: Text(
        '${articleList[index]['title']}',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
