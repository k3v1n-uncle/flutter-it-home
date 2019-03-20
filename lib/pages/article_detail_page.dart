import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:it_home/tools/Ajax.dart';
import 'package:it_home/tools/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';

class ArticleDetailPage extends StatefulWidget {
  final Map article; //新闻类型
  @override
  ArticleDetailPage({
    Key key,
    this.article,
  }) : super(key: key);

  ArticleDetailPageState createState() => new ArticleDetailPageState();
}

class ArticleDetailPageState extends State<ArticleDetailPage> {
  Map articleDetail = {};
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadArticleDetail();
  }

  void dispose() {
    super.dispose();
  }

  Future loadArticleDetail() async {
    String url = Api.articleDetail + widget.article['newsid'].toString();
    var data = {
      'pageIndex': 1,
    };
    var response = await HttpUtil().get(url, data: data);
    setState(() {
      articleDetail = response;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2220)..init(context);
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
                    width: ScreenUtil.getInstance().setWidth(800),
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil.getInstance().setHeight(50),
                    ),
                    child: Text(
                      '${widget.article['title']}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: ScreenUtil(allowFontScaling: true).setSp(60),
                        color: Color(0xff353535),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: ScreenUtil.getInstance().setWidth(700),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${widget.article['postdate'].toString().substring(0, 10)} ${widget.article['postdate'].toString().substring(11, 16)}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize:
                                ScreenUtil(allowFontScaling: true).setSp(36),
                            color: Color(0xff959595),
                          ),
                        ),
                        Text(
                          '${articleDetail['newssource']}(${articleDetail['newsauthor']})',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize:
                                ScreenUtil(allowFontScaling: true).setSp(36),
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
                  //Optional parameters:
                  padding:
                      EdgeInsets.all(ScreenUtil.getInstance().setWidth(40)),
                  backgroundColor: Colors.white70,
                  defaultTextStyle: TextStyle(
//                    fontFamily: 'serif',
                    fontSize: ScreenUtil().setSp(48),
                  ),
                  linkStyle: TextStyle(
//                    fontSize: ScreenUtil(allowFontScaling: true).setSp(48),
                    color: Color(0xfff44f44),
                  ),
                  onLinkTap: (url) {
                    // open url in a webview
                  },
                  customRender: (node, children) {
//              if(node is dom.Element) {
//                switch(node.localName) {
//                  case "video": return Chewie(...);
//                  case "custom_tag": return CustomWidget(...);
//                }
//              }
                  },
                )
              ],
            ),
    );
  }

  //新闻列表单个item
  Widget _newsRow(newsInfo) {
    if (newsInfo["imagelist"] != null) {
      return _generateThreePicItem(newsInfo);
    } else {
      return _generateOnePicItem(newsInfo);
    }
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
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (BuildContext context) =>
//                  ArticleDetailScreen(articleId: this.articleId.toString()),
//            ));
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
//                  child: CachedNetworkImage(
//                    imageUrl: '${newsInfo['image']}',
//                    fadeInDuration: const Duration(milliseconds: 100),
//                    fadeOutDuration: const Duration(milliseconds: 100),
//                    fit: BoxFit.cover,
//                    width: imageWidth,
//                    height: 80.0,
//                  ),
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
                            fontSize:
                                ScreenUtil(allowFontScaling: true).setSp(42),
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
                                fontSize: ScreenUtil(allowFontScaling: true)
                                    .setSp(32),
                                color: Color(0xff959595),
                              ),
                            ),
                            new Text(
                              '${newsInfo["commentcount"]}评',
                              style: TextStyle(
                                fontSize: ScreenUtil(allowFontScaling: true)
                                    .setSp(32),
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

  //有三张图片时的效果
  _generateThreePicItem(Map newsInfo) {
    double screenWidth = MediaQuery.of(context).size.width;
    //屏幕左右的PADDING
    double screenPadding = 15.0;
    //每个图片中间的空格
    double wrapSpacing = 5.0;
    //Row_width
    double rowWidth = screenWidth - screenPadding * 2;
    //计算每个图片的宽度，多减掉0.1避免换行

    return new InkWell(
      onTap: () {
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (BuildContext context) =>
//                  ArticleDetailScreen(articleId: this.articleId.toString()),
//            ));
      },
      child: Container(
          padding: EdgeInsets.only(
              left: screenPadding,
              top: wrapSpacing,
              right: screenPadding,
              bottom: wrapSpacing),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${newsInfo["title"]}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: ScreenUtil(allowFontScaling: true).setSp(40),
                    color: Color(0xff353535),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  width: rowWidth,
                  child: Wrap(
                      spacing: wrapSpacing, // gap between adjacent chips
                      children: _createImageChildren(
                          newsInfo['imagelist'], rowWidth, wrapSpacing)),
                ),
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${newsInfo["postdate"].toString().substring(0, 10)} ${newsInfo["postdate"].toString().substring(11, 19)}',
                          style: TextStyle(
                            fontSize:
                                ScreenUtil(allowFontScaling: true).setSp(32),
                            color: Color(0xff959595),
                          ),
                        ),
                        new Text(
                          '${newsInfo["commentcount"]}',
                          style: TextStyle(
                            fontSize:
                                ScreenUtil(allowFontScaling: true).setSp(32),
                            color: Color(0xff959595),
                          ),
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                        color: Colors.black12,
                        //width: 0.5
                      ))),
                )
              ])),
    );
  }

  List<Widget> _createImageChildren(mainAddonUrls, rowWidth, wrapSpacing) {
    double imageWidth = 0.0;
    int imageLength = mainAddonUrls.length;
    if (imageLength > 3) {
      imageLength = 3;
    }
    if (imageLength > 0) {
      imageWidth = (rowWidth - wrapSpacing * 2) / imageLength - 0.5;
    }
    List<Widget> children = [];
    int currentLength = 1;
    for (var mainPhotoUrl in mainAddonUrls) {
      if (currentLength > 3) {
        break;
      }
      currentLength++;

      children.add(CachedNetworkImage(
          imageUrl: mainPhotoUrl,
          fadeInDuration: const Duration(milliseconds: 100),
          fadeOutDuration: const Duration(milliseconds: 100),
          fit: BoxFit.cover,
          width: imageWidth,
          height: 80.0));
    }
    return children;
  }
}
