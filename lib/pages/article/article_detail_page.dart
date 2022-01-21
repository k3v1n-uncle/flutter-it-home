import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:it_home_flutter/utils/Ajax.dart';
import 'package:it_home_flutter/utils/api.dart';

class ArticleDetailPage extends StatefulWidget {
  final Map article; //新闻类型
  @override
  ArticleDetailPage({
    Key? key,
    required this.article,
  }) : super(key: key);

  ArticleDetailPageState createState() => new ArticleDetailPageState();
}

class ArticleDetailPageState extends State<ArticleDetailPage> {
  Map articleDetail = {};
  List articleList = [];
  List articleComments = [];
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadArticleDetail();
    loadArticleList();
    loadArticleComments();
  }

  void dispose() {
    super.dispose();
  }

  Future loadArticleDetail() async {
    String url = Api.articleDetail + widget.article['newsid'].toString();
    var data = {
      'pageIndex': 1,
    };
    // var response = await HttpUtil().get(url, data: data);
    // setState(() {
    //   articleDetail = response;
    //   loading = false;
    // });
  }

  Future loadArticleComments() async {
    String url = Api.articleComments + '?sn=c0fa3b6d2022ced7';
    var data = {
      'pageIndex': 1,
    };
    // var response = await HttpUtil().get(url, data: data);
    // setState(() {
    //   articleComments = response['hlist'];
    //   loading = false;
    // });
  }

  Future loadArticleList() async {
    String url = Api.articleList + 'android';
    var data = {
      'pageIndex': 1,
    };
    // var response = await HttpUtil().get(url, data: data);
    // setState(() {
    //   for (var i = 0; i < 5; i++) {
    //     articleList.add(response['newslist'][i]);
    //   }
    //   loading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${widget.article['title']}'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                Center(
                  child: Container(
                    width: ScreenUtil().setWidth(800),
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(50),
                    ),
                    child: Text(
                      '${widget.article['title']}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(60),
                        color: Color(0xff353535),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: ScreenUtil().setWidth(700),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          '${widget.article['postdate'].toString().substring(0, 10)} ${widget.article['postdate'].toString().substring(11, 16)}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(36),
                            color: Color(0xff959595),
                          ),
                        ),
                        Text(
                          '${articleDetail['newssource']}(${articleDetail['newsauthor']})',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(36),
                            color: Color(0xff959595),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Html(
                  data: """
              ${articleDetail['detail']}
              """,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '责任编辑：${articleDetail['newsauthor']}',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                            color: Color(0xff656565),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 10.0,
                      height: 30.0,
                      color: Color(0xfff44f44),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '相关文章',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(50),
                        color: Color(0xff353535),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: _newsRow(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10.0,
                    ),
                    Icon(
                      Icons.chrome_reader_mode,
                      size: ScreenUtil().setSp(70),
                      color: Color(0xffFF0000),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '全部评论',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(50),
                        color: Color(0xffFF0000),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey[300],
                ),
                Column(
                  children: _CommentRow(),
                ),
              ],
            ),
    );
  }

  //新闻列表单个item
  List<Widget> _newsRow() {
    List<Widget> children = [];
    for (var i = 0; i < articleList.length; i++) {
      children.add(
        _generateOnePicItem(articleList[i]),
      );
    }
    return children;
  }

  List<Widget> _CommentRow() {
    List<Widget> children = [];
    for (var i = 0; i < articleComments.length; i++) {
      children.add(
        _commentItem(articleComments[i]),
      );
    }
    return children;
  }

  _commentItem(Map commentInfo) {
    var phoneColor =
        int.parse('0xff${commentInfo['M']['Ci'].toString().substring(0, 6)}');
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
        vertical: ScreenUtil().setHeight(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      'http://avatar.ithome.com/avatars/000/19/21/10_60.jpg'),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(10),
                    horizontal: ScreenUtil().setWidth(20),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Text(
                    'LV.${commentInfo['M']['Ul']}',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                      color: Color(0xff656565),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '${commentInfo['M']['N']}',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                color: Color(0xff353535),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              '${commentInfo['M']['Ta']}',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                color: Color(phoneColor),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '${commentInfo['M']['Y']}',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(32),
                                color: Color(0xff959595),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              '${commentInfo['M']['T'].toString().substring(0, 10)}',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(32),
                                color: Color(0xff959595),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${commentInfo['M']['SF']}',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(36),
                        color: Color(0xff656565),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  children: <Widget>[
                    Text(
                      '${commentInfo['M']['C']}',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(46),
                        color: Color(0xff353535),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '反对(${commentInfo['M']['S']})',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(36),
                        color: Color(0xff43CD80),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '支持(${commentInfo['M']['A']})',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(36),
                        color: Color(0xffFF0000),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '回复',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(36),
                        color: Color(0xff656565),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //仅有一个图片时的效果
  _generateOnePicItem(Map newsInfo) {
    double screenWidth = MediaQuery.of(context).size.width;
    //屏幕左右的PADDING
    double screenPadding = 15.0;
    //每个图片中间的空格
    double wrapSpacing = 5.0;
    //rowWidth
    double rowWidth = screenWidth - screenPadding * 2;
    //计算每个图片的宽度，多减掉0.1避免换行
    double imageWidth = (rowWidth - wrapSpacing * 2) / 3 - 0.5;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ArticleDetailPage(article: newsInfo),
            ));
      },
      child: Container(
        padding: EdgeInsets.only(
            left: screenPadding,
            top: wrapSpacing,
            right: screenPadding,
            bottom: wrapSpacing),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: imageWidth,
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider('${newsInfo['image']}'),
                    ),
                  ),
                ),
                Container(
                  height: 80.0,
//                color: Colors.black87,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: rowWidth - (imageWidth + 10.0),
                        child: Text(
                          '${newsInfo["title"]}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                            color: Color(0xff353535),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        width: rowWidth - (imageWidth + 10.0),
                        margin: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${newsInfo["postdate"].toString().substring(0, 10)} ${newsInfo["postdate"].toString().substring(11, 19)}',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(32),
                                color: Color(0xff959595),
                              ),
                            ),
                            new Text(
                              '${newsInfo["commentcount"]}评',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(32),
                                color: Color(0xff959595),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black12,
                    //width: 0.5
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
